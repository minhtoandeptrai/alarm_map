import 'dart:async';

import 'package:beta_alarm_map_app/Screens/cancelScreen.dart';
import 'package:beta_alarm_map_app/services/backgroundService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


final FlutterLocalNotificationsPlugin 
_flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

late BuildContext _context;
late Timer notiTimer;

  void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (notificationResponse.payload != null) {
    debugPrint('notification payload: $payload');
  }
  FlutterBackgroundService().invoke('stopService');
  await Navigator.push(
    _context,
    MaterialPageRoute<void>(builder: (context) => CancelSreen())
  );
}
  Future initializeNotification(BuildContext con) async {
  _context = con;
  
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  
  final DarwinInitializationSettings initializationSettingsDarwin =
  DarwinInitializationSettings(
    onDidReceiveLocalNotification: (id, title, body, payload) => null);
  final LinuxInitializationSettings initializationSettingsLinux =
  LinuxInitializationSettings(
    defaultActionName: 'Open notification');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    linux: initializationSettingsLinux);

  _flutterLocalNotificationsPlugin.initialize(initializationSettings,
  onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
  onDidReceiveBackgroundNotificationResponse: onDidReceiveNotificationResponse);
}
Future<void> ShowNotification() async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
          'basic_chanel', 
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          autoCancel: false,
          onlyAlertOnce: false,
          visibility: NotificationVisibility.public,
          playSound: true,
      );
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await _flutterLocalNotificationsPlugin.show(
      0, 
      'Báo thức', 
      'Bạn đã đến nơi', 
      notificationDetails,
      payload: 'item x'
  );}

Future<void> cancelNotification() async{
  _flutterLocalNotificationsPlugin.cancel(0);
}