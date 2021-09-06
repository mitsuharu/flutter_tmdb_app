import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tmdb_app/api/error.dart';
import 'package:flutter_tmdb_app/api/tmdb/cast.dart';
import 'package:flutter_tmdb_app/constants.dart';
import 'package:flutter_tmdb_app/screens/widgets/empty_view.dart';
import 'package:flutter_tmdb_app/screens/widgets/movie_list.dart';
import 'package:flutter_tmdb_app/screens/movie_detail_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../api/api.dart';
import '../api/tmdb/movies_response.dart';
import '../api/tmdb/movie.dart';

/// キャスト指定の前後数か月公開の映画の一覧です
class CastPage extends StatefulWidget {

  final Cast cast;

  CastPage({Key? key, required this.cast}) : super(key: key);

  @override
  _CastPageState createState() => _CastPageState();
}

class _CastPageState extends State<CastPage> {

  Api api = Api();
  int page = 1;
  RequestStatus requestStatus = RequestStatus.initial;
  bool hasNext = true;
  List<Movie> movies = <Movie>[];

  @override
  void initState() {
    super.initState();
    requestAPIs(this.page);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> requestAPIs(int page) async{
    try {
      setState(() {
        requestStatus = RequestStatus.loading;
      });
      MoviesResponse res = await api.requestMoviesWithCast(widget.cast.personId, page);
      var nextMovies = movies + res.movies;
      setState(() {
        movies = nextMovies;
        requestStatus = nextMovies.length == 0 ? RequestStatus.empty : RequestStatus.success;
        hasNext = api.hasNext;
      });
    }catch(e){
      print("CastPage#requestAPIs $e, ${api.requestStatus}");
      setState(() {
        requestStatus =  movies.length == 0 ? RequestStatus.empty : RequestStatus.failed;
      });
      if (e is NetworkError){
        Fluttertoast.showToast(msg: Constant.error.networkFailed);
      }
    }
  }

  Future<void> _onRefresh() async{
    try {
      this.page = 1;
      setState(() {
        this.movies = <Movie>[];
        requestStatus = RequestStatus.initial;
        hasNext = true;
      });
      await requestAPIs(this.page);
    }catch(e){
      print("CastPage#_onRefresh $e");
    }
  }

  Future<void> _onEndReached() async{
    try{
      if (requestStatus != RequestStatus.loading && hasNext == true) {
        this.page += 1;
        requestAPIs(this.page);
      }
    }catch(e){
      print("CastPage#_onEndReached $e");
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
      print("CastPage#_onPress $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    var appBar = AppBar(
      title: Text(widget.cast.name),
      actions: [],
    );

    return Scaffold(
        appBar: appBar,
        body: requestStatus == RequestStatus.empty
            ? EmptyView(onPress: _onRefresh)
            : MovieList(movies: movies,
          isLoading: api.requestStatus == RequestStatus.loading,
          hasNext: api.hasNext,
          onRefresh: _onRefresh,
          onEndReached: _onEndReached,
          onPress: _onPress,
        )
    );
  }
}
