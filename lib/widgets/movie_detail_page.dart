import 'dart:async';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/api.dart';
import '../models/tmdb_models.dart';
import '../models/tmdb_responses.dart';
import '../widgets/movie_card.dart';

/// 動画詳細ページ
class MovieDetailPage extends StatefulWidget {

  MovieDetailPage({Key key, this.movie}) : super(key: key);


  final MovieDetail movie;

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetailPage> {

  MovieDetailResponse movieDetail = MovieDetailResponse();
  ApiManager ap = ApiManager();

  @override
  void initState() {
    super.initState();

    ap.requestMovieDetail(widget.movie.movieId).then((res){
      if(res != null && res is MovieDetailResponse){
        this.movieDetail = res;
        setState(() {

        });
      }
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: Center(
        child: Text("「${widget.movie.title}」の詳細です"),
      ),
    );
  }


//  Widget movieListWidget(){
//
//    /*
//    Flutterでスクロールを検知し、ある位置までスクロールしたらWidgetを表示するには · Androg
//https://kwmt27.net/2018/09/03/flutter-scroll/
//
//    */
//
//    var length = movies.length;
//    if (length == 0){
//      return Center(
//        child: Text(Constant.commons.notFound),
//      );
//    }
//
//    int itemCount = length;
//    if (this.hasNextPage){
//      itemCount += 1;
//    }
//
//    var listView = ListView.builder(
//      controller: _scrollController,
//      itemBuilder: (BuildContext context, int index) {
//
//        var title = Constant.commons.nowLoading;
//        if (index < this.movies.length){
//          MovieDetail movie = movies[index];
//          title = movie.title;
//
//          return Container(
//              decoration: BoxDecoration(
//                border: Border(
//                  bottom: BorderSide(color: Colors.black38),
//                ),
//              ),
//              child: MovieCard(
//                movie: movie,
//                onTapCell: (){
//                  print("[main][onTapCell]");
//                },
//                onTapIcon: (){
//                  print("[main][onTapIcon]");
//                },));
//        }else{
//          return Container(
//              height: 80,
//              padding: EdgeInsets.all(8),
//              child: Card(
//                  child: Center(
//                    child: Text(title),
//                  )
//              ));
//        }
//      },
//      itemCount: itemCount,
//    );
//
//    return RefreshIndicator(
//        onRefresh: _onRefresh,
//        child: listView);
//  }


}
