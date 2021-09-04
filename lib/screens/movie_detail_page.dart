import 'package:flutter/material.dart';
import 'package:flutter_tmdb_app/screens/cast_page.dart';
import 'package:flutter_tmdb_app/util/calendar.dart';
import '../constants.dart';
import '../api/api.dart';
import '../api/tmdb/movie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import '../api/tmdb/util.dart';
import '../api/tmdb/cast.dart';
import '../api/tmdb/movie_detail.dart';


/// 動画詳細ページ
class MovieDetailPage extends StatefulWidget {

  final Movie movie;

  MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetailPage> {

  MovieDetail? movieDetail;
  Api api = Api();

  @override
  void initState() {
    super.initState();
    api.requestMovieDetail(widget.movie.movieId).then((res){
      setState(() {
        this.movieDetail = res;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return scaffoldWidget();
  }

  Scaffold scaffoldWidget(){
    if (movieDetail == null){
      return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: CircularProgressIndicator(),
        ),
      );
    }else{
      return Scaffold(
        body: bodyWidget(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.event),
            onPressed: (){
              _addToCalendar();
            }),
      );
    }
  }

  void _addToCalendar() async{
    if (movieDetail != null) {
      var result = await UtilCalendar.addToCalendar(
          movieDetail!.movie.title,
          movieDetail!.movie.releaseDate!);
      var str = result
          ? Constant.cal.successMessage
          : Constant.cal.errorMessage;
      Fluttertoast.showToast(msg: str);
    }else{
      Fluttertoast.showToast(msg: Constant.cal.errorMessage);
    }
  }

  void _shareMovie(){
    if (movieDetail != null) {
      var text = movieDetail!.movie.title;
      if (movieDetail!.movie.homepage != null &&
          movieDetail!.movie.homepage!.length > 0) {
        text += " ${movieDetail!.movie.homepage}";
      }
      Share.share(text);
    }
  }


  Widget bodyWidget(){
    return contentSliverListView();
  }

  Widget contentSliverListView(){
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        forceElevated: true,
        pinned: false,
        flexibleSpace: FlexibleSpaceBar(
          title: null,
          background: null,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: (){
              _shareMovie();
            },
          ),
        ],
      ),
      SliverPadding(
        padding: EdgeInsets.all(16.0),
        sliver: SliverList(
            delegate: SliverChildListDelegate(contentsItems())),
      ),
    ]);

  }

  List<Widget> contentsItems(){

    final Size size = MediaQuery.of(context).size;
    var imageUrl = movieDetail!.movie.posterUrl(PosterSize.large);

    List<Widget> items = <Widget>[];
    items.add(titleCell(movieDetail!.movie.title));

    if (imageUrl != null && imageUrl.length > 0) {
      var temp = Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Container(
            width: size.width,
            child: Image.network(imageUrl, fit: BoxFit.contain),
          )
      );
      items.add(temp);
    }
    if (movieDetail!.movie.overview != null
        && movieDetail!.movie.overview.length > 0){
      items.add(paddingCell(movieDetail!.movie.overview));
    }

    items.add(dateCell());

    if (movieDetail!.movie.homepage != null
        && movieDetail!.movie.homepage!.length > 0){
      items.add(homepageCell());
    }
    if (movieDetail!.casts != null){
      for (var cast in movieDetail!.casts){
        items.add(castCell(cast));
      }
    }

    items.add(tmdbCell());


    return items;
  }

  Widget contentsListView(){

    var listView = ListView(
      children: contentsItems(),
    );
    return listView;
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
                var url = movieDetail!.movie.homepage;
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

  Widget dateCell(){
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            //   bottom: BorderSide(color: Colors.black38),
          ),
        ),
        child: Center(
          child: Text(
            movieDetail!.movie.releasedAt(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
        ),
      ),
    );
  }


  Widget castCell(Cast cast){

    var imageUrl = cast.profileUrl(PosterSize.normal);
    Widget imageWidget = Image.asset('lib/images/no_poster_image.png');
    if (imageUrl != null && imageUrl.length > 0){
      imageWidget = FadeInImage.assetNetwork(
        fit: BoxFit.contain,
        placeholder: 'lib/images/no_poster_image.png',
        image: imageUrl,
      );
    }

    var cell = Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              height: 100,
              width: 80,
              child: imageWidget,
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
          var page = CastPage(cast: cast);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => page),
          ).then((_){
            // page = null;
          });
        },
        child: cell);

  }

  Widget tmdbCell(){

    var btn = TextButton(
          onPressed: (){
            var url = movieDetail!.movie.tmdbUrl();
            if (url != null){
              canLaunch(url).then((canOpen){
                print("canOpen $canOpen");
                if (canOpen == true){
                  launch(url);
                }
              });
            }
          },
          child: Image.asset("lib/images/tmdb_poweredby.png"));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(),
        btn,
        Container(),
      ],
    );
  }
}
