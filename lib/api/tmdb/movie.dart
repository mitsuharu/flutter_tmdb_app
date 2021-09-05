import 'dart:convert';

import './genre.dart';
import './collection.dart';
import './util.dart' as util;
import '../../util/calendar.dart';

/// 動画詳細のクラス
class Movie{
  int movieId = 0;
  bool isAdult = false;
  String title = "";
  String overview = "";
  String? homepage;
  String? posterPath;
  String? status;
  int? runtime;
  Collection? collection;
  List<Genre> genres = <Genre>[];
  DateTime? releaseDate;

  Movie();
  Movie.fromJson(String json) {
    try {
      Map<String, dynamic> dict = jsonDecode(json);

      movieId = dict["id"];
      isAdult = dict["adult"];
      title = dict["title"];
      if (dict["original_language"] == "ja") {
        title = dict["original_title"];
      }
      overview = dict["overview"];
      homepage = dict["homepage"];
      status = dict["status"];
      runtime = dict["runtime"];

      if (dict["belongs_to_collection"] != null){
        collection = Collection.fromJson(jsonEncode(dict["belongs_to_collection"]));
      }

      if (dict["genres"] != null){
        genres = Genre.genresFormJsonList(dict["genres"]);
      }

      posterPath = dict["poster_path"];
      releaseDate = util.string2date(dict["release_date"]);
    }catch(e){
      print("Movie.fromJson $e");
      throw e;
    }
  }

  String posterUrl(util.PosterSize size){
    if (posterPath != null && posterPath!.length > 0){
      return util.posterUrl(posterPath!, size);
    }
    return "";
  }

  String releasedAt(){
    if (releaseDate != null){
      return util.date2stringJa(releaseDate!);
    }
    return "";
  }

  String tmdbUrl(){
    return "https://www.themoviedb.org/movie/$movieId?language=ja";
  }
}






