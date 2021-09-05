import 'dart:convert';

import './util.dart' as util;

/// コレクション（シリーズ）
class Collection{

  int collectionId = 0;
  String name = "";
  String posterPath = "";
  String backdropPath = "";

  Collection();

  Collection.fromJson(String json) {
    try{
      print("Collection json: $json");
      Map<String, dynamic> dict = jsonDecode(json);
      collectionId = dict["id"];
      name = dict["name"];

      if (dict["poster_path"] != null){
        posterPath = util.posterUrl(dict["poster_path"], util.PosterSize.normal);
      }
      if (dict["backdrop_path"] != null){
        backdropPath = util.posterUrl(dict["backdrop_path"], util.PosterSize.normal);
      }
    }catch(e){
      print("Collection $e");
      throw e;
    }
  }

//  "id": 86311,
//  "name": "アベンジャーズ シリーズ",
//  "poster_path": "/qJawKUQcIBha507UahUlX0keOT7.jpg",
//  "backdrop_path": "/zuW6fOiusv4X9nnW3paHGfXcSll.jpg"
}