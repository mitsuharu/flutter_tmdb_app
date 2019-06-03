import 'dart:async';
import 'package:flutter/services.dart';
import 'package:device_calendar/device_calendar.dart';

/*

flutter_plugins/main.dart at develop · builttoroam/flutter_plugins
https://github.com/builttoroam/flutter_plugins/blob/develop/device_calendar/example/lib/main.dart


device_calendar | Flutter Package
https://pub.dev/packages/device_calendar#-readme-tab-

 */

class UtilCalendar{

  DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  List<Calendar> calendars;

  UtilCalendar(): super();

  static Future<bool> addToCalendar(String title, DateTime date) async {

    UtilCalendar cal = UtilCalendar();

    bool auth = await cal.retrieveCalendars();
    if (auth == false){
      return false;
    }

    bool exist = await cal.retrieveCalendarEvents(title, date);
    if (exist == false){
      bool result =  await cal.addEvents(title, date);
      return result;
    }
    return exist;
  }

  Future<bool> retrieveCalendars() async {
    try {
      _deviceCalendarPlugin = DeviceCalendarPlugin();
      _deviceCalendarPlugin.hasPermissions();
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();

      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return false;
        }
      }
      final result = await _deviceCalendarPlugin.retrieveCalendars();
      calendars = result.data;

      return result.isSuccess;
    } on PlatformException catch (e) {
      print("retrieveCalendars e:$e");
      return false;
    }
  }

  Future<bool> retrieveCalendarEvents(String title, DateTime date) async {
    try {
      final startDate = date.add(new Duration(days: -1));
      final endDate = date.add(new Duration(days: 1));
      final params = RetrieveEventsParams(startDate: startDate, endDate: endDate);

      for (var cal in calendars) {
        final result = await _deviceCalendarPlugin.retrieveEvents(cal.id, params);
        for (var ev in result.data){
          print(ev.title);
          if (ev.title == title){
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      print("retrieveCalendarEvents $e");
      return false;
    }
  }


  Future<bool> addEvents(String title, DateTime date) async {
    
    try {
      for (var cal in calendars){
        if (cal.isReadOnly){
          continue;
        }
        Event event = Event(cal.id);
        event.title = title;
        event.start = date;
        event.end = date.add(new Duration(days: 1));
        event.allDay = true;
        final result = await _deviceCalendarPlugin.createOrUpdateEvent(event);
        if (result.isSuccess == true){
          return true;
        }
      }
      return false;
    }catch(e) {
      print(e);
      return false;
    }
  }
}
