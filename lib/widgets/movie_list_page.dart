import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../constants.dart';
import '../models/api.dart';
import '../models/tmdb_models.dart';
import '../models/tmdb_responses.dart';
import '../widgets/movie_card.dart';
import '../widgets/movie_detail_page.dart';

/// 前後数か月公開の映画の一覧です
class MovieListPage extends StatefulWidget {
  MovieListPage({Key key, this.cast}) : super(key: key);

  final Cast cast;

  @override
  _MovieListState createState() => _MovieListState(cast: this.cast);
}

class _MovieListState extends State<MovieListPage> {

  Cast cast;

  String title;
  ApiManager ap = ApiManager();
  int page = 1;
  bool hasNextPage = false;
  List<MovieDetail> movies = <MovieDetail>[];

  // スクロール検知
  ScrollController _scrollController;

  /// コンストラクタ
  _MovieListState({this.cast});

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    if (this.cast == null){
      title = Constant.app.mainTitle;
    }else{
      title = "${this.cast.name}";
    }

    requestAPIs(this.page);

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  Future<int> requestAPIs(int page) async{

    int personId;
    if (this.cast != null){
      personId = this.cast.personId;
    }else{
      personId = null;
    }

    print("[requestAPIs] personId: $personId, page: $page");

    MoviesResponse res = await ap.requestMoviesForMainPage(personId, page);
    if (res != null){
      this.hasNextPage = res.page.hasNext();

      print("[requestAPIs] len: ${res.movies.length}");

      if(res.movies.length > 0){
        setState(() {
          this.movies.addAll(res.movies);
        });
      }
    }
    return page;
  }

  @override
  Widget build(BuildContext context) {

//    ap.doSamples();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
        child: CircularProgressIndicator(), // Text(Constant.commons.notFound),
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
                  _showMovieDetailPage(movie);
                },
                onTapIcon: (){
                  _registerToCalendar(movie);
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

  /// 詳細ページを開く
  void _showMovieDetailPage(MovieDetail movie){
    var page = MovieDetailPage(movie: movie,);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// カレンダーに登録する
  void _registerToCalendar(MovieDetail movie){
    print("register movie info to calendar");

    movie.addToCalendar().then((result){
      var str = Constant.cal.successMessage;
      if (result == false){
        str = Constant.cal.errorMessage;
      }
      Toast.show(str, context);
    });


  }


  Future<void> _onRefresh() async{

    print("[_onRefresh]");

    final Completer<void> completer = Completer<void>();

    this.page = 1;
    setState(() {
      this.movies = <MovieDetail>[];
    });

    await requestAPIs(this.page).then((value){
      print("[_onRefresh] comple");
    });
    completer.complete();

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
      requestAPIs(this.page);
    }
  }


}
