import 'dart:async';
import 'package:device_calendar/device_calendar.dart';
import 'package:timezone/timezone.dart' as tz;

class UtilCalendar{

  DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  List<Calendar> calendars = [];
  Calendar defaultCalendar = Calendar();
  UtilCalendar(): super();

  static Future<bool> addToCalendar(String title, DateTime date) async {
    try {
      UtilCalendar cal = UtilCalendar();
      bool auth = await cal._retrieveCalendars();
      if (auth == false) {
        return false;
      }
      bool exist = await cal._retrieveCalendarEvents(title, date);
      if (exist == false) {
        bool result = await cal._addEvent(title, date);
        return result;
      }
      return exist;
    }catch(e){
      print("UtilCalendar#addToCalendar $e");
      throw e;
    }
  }

  /// カレンダーの認証を確認する
  Future<bool> _retrieveCalendars() async {
    try {
      _deviceCalendarPlugin = DeviceCalendarPlugin();
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();

      if (permissionsGranted.isSuccess && !permissionsGranted.data!) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
          return false;
        }
      }
      final result = await _deviceCalendarPlugin.retrieveCalendars();
      calendars = result.data!;

      return result.isSuccess;
    } catch (e) {
      print("UtilCalendar#_retrieveCalendars $e");
      return false;
    }
  }

  /// すでに登録しているか判定する
  Future<bool> _retrieveCalendarEvents(String title, DateTime date) async {
    try {
      final startDate = date.add(new Duration(days: -1));
      final endDate = date.add(new Duration(days: 1));
      final params = RetrieveEventsParams(startDate: startDate, endDate: endDate);
      for (var cal in calendars) {
        final result = await _deviceCalendarPlugin.retrieveEvents(cal.id, params);
        for (var ev in result.data!){
          if (ev.title == title){
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      print("UtilCalendar#_retrieveCalendarEvents $e");
      return false;
    }
  }

  /// 書き込むカレンダーを取得する。
  /// カレンダーが書込み可能かつ、特定名称を優先に決定する。
  Calendar? _extractWritableCalendar()  {
    try {
      Calendar? firstWritableCal;
      List<String> candidates = [
        "movie",
        "film",
        "cinema",
        "映画",
        "private",
        "予定",
        "schedule"
      ];
      for (String candidate in candidates) {
        for (Calendar cal in calendars) {
          if (cal.isReadOnly == false) {
            if (cal.name == candidate) {
              return cal;
            }
            if (firstWritableCal == null) {
              firstWritableCal = cal;
            }
          }
        }
      }
      return firstWritableCal;
    }catch(e){
      print("UtilCalendar#_extractWritableCalendar $e");
      return null;
    }
  }

  Future<bool> _addEvent(String title, DateTime date) async {
    try {
      Calendar? cal = _extractWritableCalendar();
      if (cal != null) {
        final tokyo = tz.getLocation("Asia/Tokyo");
        Event event = Event(cal.id, availability: Availability.Free);
        event.title = title;
        event.start = tz.TZDateTime.from(date, tokyo);
        event.end = tz.TZDateTime.from(date.add(new Duration(days: 1)), tokyo);
        event.allDay = true;
        final result = await _deviceCalendarPlugin.createOrUpdateEvent(event);
        if (result!.isSuccess == true) {
          return true;
        }
      }
      return false;
    }catch(e) {
      print("UtilCalendar#_addEvent $e");
      return false;
    }
  }
}

