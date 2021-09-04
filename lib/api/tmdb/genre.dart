import 'dart:convert';
import 'dart:ffi';

/// ジャンル
class Genre{
  int genreId = 0;
  String name = "";

  Genre.fromJson(String json) {
    try {
      Map<String, dynamic> dict = jsonDecode(json);
      genreId = dict["id"];
      name = dict["name"];
    }catch(e){
      print("Genre $e");
      throw e;
    }
  }

  static List<Genre> genresFormJsonList(List<dynamic> jsonList) {
    try {
      return jsonList.map((e) => Genre.fromJson(jsonEncode(e))).toList();
    }catch(e){
      print("Genre#genresFormJsonList $e");
      throw e;
    }
  }
}