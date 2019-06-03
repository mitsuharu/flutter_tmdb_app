import 'package:flutter/material.dart';
import '../models/tmdb_models.dart';


class SpaceBox extends SizedBox {
  SpaceBox({double width = 8, double height = 8})
      : super(width: width, height: height);

  SpaceBox.width([double value = 8]) : super(width: value);
  SpaceBox.height([double value = 8]) : super(height: value);
}

class MovieCard extends StatefulWidget {

  final MovieDetail movie;
  final VoidCallback onTapCell;
  final VoidCallback onTapIcon;

  MovieCard({this.movie, this.onTapCell, this.onTapIcon});

  @override
  _MovieCardState createState() => _MovieCardState(movie, onTapCell, onTapIcon);
}

class _MovieCardState extends State<MovieCard> {
  MovieDetail movie;
  VoidCallback onTapCell;
  VoidCallback onTapIcon;

  _MovieCardState(this.movie, this.onTapCell, this.onTapIcon);

  @override
  Widget build(BuildContext context) {

    var imageUrl = this.movie.posterUrl(PosterSize.normal);
    const double cartHeight = 115.0;
    const double padding = 16.0;
    const double imageHeight = cartHeight - padding;

    return InkWell(
      onTap: () {
        if (this.onTapCell != null){
          this.onTapCell();
        }
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
                child: FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  placeholder: 'lib/images/no_poster_image.png',
                  image: imageUrl,
                ),
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
                  icon: new Icon(Icons.calendar_today, size: 18.0), // event
                  onPressed: (){
                    print("add to calendar");
                    if (this.onTapIcon != null){
                      this.onTapIcon();
                    }
                  },
                ) ,
              )
            ],
          ),
        ),
      ),
    );

//    return Padding(
//      padding: const EdgeInsets.all(padding),
//      child: Container(
////        height: cartHeight,
//        child: Row(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          mainAxisAlignment: MainAxisAlignment.start,
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//            Container(
//              height: imageHeight,
//              width: imageHeight * 2.0/3.0,
//              child: FadeInImage.assetNetwork(
//                fit: BoxFit.cover,
//                placeholder: 'lib/images/no_poster_image.png',
//                image: imageUrl,
//              ),
//            ),
//            SpaceBox.width(16),
//
//            Expanded(child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(widget.movie.title,
//                      style: TextStyle(fontWeight: FontWeight.bold)),
//                  Text(widget.movie.releasedAt()),
//                  Text(widget.movie.overview,
//                    maxLines: 3,
//                    overflow: TextOverflow.ellipsis,
//                  ),]),
//            ),
//            SpaceBox.width(16),
//            Container(
//              height: cartHeight,
//              child: IconButton(
//                padding: new EdgeInsets.all(0.0),
//                icon: new Icon(Icons.calendar_today, size: 18.0),
//                onPressed: (){},
//              ) ,
//            )
//          ],
//        ),
//      ),
//    );
  }
}