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