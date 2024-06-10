import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:beta_alarm_map_app/Screens/trackingScreen.dart';
import 'package:beta_alarm_map_app/main.dart';
import 'package:flutter/material.dart';

 class NotificationService{
  static Future<void> initializeNotification() async {
     await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if(!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications(); 
      }
      }
    );
    await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'high_importane',
        channelKey: 'basic_channel', 
        channelName: 'Basic Notification', 
        channelDescription: 'Notifications channel for basic tests',
        defaultColor: Colors.purple,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        locked: true,
        onlyAlertOnce: false,
        playSound: true,
        criticalAlerts: true)
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'high_importane',
        channelGroupName: 'channelGroupName')
    ],
    debug: true
  );
  await AwesomeNotifications().setListeners(
    onActionReceivedMethod: onActionReceivedMethod,
    onNotificationCreatedMethod: onNotificationCreatedMethod,
    onNotificationDisplayedMethod: onNotificationDisplayedMethod,
    onDismissActionReceivedMethod: onDismissActionReceivedMethod,
  );

  }
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification) async {
      debugPrint('onNotificationCreatedMethod');
  }

  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification) async {
      debugPrint('onNotificationCreatedMethod');
  }

  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction) async {
      debugPrint('onNotificationCreatedMethod');
      final payLoad = receivedAction.payload ?? {};
      if(payLoad["navigate"] == "true"){
        MyApp.navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => TrackingScreen()
          )
        );
      }
  }

  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedNotification) async {
      debugPrint('onNotificationCreatedMethod');}
  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final List<NotificationActionButton>? actionButtons,
    final String? bigPicture,
    final int? interval,
    final bool schedule = false
  }) async{
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1, 
        channelKey: 'basic_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        customSound: 'resource://raw/alarm',
        payload: payload,
        bigPicture: bigPicture),
      actionButtons: actionButtons,
      schedule: schedule ? 
        NotificationInterval(
          interval: interval,
          timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
          preciseAlarm: true,
      ) : null
    );
  }
}