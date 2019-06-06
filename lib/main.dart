import 'package:flutter/material.dart';
import 'widgets/movie_list_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recent　Movies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MovieListPage(cast: null),
    );
  }
}
