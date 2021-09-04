import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tmdb_app/screens/widgets/movie_list.dart';
import 'package:flutter_tmdb_app/screens/movie_detail_page.dart';
import '../constants.dart';
import '../api/api.dart';
import '../api/tmdb/movies_response.dart';
import './info_page.dart';
import '../api/tmdb/movie.dart';

/// 前後数か月公開の映画の一覧です
class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  Api api = Api();
  int page = 1;
  bool hasNextPage = false;
  List<Movie> movies = <Movie>[];
  DateTime? lastRequestedAt;

  /// コンストラクタ
  _MainPageState();

  @override
  void initState() {
    super.initState();
    requestAPIs(this.page);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<int> requestAPIs(int page) async{
    try {
      print("requestAPIs page: $page");

      if (page == 1 || lastRequestedAt == null) {
        lastRequestedAt = DateTime.now();
      }

      MoviesResponse res = await api.requestMoviesForMainPage(null, page);
      this.hasNextPage = res.page.hasNext();
      if (res.movies.length > 0) {
        setState(() {
          this.movies.addAll(res.movies);
        });
      }
      return page;
    }catch(e){
      return page;
    }
  }

  Future<void> _onRefresh() async{
    try {
      final Completer<void> completer = Completer<void>();

      final diff = lastRequestedAt != null ? DateTime
          .now()
          .difference(lastRequestedAt!)
          .inHours : 0;
      print("diff $diff");

      if (diff < 1) {
        Timer(const Duration(seconds: 2), () {
          completer.complete();
        });
      } else {
        this.page = 1;
        setState(() {
          this.movies = <Movie>[];
        });
        await requestAPIs(this.page);
        completer.complete();
      }
      return completer.future.then<void>((_) {});
    }catch(e){
      print("MainPage#_onRefresh $e");
    }
  }

  Future<void> _onEndReached() async{
    try{
      if (api.isRequesting == false && this.hasNextPage == true) {
        this.page += 1;
        requestAPIs(this.page);
      }
    }catch(e){
      print("MainPage#_onEndReached $e");
    }
  }

  /// 詳細ページを開く
  void _onPress(Movie movie){
    try {
      var page = MovieDetailPage(movie: movie,);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => page),
      );
    }catch(e){
      print("MainPage#_onPress $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget infoItem = IconButton(
        icon: Icon(Icons.info),
        onPressed: (){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => InfoPage())
          );
        });

    var appBar = AppBar(
      title: Text(Constant.app.mainTitle),
      actions: [infoItem],
    );

    return Scaffold(
      appBar: appBar,
      body: MovieList(
          movies: movies,
          isLoading: this.api.isRequesting,
          hasNext: this.hasNextPage,
          onRefresh: _onRefresh,
          onEndReached: _onEndReached,
          onPress: _onPress,
      )
    );
  }
}