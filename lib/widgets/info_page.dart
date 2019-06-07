import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../constants.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

/// お知らせページ
class InfoPage extends StatefulWidget {
  InfoPage({Key key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {

  String md;

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

    Widget body = Center(
      child: CircularProgressIndicator(),
    );
    if (md != null && md.length > 0){
      body = Markdown(data: md);
    }

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }

  Future<void> readMarkdown() async{
    final String path = "lib/docments/info.md";
    rootBundle.loadString(path).then((data){
      setState(() {
        md = data;
      });
    });
  }

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

}