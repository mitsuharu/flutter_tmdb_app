import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../util/calendar.dart';

enum PosterSize{
  normal, large
}

class TmdbUtil{

  //     // "release_date": "2019-04-24",

  static DateFormat _dateFormat(){
    var format = DateFormat("yyyy-MM-dd");
    return format;
  }

  static DateFormat _dateFormatJa(){
    initializeDateFormatting("ja_JP");

    var format = DateFormat("yyyy年M月d日(E)", "ja_JP");
    return format;
  }

  static String date2string(DateTime date){
    var format = TmdbUtil._dateFormat();
    var str = format.format(date);
    return str;
  }

  static String date2stringJa(DateTime date){
    var format = TmdbUtil._dateFormatJa();
    var str = format.format(date);
    return str;
  }

  static DateTime string2date(String str){
    var format = TmdbUtil._dateFormat();
    return format.parse(str);
  }

  static String posterUrl(String path, PosterSize size){
    const String baseUrl = "http://image.tmdb.org/t/p/";
    String tempSize = "w185";
    if (size != null){
      if (size == PosterSize.large){
        tempSize = "w342";
      }
    }
    return baseUrl + tempSize + path;
  }

  static String profileUrl(String path, PosterSize size){
    const String baseUrl = "http://image.tmdb.org/t/p/";
    String tempSize = "w185";
//    if (size != null){
//      if (size == PosterSize.large){
//        tempSize = "w342";
//      }
//    }
    return baseUrl + tempSize + path;
  }


}

class Tmdb{

  static String _baseUrl = "api.themoviedb.org";
  static String _pathMovie = "3/movie/";
  static String _pathDiscover = "3/discover/movie/";

  static var _params = {
    "api_key": "6248dc054117576021d2a134b30dc48e",
    "language": "ja",
    "region": "jp",
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

  /// 動画キャスト用のURI
  static uriMovieCasts(int movieId){
    if(movieId == null){
      return null;
    }
    var uri = Uri.https(
        Tmdb._baseUrl,
        "${Tmdb._pathMovie}$movieId/credits",
        Tmdb._params);
    return uri;
  }

  /// 動画検索用のURI
  static uriDiscoverMovies(int page){

    var params = Tmdb._params;
    params["sort_by"] = "release_date.desc";
    params["include_adult"] = "false";
    params["include_video"] = "false";
    params["page"] = "$page";
    params["primary_release_date.gte"] = Tmdb.releaseDateGte();
    params["primary_release_date.lte"] = Tmdb.releaseDateLte();

    var uri = Uri.https(
        Tmdb._baseUrl,
        "${Tmdb._pathDiscover}",
        params);
    return uri;
  }

  static String releaseDateGte(){
    final now = DateTime.now();
    final date = new DateTime(now.year, now.month - 3, now.day);
    return TmdbUtil.date2string(date);
  }

  static String releaseDateLte(){
    final now = DateTime.now();
    final date = new DateTime(now.year, now.month + 3, now.day);
    return TmdbUtil.date2string(date);
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
  int runtime;

  Collection collection;

  List<Genre> genres = <Genre>[];

  DateTime releaseDate;

  MovieDetail(Map<String, dynamic> json) {
    if(json == null){
      return;
    }

    this.movieId = json["id"];
    this.isAdult = json["adult"];
    this.title = json["title"];
    if (json["original_language"] == "ja"){
      this.title = json["original_title"];
    }

    this.overview = json["overview"];
    this.homepage = json["homepage"];
    this.status = json["status"];
    this.runtime = json["runtime"];

    this.collection = Collection(json["belongs_to_collection"]);
    this.genres = Genre.genresFormJsonList(json["genres"]);
    this.posterPath = json["poster_path"];
    this.releaseDate = TmdbUtil.string2date(json["release_date"]);

  }

  String posterUrl(PosterSize size){
    if (this.posterPath != null){
      return TmdbUtil.posterUrl(this.posterPath, size);
    }
    return "";
  }

  String releasedAt(){
    if (this.releaseDate != null){
      return TmdbUtil.date2stringJa(this.releaseDate);
    }
    return "";
  }

  Future<bool> addToCalendar() async{
    print("[addToCalendar]");
    return await UtilCalendar.addToCalendar(this.title, this.releaseDate);
  }

}


/// キャスト
class Cast{
  int castId;
  int peopleId;
  String character;
  String name;
  String profilePath;

  Cast(Map<String, dynamic> json) {
    if (json == null) {
      return;
    }

    this.castId = json["cast_id"];
    this.peopleId = json["id"];
    this.character = json["character"];
    this.name = json["name"];
    this.profilePath = json["profile_path"];

  }

  String profileUrl(PosterSize size){
    if (this.profilePath != null){
      return TmdbUtil.profileUrl(this.profilePath, size);
    }
    return "";
  }

}

/// ジャンル
class Genre{
  int genreId;
  String name;

  Genre(Map<String, dynamic> json) {
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

  Collection(Map<String, dynamic> json) {
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