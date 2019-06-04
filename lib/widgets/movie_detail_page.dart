import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
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

  MovieDetailResponse movieDetail;
  ApiManager ap;

  List<Widget> _items = <Widget>[];

  double imageAspect;

  @override
  void initState() {
    super.initState();

    imageAspect = 1.0;

    for (var i = 0; i < 10; i++){
      var item = Container(
        color: i.isOdd ? Colors.blue : Colors.white,
        height: 100,
        child: Center(
          child: Text(
            "No $i",
            style: TextStyle(fontSize: 32),),
        )
      );
      _items.add(item);
    }

    ap = ApiManager();
    ap.requestMovieDetail(widget.movie.movieId).then((res){
      if(res != null && res is MovieDetailResponse){
        setState(() {
          this.movieDetail = res;
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

    return scaffoldWidget();
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.movie.title),
//      ),
//      body: Center(
//        child: bodyWidget()
//      ),
//    );
  }

  Scaffold scaffoldWidget(){

    var appBar = AppBar(
//      title: Text(widget.movie.title),
    );

    if (movieDetail == null){
      return Scaffold(
        appBar: appBar,
        body: Center(
            child: CircularProgressIndicator(),
        ),
      );
    }else{
      return Scaffold(
        appBar: appBar,
        body: bodyWidget(),
      );
    }

  }


  Widget bodyWidget(){

//    if (movieDetail == null){
//      return Center(
//        child: CircularProgressIndicator(),
//      );
//    }

    final Size size = MediaQuery.of(context).size;
    var imageUrl = movieDetail.movie.posterUrl(PosterSize.large);

    var listView = ListView.builder(
        itemBuilder: (BuildContext context, int index){
          if (index == 0){
            return titleCell(movieDetail.movie.title);
          }
          if (index == 1){
            if (imageUrl != null){
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Container(
                  width: size.width,
                  child: Image.network(imageUrl, fit: BoxFit.contain),
                )
              );
            }else{
              return null;
            }
          }else{
            return paddingCell(movieDetail.movie.overview);

//            return Container(
//                color: index.isOdd ? Colors.blue : Colors.white,
//
//                child: Center(
//                  child: Text(
//                    "祇園精舎の鐘の声、諸行無常の響きあり。沙羅双樹の花の色、盛者必衰の理をあらはす。おごれる人も久しからず。ただ春の夜の夢のごとし。たけき者も遂にはほろびぬ、ひとへに風の前の塵に同じ。 ",
//                    style: TextStyle(fontSize: 32),),
//                )
//            );
          }
        },
        itemCount: 10,
    );


    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: listView
    );

  }

  Widget titleCell(string){
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        child: Center(
          child: Text(
            string, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }


  Widget paddingCell(string){
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black38),
          ),
        ),
        child: ListTile(
          title: Text(string),
        ),
      ),
    );
  }


  Future<ui.Image> _getImage(String url) {
    Completer<ui.Image> completer = new Completer<ui.Image>();
    new NetworkImage(url)
        .resolve(new ImageConfiguration())
        .addListener((ImageInfo info, bool _) => completer.complete(info.image));
    return completer.future;
  }


}
