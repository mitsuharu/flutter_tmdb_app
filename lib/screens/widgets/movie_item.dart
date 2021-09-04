import 'package:flutter/material.dart';
import 'package:flutter_tmdb_app/constants.dart';
import 'package:flutter_tmdb_app/util/calendar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../api/tmdb/util.dart';
import '../../api/tmdb/movie.dart';

class SpaceBox extends SizedBox {
  SpaceBox({double width = 8, double height = 8})
      : super(width: width, height: height);

  SpaceBox.width([double value = 8]) : super(width: value);
  SpaceBox.height([double value = 8]) : super(height: value);
}

class MovieItem extends StatefulWidget {

  final Movie movie;
  final VoidCallback onTapCell;

  MovieItem({required this.movie, required this.onTapCell});

  @override
  _MovieItemState createState() => _MovieItemState(movie, onTapCell);
}

class _MovieItemState extends State<MovieItem> {
  Movie movie;
  VoidCallback onTapCell;

  _MovieItemState(this.movie, this.onTapCell);

  /// カレンダーに登録する
  Future<void> _registerToCalendar() async {
    try {
      var result = await UtilCalendar.addToCalendar(
          movie.title,
          movie.releaseDate!);
      var str = result
          ? Constant.cal.successMessage
          : Constant.cal.errorMessage;
      Fluttertoast.showToast(msg: str);
    }catch(e){
      print("MovieItem#_registerToCalendar $e");
      Fluttertoast.showToast(msg: Constant.cal.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {

    var imageUrl = this.movie.posterUrl(PosterSize.normal);
    const double cartHeight = 115.0;
    const double padding = 16.0;
    const double imageHeight = cartHeight - padding;

    Widget imageWidget = Image.asset('lib/images/no_poster_image.png');
    if (imageUrl.length > 0){
      imageWidget = FadeInImage.assetNetwork(
        fit: BoxFit.cover,
        placeholder: 'lib/images/no_poster_image.png',
        image: imageUrl,
      );
    }

    return InkWell(
      onTap: () {
        onTapCell();
      },
      child: Padding(
        padding: const EdgeInsets.all(padding),
        child: Container(
//        height: cartHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: imageHeight,
                width: imageHeight * 2.0/3.0,
                child: imageWidget,
              ),
              SpaceBox.width(16),

              Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.movie.title,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.movie.releasedAt()),
                    Text(widget.movie.overview,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),]),
              ),
              SpaceBox.width(16),
              Container(
                height: cartHeight,
                child: IconButton(
                  padding: new EdgeInsets.all(0.0),
                  icon: new Icon(Icons.event, size: 18.0), // event
                  onPressed: (){
                    print("add to calendar");
                    _registerToCalendar();
                  },
                ) ,
              )
            ],
          ),
        ),
      ),
    );
  }
}