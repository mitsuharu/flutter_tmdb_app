import './util.dart' as util;

/// キャスト
class Cast{
  int castId;
  int personId;
  String character;
  String name;
  String profilePath;

  Cast(Map<String, dynamic> json) {
    try{
    if (json == null) {
      return;
    }

    this.castId = json["cast_id"];
    this.personId = json["id"];
    this.character = json["character"];
    this.name = json["name"];
    this.profilePath = json["profile_path"];
    }catch(e){
      print("Cast $e");
    }
  }

  String profileUrl(util.PosterSize size){
    if (this.profilePath != null){
      return util.profileUrl(this.profilePath, size);
    }
    return "";
  }

}