
import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:beta_alarm_map_app/class_provider.dart';
import 'package:beta_alarm_map_app/noti_service.dart';
import 'package:beta_alarm_map_app/vietmaptest.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotificationModel2>(
          create: (context)=>NotificationModel2(),
        )
      ],
      child: MaterialApp(
        builder: FToastBuilder(),
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: Consumer<NotificationModel2>(
          builder: (context, value, child) => Scaffold(
            resizeToAvoidBottomInset: false,
            body: VietMapTesting(),
          ),
        )
      ),
    );
  }
}