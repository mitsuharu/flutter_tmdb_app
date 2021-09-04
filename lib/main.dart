import 'package:flutter/material.dart';
import 'package:flutter_tmdb_app/screens/main_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recent　Movies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.robotoTextTheme (
          Theme.of(context).textTheme,
        ),
      ),
      home: MainPage(),
    );
  }
}
