import 'dart:async';
import 'dart:ui';
import 'package:beta_alarm_map_app/services/local_notification.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
// ignore: camel_case_types
final service = FlutterBackgroundService();
Future<void> initializeService() async {
  await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true
      ));
  service.startService();
}
@pragma('vm:entry-point')
  void onStart(ServiceInstance service) async{
    late Timer privateTimer;
    DartPluginRegistrant.ensureInitialized();
    if(service is AndroidServiceInstance){
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });
      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
      service.on('stopService').listen((event) {
        service.stopSelf();
        cancelNotification();
        privateTimer.cancel();
      });
      service.on('showNotification').listen((event) { 
        ShowNotification();
        Timer.periodic(Duration(seconds: 4), (timer) async {
            await ShowNotification();
         });
      });
      service.on('sendData').listen((event) {
        Timer.periodic(const Duration(seconds: 7), (timer) async{
          privateTimer = timer;
          if(await service.isForegroundService()){
            LatLng p = LatLng(event?['latitude'], event?['longitude']);
            Position cur = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            double distance = await Geolocator.distanceBetween(
            cur.latitude, cur.longitude, 
            p.latitude, p.longitude);
            print(distance);
            if(distance < event?['distance'])
            {
              privateTimer.cancel();
              ShowNotification();
              Timer.periodic(Duration(seconds: 6), (timer) { 
                privateTimer = timer;
                ShowNotification();
              });
            }
          }
        }
      );
        });
    }
}