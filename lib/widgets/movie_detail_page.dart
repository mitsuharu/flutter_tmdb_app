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
import 'package:url_launcher/url_launcher.dart';

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
          
          print("casts.length: ${res.casts.length}");
          
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
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: (){
            print("press cal");
          },
        )
      ],
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

    List<Widget> items = <Widget>[];
    items.add(titleCell(movieDetail.movie.title));
    if (imageUrl != null) {
      var temp = Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Container(
            width: size.width,
            child: Image.network(imageUrl, fit: BoxFit.contain),
          )
      );
      items.add(temp);
    }
    if (movieDetail.movie.overview != null
        && movieDetail.movie.overview.length > 0){
      items.add(paddingCell(movieDetail.movie.overview));
    }
    if (movieDetail.movie.homepage != null
        && movieDetail.movie.homepage.length > 0){
      items.add(homepageCell());
    }
    if (movieDetail.casts != null){
      for (var cast in movieDetail.casts){
        items.add(castCell(cast));
      }
    }

    var listView = ListView(
      children: items,
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


  Widget paddingCell(String string){

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
         //   bottom: BorderSide(color: Colors.black38),
          ),
        ),
        child: ListTile(
          title: Text(string),
        ),
      ),
    );
  }

  Widget homepageCell(){
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            //   bottom: BorderSide(color: Colors.black38),
          ),
        ),
        child: Center(
          child: IconButton(
              icon: Icon(Icons.home),
              onPressed: (){
                var url = movieDetail.movie.homepage;
                print("url $url");
                if (url != null){
                  canLaunch(url).then((canOpen){
                    print("canOpen $canOpen");
                    if (canOpen == true){
                      launch(url);
                    }
                  });
                }
              }),
        ),
      ),
    );
  }

  Widget castCell(Cast cast){

    var cell = Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
          //     bottom: BorderSide(color: Colors.black38),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: 100,
              width: 80,
              child: FadeInImage.assetNetwork(
                fit: BoxFit.contain,
                placeholder: 'lib/images/no_poster_image.png',
                image: cast.profileUrl(PosterSize.normal),
              ),
            ),
            Container(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(cast.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(cast.character),
                ],
              ),
            )
          ],
        ),
      ),
    );

    return InkWell(
        onTap: () {
          print("tap actor cell");
        },
        child: cell);

  }


  Future<ui.Image> _getImage(String url) {
    Completer<ui.Image> completer = new Completer<ui.Image>();
    new NetworkImage(url)
        .resolve(new ImageConfiguration())
        .addListener((ImageInfo info, bool _) => completer.complete(info.image));
    return completer.future;
  }


}
