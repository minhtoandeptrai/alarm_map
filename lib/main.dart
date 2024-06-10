import 'package:beta_alarm_map_app/Screens/cancelScreen.dart';
import 'package:beta_alarm_map_app/Screens/mainScreen.dart';
import 'package:beta_alarm_map_app/Screens/confirmScreen.dart';
import 'package:beta_alarm_map_app/Screens/trackingScreen.dart';
import 'package:beta_alarm_map_app/services/local_notification.dart';
import 'package:beta_alarm_map_app/services/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => GeneralInfo()),
      ChangeNotifierProvider(create: (_) => DestinationModel()),
      ChangeNotifierProvider(create: (_) => TmpDestinationMode()),
    ],
    child: const MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/' : (context) => Scaffold(body: MainScreen()),
        '/confirm' : (context) => CupertinoPickerExample(),
        '/tracking' : (context) => Scaffold(body: TrackingScreen()),
        '/cancel': (context) => CancelSreen()
      },
      );
  }
}