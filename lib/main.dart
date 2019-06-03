import 'package:flutter/material.dart';
import 'models/api.dart';
import 'models/tmdb_models.dart';
import 'models/tmdb_responses.dart';
import 'constants.dart';

import 'dart:async';

import 'widgets/movie_card.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  ApiManager ap = ApiManager();
  int page = 1;
  bool hasNextPage = false;
  List<MovieDetail> movies = <MovieDetail>[];


  // スクロール検知
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    ap.requestMovies(this.page).then((response){
      if (response != null && response is MoviesResponse){
        this.hasNextPage = response.page.hasNext();
        if(response.movies.length > 0){
          setState(() {
            this.movies.addAll(response.movies);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

//    ap.doSamples();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: movieListWidget(),
    );
  }


  Widget movieListWidget(){

    /*
    Flutterでスクロールを検知し、ある位置までスクロールしたらWidgetを表示するには · Androg
https://kwmt27.net/2018/09/03/flutter-scroll/

    */

    var length = movies.length;
    if (length == 0){
      return Center(
        child: Text(Constant.commons.notFound),
      );
    }

    int itemCount = length;
    if (this.hasNextPage){
      itemCount += 1;
    }

    var listView = ListView.builder(
      controller: _scrollController,
      itemBuilder: (BuildContext context, int index) {

        var title = Constant.commons.nowLoading;
        if (index < this.movies.length){
          MovieDetail movie = movies[index];
          title = movie.title;

          return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black38),
                ),
              ),
              child: MovieCard(
                movie: movie,
                onTapCell: (){
                  print("[main][onTapCell]");
                },
                onTapIcon: (){
                  print("[main][onTapIcon]");
                },));
        }else{
          return Container(
              height: 80,
              padding: EdgeInsets.all(8),
              child: Card(
                child: Center(
                  child: Text(title),
                )
              ));
        }
      },
      itemCount: itemCount,
    );

    return RefreshIndicator(
        onRefresh: _onRefresh,
        child: listView);
  }


  Future<void> _onRefresh(){
    print("pull to refresh");

    // https://sbfl.net/blog/2015/01/05/writing-asynchronous-operation-with-future-in-dart/

    // https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/overscroll_demo.dart


    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () { completer.complete(); });
    return completer.future.then<void>((_) {});

  }

  // スクロールを検知したときに呼ばれる
  void _scrollListener() {
    double positionRate =
        _scrollController.offset / _scrollController.position.maxScrollExtent;

    const threshold = 0.8;
    if (positionRate > threshold
        && ap.isRequesting == false && this.hasNextPage == true) {
      this.page += 1;
      ap.requestMovies(this.page).then((response){
        if (response != null && response is MoviesResponse){
          this.hasNextPage = response.page.hasNext();
          if(response.movies.length > 0){
            setState(() {
              this.movies.addAll(response.movies);
            });
          }
        }
      });
    }
  }


}
