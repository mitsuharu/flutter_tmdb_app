import './util.dart' as util;

/// コレクション（シリーズ）
class Collection{

  int collectionId;
  String name;
  String posterPath;
  String backdropPath;

  Collection(Map<String, dynamic> json) {
    try{
      if(json == null){
        return;
      }

      this.collectionId = json["id"];
      this.name = json["name"];

      // サムネイル
      this.posterPath = util.posterUrl(json["poster_path"], util.PosterSize.normal);
      this.backdropPath = util.posterUrl(json["backdrop_path"], util.PosterSize.normal);
      

    }catch(e){
      print("Collection $e");
    }

  }

//  "id": 86311,
//  "name": "アベンジャーズ シリーズ",
//  "poster_path": "/qJawKUQcIBha507UahUlX0keOT7.jpg",
//  "backdrop_path": "/zuW6fOiusv4X9nnW3paHGfXcSll.jpg"
}