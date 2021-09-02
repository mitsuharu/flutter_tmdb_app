import 'cast.dart';
import 'move_detail.dart';

class Page{
  int current;
  int totalPages;
  int totalResults;

  Page(Map<String, dynamic> json) {
    if (json == null) {
      return;
    }
    this.current = json["page"];
    this.totalPages = json["total_pages"];
    this.totalResults = json["total_results"];
  }

  @override
  String toString() {
    return "page: $current, totalPages:$totalPages, totalResults:$totalResults";
  }

  bool hasNext(){
    return (this.current < this.totalPages);
  }

}


class MoviesResponse{
  Page page;
  List<MovieDetail> movies;
}

class MovieDetailResponse{
  MovieDetail movie;
  List<Cast> casts;
}