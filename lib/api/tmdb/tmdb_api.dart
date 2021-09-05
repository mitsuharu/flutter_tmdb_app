
import 'api_key.dart';
import './util.dart' as util;

class TmdbApi{

  static String _baseUrl = "api.themoviedb.org";
  static String _pathMovie = "3/movie/";
  static String _pathDiscover = "3/discover/movie/";

  static Map<String, String> _params = {
    "api_key": ApiConstants.apiKey,
    "language": "ja",
    "region": "jp",
  };

  /// 動画詳細用のURI
  static uriMovieDetail(int movieId){
    var uri = Uri.https(
        TmdbApi._baseUrl,
        "${TmdbApi._pathMovie}$movieId",
        TmdbApi._params);
    return uri;
  }

  /// 動画キャスト用のURI
  static uriMovieCasts(int movieId){
    var uri = Uri.https(
        TmdbApi._baseUrl,
        "${TmdbApi._pathMovie}$movieId/credits",
        TmdbApi._params);
    return uri;
  }

  /// 動画検索用のURI
  static uriDiscoverMovies(int page){

    var params = Map<String, String>.from(TmdbApi._params);
    params["sort_by"] = "release_date.desc";
    params["include_adult"] = "false";
    params["include_video"] = "true";
    params["page"] = "$page";
    params["primary_release_date.gte"] = TmdbApi.releaseDateGte(3);
    params["primary_release_date.lte"] = TmdbApi.releaseDateLte(2);

    var uri = Uri.https(
        TmdbApi._baseUrl,
        "${TmdbApi._pathDiscover}",
        params);
    return uri;
  }

  static uriDiscoverMoviesWithCast(int personId, int page){

    var params = Map<String, String>.from(TmdbApi._params);
    params["sort_by"] = "release_date.desc";
    params["include_adult"] = "false";
    params["include_video"] = "true";
    params["with_cast"] = "$personId";
    params["page"] = "$page";
    params["primary_release_date.gte"] = TmdbApi.releaseDateGte(12);
    params["primary_release_date.lte"] = TmdbApi.releaseDateLte(6);

    var uri = Uri.https(
        TmdbApi._baseUrl,
        "${TmdbApi._pathDiscover}",
        params);
    return uri;
  }

  static String releaseDateGte(int month){
    final now = DateTime.now();
    final date = new DateTime(now.year, now.month - month, now.day);
    return util.date2string(date);
  }

  static String releaseDateLte(int month){
    final now = DateTime.now();
    final date = new DateTime(now.year, now.month + month, now.day);
    return util.date2string(date);
  }


}


