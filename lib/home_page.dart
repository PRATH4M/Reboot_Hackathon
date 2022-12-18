import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contentu/article.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot<Map<String, dynamic>>> newsStream =
      FirebaseFirestore.instance
          .collection("news")
          .orderBy("published_time", descending: true)
          .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Newsfeed"),
        actions: [
          IconButton(
            icon: Icon(Icons.create),
            onPressed: () {
              final mailtoLink = Mailto(
                to: ['pratham_s@outlook.com'],
                subject: 'News Article for ConnectU',
              );
              launchUrlString('$mailtoLink');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: newsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final newsCards = snapshot.requireData.docs;

              return newsCards.isEmpty
                  ? Center(child: Text("No News Available :("))
                  : ListView.builder(
                      itemCount: newsCards.length,
                      itemBuilder: (context, index) {
                        var ncard = newsCards[index];
                        String title = ncard["title"];
                        String content = ncard["content"];
                        content = content.replaceAll("\\n", "\n\n");
                        Timestamp pub = ncard["published_time"];
                        DateTime pub_dt = pub.toDate();
                        String pub_str =
                            DateFormat('MM/dd/yyyy hh:mm a').format(pub_dt);
                        return Padding(
                          padding: const EdgeInsets.all(0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => ArticlePage(
                                          title: title,
                                          pub_str: pub_str,
                                          content: content))));
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ncard["title"],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "published: " + pub_str,
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.grey),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      content,
                                      maxLines: 7,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
            }),
      ),
    );
  }
}
