import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ArticlePage extends StatelessWidget {
  ArticlePage(
      {super.key,
      required this.title,
      required this.pub_str,
      required this.content});
  String title;
  String content;
  String pub_str;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Article"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: ListView(
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "published: " + pub_str,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                content,
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        ));
  }
}
