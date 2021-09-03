import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

enum PosterSize{
  normal, large
}

DateFormat _dateFormat(){
  var format = DateFormat("yyyy-MM-dd");
  return format;
}

DateFormat _dateFormatJa(){
   initializeDateFormatting("ja_JP");

  var format = DateFormat("yyyy年M月d日(E)", "ja_JP");
  return format;
}

String date2string(DateTime date){
  var format = _dateFormat();
  var str = format.format(date);
  return str;
}

String date2stringJa(DateTime date){
  var format = _dateFormatJa();
  var str = format.format(date);
  return str;
}

DateTime string2date(String str){
  var format = _dateFormat();
  return format.parse(str);
}

String posterUrl(String? path, PosterSize size){
  if (path == null){
    return "";
  }
  const String baseUrl = "http://image.tmdb.org/t/p/";
  String tempSize = size == PosterSize.large ? "w342": "w185";
  return baseUrl + tempSize + path;
}

String profileUrl(String? path, PosterSize size){
  if (path == null){
    return "";
  }
  const String baseUrl = "http://image.tmdb.org/t/p/";
  String tempSize = "w185";
  // String tempSize = size == PosterSize.large ? "w342": "w185";
  return baseUrl + tempSize + path;
}


