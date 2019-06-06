import 'package:flutter/material.dart';
import '../constants.dart';

/// お知らせページ
class InfoPage extends StatefulWidget {
  InfoPage({Key key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {


  @override
  void initState() {
    super.initState();
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

    return Scaffold(
      appBar: appBar,
      body: Text("TMDb APIを使ってますよ，など．"),
    );
  }

}