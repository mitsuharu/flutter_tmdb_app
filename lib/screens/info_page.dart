import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../constants.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// お知らせページ
class InfoPage extends StatefulWidget {
  InfoPage({Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {

  String md = "";

  @override
  void initState() {
    super.initState();
    readMarkdown();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var appBar = AppBar(
      title: Text(Constant.info.title),
    );

    Widget body = md.length > 0
        ? Markdown(data: md)
        : Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }

  Future<void> readMarkdown() async{
    final String path = "lib/documents/info.md";
    final text = await rootBundle.loadString(path);
    setState(() {
      md = text;
    });
  }
}