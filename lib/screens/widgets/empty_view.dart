import 'package:flutter/material.dart';

class EmptyView extends StatefulWidget {

  final VoidCallback onPress;

  EmptyView({required this.onPress});

  @override
  _EmptyViewState createState() => _EmptyViewState();
}

class _EmptyViewState extends State<EmptyView> {

  final message = "見つかりませんでした";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sentiment_dissatisfied_rounded,
            color: Colors.grey,
            size: 128.0),
          Center(
            child: Text(message, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          ),
          SizedBox(height: 10,),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            label: const Text('更新する'),
            onPressed: widget.onPress,
          ),
        ],
      ),
    );
  }
}