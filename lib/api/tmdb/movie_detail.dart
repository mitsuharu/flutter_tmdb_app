import 'dart:convert';

import './movie.dart';
import './cast.dart';
import './genre.dart';
import './collection.dart';
import './util.dart' as util;
import '../../util/calendar.dart';

/// 動画詳細のクラス
class MovieDetail{
  Movie movie = Movie();
  List<Cast> casts = [];

  MovieDetail();
  MovieDetail.fromJson(String movieJson, String castJson ) {
    try {
      movie = Movie.fromJson(movieJson);

      List<dynamic> castList = jsonDecode(castJson)["cast"];
      print("MovieDetail.fromJson castList:$castList");

      casts = castList.map((e) => Cast.fromJson(jsonEncode(e))).toList();
    }catch(e){
      print("MovieDetail.fromJson $e");
      throw e;
    }
  }



  Future<bool> addToCalendar() async{
    print("[addToCalendar]");
    return await UtilCalendar.addToCalendar(this.movie.title, this.movie.releaseDate!);
  }

}






