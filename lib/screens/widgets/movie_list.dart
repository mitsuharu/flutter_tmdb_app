import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tmdb_app/screens/widgets/movie_item.dart';
import '../../constants.dart';
import '../../api/tmdb/movie.dart';

/// 前後数か月公開の映画の一覧です
class MovieList extends StatefulWidget {

  final List<Movie> movies;
  final bool isLoading;
  final bool hasNext;
  final AsyncCallback onRefresh;
  final AsyncCallback onEndReached;
  final ValueSetter<Movie> onPress;

  MovieList({
    required this.movies,
    required this.isLoading,
    required this.hasNext,
    required this.onRefresh,
    required this.onEndReached,
    required this.onPress,
  });

  @override
  _MovieListState createState() => _MovieListState(
      movies,
      isLoading,
      hasNext,
      onRefresh,
      onEndReached,
      onPress,
  );
}

class _MovieListState extends State<MovieList> {

  List<Movie> movies = <Movie>[];
  bool isLoading = false;
  bool hasNext = false;
  AsyncCallback onRefresh =  (() async {});
  AsyncCallback onEndReached =  (() async {});
  ValueSetter<Movie> onPress =  ((_) {});

  // スクロール検知
  ScrollController _scrollController = ScrollController();

  /// コンストラクタ
  _MovieListState(
      this.movies,
      this.isLoading,
      this.hasNext,
      this.onRefresh,
      this.onEndReached,
      this.onPress,
      );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // スクロールを検知したときに呼ばれる
  void _scrollListener() {
    double positionRate =
        _scrollController.offset / _scrollController.position.maxScrollExtent;
    const threshold = 0.8;
    if (positionRate > threshold) {
      onEndReached();
    }
  }

  Widget movieListWidget(){

    if (isLoading && movies.length == 0){
      return Center(
        child: CircularProgressIndicator(), // Text(Constant.commons.notFound),
      );
    }

    var listView = ListView.builder(
      controller: _scrollController,
      itemCount: movies.length + (hasNext == true ? 1 : 0),
      itemBuilder: (BuildContext context, int index) {

        var title = Constant.commons.nowLoading;
        if (index < this.movies.length){
          Movie movie = movies[index];
          title = movie.title;

          return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black38),
                ),
              ),
              child: MovieItem(
                movie: movie,
                onTapCell: (){
                  this.onPress(movie);
                },
              ),
          );
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
    );


    return RefreshIndicator(
        onRefresh: () async {
          onRefresh();
        },
        child: listView);
  }

  @override
  Widget build(BuildContext context) {
    return movieListWidget();
  }
}
