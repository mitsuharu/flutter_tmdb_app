import 'package:intl/intl.dart';


/*
  TODO: 画像URLをサイズ別に動的に取得できるようにする．

* */

class Util{

  //     // "release_date": "2019-04-24",

  static DateFormat _dateFormat(){
    var format = DateFormat("yyyy-MM-dd");
    return format;
  }

  static String date2string(DateTime date){
    var format = Util._dateFormat();
    var str = format.format(date);
    return str;
  }

  static DateTime string2date(String str){
    var format = Util._dateFormat();
    return format.parse(str);
  }

}

class Tmdb{

  static String _baseUrl = "api.themoviedb.org";
  static String _pathMovie = "3/movie/";

  static var _params = {
    "api_key": "6248dc054117576021d2a134b30dc48e",
    "language": 'ja',
  };

  /// 動画詳細用のURI
  static uriMovieDetail(int movieId){
    if(movieId == null){
      return null;
    }
    var uri = Uri.https(
        Tmdb._baseUrl,
        "${Tmdb._pathMovie}$movieId",
        Tmdb._params);
    return uri;
  }

}


/// 動画詳細のクラス
class MovieDetail{
  int movieId;
  bool isAdult;
  String title;
  String overview;
  String homepage;
  String posterPath;
  String status;

  Collection collection;

  List<Genre> genres = <Genre>[];

  DateTime releaseDate;

  MovieDetail(var json) {
    if(json == null){
      return;
    }

    this.movieId = json["id"];
    this.isAdult = json["adult"];
    this.title = json["title"];
    this.overview = json["overview"];
    this.homepage = json["homepage"];
    this.status = json["status"];

    this.collection = Collection(json["belongs_to_collection"]);
    
    this.genres = Genre.genresFormJsonList(json["genres"]);
    
    // サムネイル
    this.posterPath = "http://image.tmdb.org/t/p/w185" + json["poster_path"];

    // "release_date": "2019-04-24",
    this.releaseDate = Util.string2date(json["release_date"]);

  }
}


/// ジャンル
class Genre{
  int genreId;
  String name;

  Genre(var json) {
    if(json == null){
      return;
    }
    this.genreId = json["id"];
    this.name = json["name"];
  }

  static List<Genre> genresFormJsonList(var jsonList) {
    if(jsonList == null){
      return null;
    }

    List<Genre> genres = <Genre>[];
    for (var temp in jsonList){
      var genre = Genre(temp);
      if (genre != null && genre is Genre){
        genres.add(genre);
      }
    }
    return genres;
  }
}

/// コレクション（シリーズ）
class Collection{

  int collectionId;
  String name;
  String posterPath;
  String backdropPath;

  Collection(var json) {

    print("collection $json");

    if(json == null){
      return;
    }

    this.collectionId = json["id"];
    this.name = json["name"];

    // サムネイル
    this.posterPath = "http://image.tmdb.org/t/p/w185" + json["poster_path"];
    this.backdropPath = "http://image.tmdb.org/t/p/w185" + json["backdrop_path"];

  }

//  "id": 86311,
//  "name": "アベンジャーズ シリーズ",
//  "poster_path": "/qJawKUQcIBha507UahUlX0keOT7.jpg",
//  "backdrop_path": "/zuW6fOiusv4X9nnW3paHGfXcSll.jpg"
}