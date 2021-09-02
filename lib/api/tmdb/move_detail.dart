import './genre.dart';
import './collection.dart';
import './util.dart' as util;
import '../../util/calendar.dart';


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
    this.releaseDate = util.string2date(json["release_date"]);

  }

  String posterUrl(util.PosterSize size){
    if (this.posterPath != null){
      return util.posterUrl(this.posterPath, size);
    }
    return "";
  }

  String releasedAt(){
    if (this.releaseDate != null){
      return util.date2stringJa(this.releaseDate);
    }
    return "";
  }

  String tmdbUrl(){
    return "https://www.themoviedb.org/movie/$movieId?language=ja";
  }

  Future<bool> addToCalendar() async{
    print("[addToCalendar]");
    return await UtilCalendar.addToCalendar(this.title, this.releaseDate);
  }

}






