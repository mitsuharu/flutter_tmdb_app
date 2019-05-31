import 'api_key.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'tmdb_models.dart';

/*

http | Dart Package
https://pub.dev/packages/http

get - How do you add query parameters to a Dart http request? - Stack Overflow
https://stackoverflow.com/questions/ask

【初心者】Flutter:APIでデータ取得して、一覧表示させるサンプルアプリ - Qiita
https://qiita.com/yasutaka_ono/items/6d2a0d3b0856598f9788


*/




class ApiManager{
  static String apiKey = ApiConstants.apiKey;

  void doSamples(){
    print("[doSamples]");
    // requestMovieDetail(299534);
  }

  Future<MovieDetail> requestMovieDetail(int movieId) async{

    var uri = Tmdb.uriMovieDetail(movieId);
    http.Response response = await http.get(uri);

    MovieDetail md = MovieDetail(json.decode(response.body));
    print("[ApiManager][requestMovieDetail] ${md.movieId}, ${md.title}, ${md.releaseDate}");
    print("${md.genres[0].name}, ${md.collection.backdropPath}");

    return md;
  }
}