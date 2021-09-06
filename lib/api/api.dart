
import 'dart:async';
import 'dart:io';
import 'package:flutter_tmdb_app/api/error.dart';
import 'package:http/http.dart' as http;
import 'tmdb/tmdb_api.dart';
import 'tmdb/movies_response.dart';
import 'tmdb/movie_detail.dart';


enum RequestStatus{
  initial,
  loading,
  success,
  failed,
  empty,
}

class Api{

  bool hasNext = false;
  RequestStatus requestStatus = RequestStatus.initial;
  DateTime? lastRequestedAt;

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
      requestStatus = RequestStatus.loading;

      var uri = TmdbApi.uriDiscoverMovies(page);
      var res = await _requestGet(uri);
      var result = MoviesResponse.fromJson(res);

      hasNext = result.page.hasNext();
      requestStatus = RequestStatus.success;
      lastRequestedAt = DateTime.now();
      return result;
    } catch(e){
      print("Api#requestMovies $e");
      requestStatus = RequestStatus.failed;
      throw e;
    }
  }


  /// 動画詳細を取得する
  Future<MovieDetail> requestMovieDetail(int movieId) async{
    try {
      requestStatus = RequestStatus.loading;

      // movie
      var movieUri = TmdbApi.uriMovieDetail(movieId);
      var movieResponse = await _requestGet(movieUri);

      // cast
      var castUri = TmdbApi.uriMovieCasts(movieId);
      var castResponse = await _requestGet(castUri);

      var result = MovieDetail.fromJson(movieResponse, castResponse);

      requestStatus = RequestStatus.success;
      lastRequestedAt = DateTime.now();
      return result;
    }catch(e){
      print("Api#requestMovieDetail $e");
      requestStatus = RequestStatus.failed;
      throw e;
    }
  }

  /// キャストから映画一覧を取得する
  Future<MoviesResponse> requestMoviesWithCast(int personId, int page) async{
    try {
      requestStatus = RequestStatus.loading;

      var uri = TmdbApi.uriDiscoverMoviesWithCast(personId, page);
      var res = await _requestGet(uri);
      var result = MoviesResponse.fromJson(res);

      hasNext = result.page.hasNext();
      requestStatus = RequestStatus.success;
      lastRequestedAt = DateTime.now();
      return result;
    }catch(e){
      print("Api#requestMoviesWithCast $e");
      requestStatus = RequestStatus.failed;
      throw e;
    }
  }
}