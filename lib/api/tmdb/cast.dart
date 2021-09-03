import 'dart:convert';

import './util.dart' as util;

/// キャスト
class Cast{
  int castId = 0;
  int personId = 0;
  String character = "";
  String name = "";
  String? profilePath ;

  Cast();
  Cast.fromJson(String json) {
    try{
      Map<String, dynamic> dict = jsonDecode(json);
      castId = dict["cast_id"];
      personId = dict["id"];
      character = dict["character"];
      name = dict["name"];
      profilePath = dict["profile_path"];
    }catch(e){
      print("Cast $e");
      throw e;
    }
  }

  String profileUrl(util.PosterSize size){
    if (profilePath != null && profilePath!.length > 0){
      return util.profileUrl(profilePath!, size);
    }
    return "";
  }

}