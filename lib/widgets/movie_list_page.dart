import 'dart:async';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/api.dart';
import '../models/tmdb_models.dart';
import '../models/tmdb_responses.dart';
import '../widgets/movie_card.dart';
import '../widgets/movie_detail_page.dart';

/// 前後数か月公開の映画の一覧です
class MovieListPage extends StatefulWidget {
  MovieListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieListPage> {

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
