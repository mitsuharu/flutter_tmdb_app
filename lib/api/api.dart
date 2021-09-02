
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'tmdb/tmdb_api.dart';
import 'tmdb/responses.dart';

import 'tmdb/cast.dart';
import 'tmdb/move_detail.dart';

/*

http | Dart Package
https://pub.dev/packages/http

get - How do you add query parameters to a Dart http request? - Stack Overflow
https://stackoverflow.com/questions/ask

【初心者】Flutter:APIでデータ取得して、一覧表示させるサンプルアプリ - Qiita
https://qiita.com/yasutaka_ono/items/6d2a0d3b0856598f9788


*/


class Api{

  bool isRequesting = false;

  /// 最近の動画一覧を取得する
  Future<MoviesResponse> requestMovies(int page) async{
    this.isRequesting = true;

    var uri = TmdbApi.uriDiscoverMovies(page);
    http.Response response = await http.get(uri);
    var jsonData = json.decode(response.body);

    var res = MoviesResponse();
    res.page = Page(jsonData);
    res.movies = <MovieDetail>[];

    for (var j in jsonData["results"]){
      res.movies.add(MovieDetail(j));
    }

    this.isRequesting = false;
    return res;
  }


  /// 動画詳細を取得する
  Future<MovieDetailResponse> requestMovieDetail(int movieId) async{
    this.isRequesting = true;

    MovieDetailResponse res = MovieDetailResponse();
    res.movie = null;
    res.casts = <Cast>[];

    // movie
    var movieUri = TmdbApi.uriMovieDetail(movieId);
    http.Response movieResponse = await http.get(movieUri);
    res.movie = MovieDetail(json.decode(movieResponse.body));

    // cast
    var castUri = TmdbApi.uriMovieCasts(movieId);
    http.Response castResponse = await http.get(castUri);
    var castJsonData = json.decode(castResponse.body);
    for (var j in castJsonData["cast"]){
      res.casts.add(Cast(j));
    }

    this.isRequesting = false;
    return res;
  }

  /// キャストから映画一覧を取得する
  Future<MoviesResponse> requestMoviesWithCast(int personId, int page) async{
    this.isRequesting = true;

    var uri = TmdbApi.uriDiscoverMoviesWithCast(personId, page);
    http.Response response = await http.get(uri);
    var jsonData = json.decode(response.body);

    var res = MoviesResponse();
    res.page = Page(jsonData);
    res.movies = <MovieDetail>[];

    for (var j in jsonData["results"]){
      res.movies.add(MovieDetail(j));
    }

    this.isRequesting = false;
    return res;
  }

  Future<MoviesResponse> requestMoviesForMainPage(int personId, int page) async{

    if (personId == null){
      return requestMovies(page);
    }else{
      return requestMoviesWithCast(personId, page);
    }
  }



}