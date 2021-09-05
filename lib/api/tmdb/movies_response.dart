import 'dart:convert';

import 'page.dart';
import 'movie.dart';

class MoviesResponse{
  Page page = Page();
  List<Movie> movies = [];

  MoviesResponse();
  MoviesResponse.fromJson(String json) {
    try {
      page = Page.fromJson(json);

      List<dynamic> results = jsonDecode(json)["results"];
      movies = results.map((e) => Movie.fromJson(jsonEncode(e))).toList();
    }catch(e){
      print("MoviesResponse.fromJson $e");
      throw e;
    }
  }
}

