
import 'dart:async';
import 'dart:io';
import 'package:flutter_tmdb_app/api/error.dart';
import 'package:http/http.dart' as http;
import 'tmdb/tmdb_api.dart';
import 'tmdb/movies_response.dart';
import 'tmdb/movie_detail.dart';

class Api{

  bool isRequesting = false;

  /// 共通リクエスト
  Future<String> _requestGet(Uri uri) async {
    try {
      http.Response response = await http.get(uri);
      confirmError(response);
      return response.body.toString();
    } on SocketException {
      throw NetworkError();
    } on TimeoutException{
      throw TimeoutError();
    } catch (e) {
      throw e;
    } finally {
    }
  }

  /// 最近の動画一覧を取得する
  Future<MoviesResponse> requestMovies(int page) async{
    try {
      this.isRequesting = true;
      var uri = TmdbApi.uriDiscoverMovies(page);
      var res = await _requestGet(uri);
      return MoviesResponse.fromJson(res);
    } catch(e){
      print("Api#requestMovies $e");
      throw e;
    } finally{
      this.isRequesting = false;
    }
  }


  /// 動画詳細を取得する
  Future<MovieDetail> requestMovieDetail(int movieId) async{
    try {
      this.isRequesting = true;

      // movie
      var movieUri = TmdbApi.uriMovieDetail(movieId);
      var movieResponse = await _requestGet(movieUri);

      // cast
      var castUri = TmdbApi.uriMovieCasts(movieId);
      var castResponse = await _requestGet(castUri);

      return MovieDetail.fromJson(movieResponse, castResponse);
    }catch(e){
      print("Api#requestMovieDetail $e");
      throw e;
    } finally{
      this.isRequesting = false;
    }
  }

  /// キャストから映画一覧を取得する
  Future<MoviesResponse> requestMoviesWithCast(int personId, int page) async{
    try {
      this.isRequesting = true;
      var uri = TmdbApi.uriDiscoverMoviesWithCast(personId, page);
      var res = await _requestGet(uri);
      return MoviesResponse.fromJson(res);
    }catch(e){
      print("Api#requestMoviesWithCast $e");
      throw e;
    } finally{
      this.isRequesting = false;
    }
  }
}