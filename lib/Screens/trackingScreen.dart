import 'dart:async';
import 'package:beta_alarm_map_app/Screens/mainScreen.dart';
import 'package:beta_alarm_map_app/models/distanceLeftBar.dart';
import 'package:beta_alarm_map_app/services/backgroundService.dart';
import 'package:beta_alarm_map_app/services/local_notification.dart';
import 'package:beta_alarm_map_app/services/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});
  @override
  State<TrackingScreen> createState() => _TrackingState();
}
 
class _TrackingState extends State<TrackingScreen> with WidgetsBindingObserver{
  //variables
  VietmapController? _mapController;
  Location _locationController =  Location();
  String apiKey = '1c03f84d35eeabbf622cb486ba616b713aef60f0c46d1543';
  LatLng? _currentP;
  String? s;
  double distance = 0;
  bool isRunning = false;
  //function
  Future<void> _cameraToPosition(LatLng pos) async{
    CameraPosition  _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 16);
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition));
  }
  Future<void> getLocationUpdate() async{
    bool _serviceEnabled;
    PermissionStatus _permisstionGranted;
    if(_locationController.isBackgroundModeEnabled() != true){
      _locationController.enableBackgroundMode();
    }
    _serviceEnabled  = await _locationController.serviceEnabled();
    if(_serviceEnabled){
      _serviceEnabled = await _locationController.requestService();
    } else{
      return;
    }
    _permisstionGranted = await _locationController.hasPermission();
    if(_permisstionGranted == PermissionStatus.denied){
      _permisstionGranted = await _locationController.requestPermission();
      if(_permisstionGranted == PermissionStatus.granted){
        return;
      }
    }
    _locationController.onLocationChanged.listen((LocationData currentLocation) {
        if(currentLocation.latitude != null &&
            currentLocation.longitude != null){
              setState(() {
                LatLng tmpLatLng = LatLng(currentLocation.latitude!, currentLocation.longitude!);
                LatLng? des = Provider.of<DestinationModel>(context, listen: false).getLatLng();

                 distance = Geolocator.distanceBetween(
                    tmpLatLng.latitude, tmpLatLng.longitude, 
                    des!.latitude, des.longitude);
                
                _currentP = tmpLatLng;
                _cameraToPosition(_currentP!);
              });
          }
    });
  }
  @override
  void initState(){
    super.initState();
    initializeService();   // khoi tao background service
    initializeNotification(context); // khoi tao thong bao
    getLocationUpdate();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }
  @override
  void dispose() {
    super.dispose();
    FlutterBackgroundService().invoke('stopService');
    cancelNotification();
    WidgetsBinding.instance.removeObserver(this);
  }
  @override
  Widget build(BuildContext context) {
  LatLng? des = Provider.of<DestinationModel>(context, listen: false).getLatLng();
  int? minDistance = Provider.of<DestinationModel>(context, listen: false).getDistance();
    return Stack(
      children: [
        //map
        _currentP == null ? const Center(child: Text('Loading...')) : 
        VietmapGL(
          styleString: 'https://maps.vietmap.vn/api/maps/light/styles.json?apikey=1c03f84d35eeabbf622cb486ba616b713aef60f0c46d1543',
          initialCameraPosition:
              CameraPosition(target: _currentP!,
              zoom: 16),
          onMapCreated: (VietmapController controller){{
              setState(() {
                _mapController = controller;
              });
          }},
          onMapRenderedCallback: () async {
          }, 
          myLocationEnabled: true,
          myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS
    ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                DistanceLeftBar(distace: distance),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, 
                  ),
                  padding: EdgeInsets.all(8), 
                  child: isRunning == true ? IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.red[400], 
                    iconSize: 35, 
                    onPressed: () {
                        dispose();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Scaffold(body: MainScreen())),
                          (Route<dynamic> route) => false, 
                      );
                    }) : IconButton(
                    icon: const Icon(Icons.play_arrow),
                    color: Colors.green[400], 
                    iconSize: 35, 
                    onPressed: () {
                      setState(() {
                        isRunning = true;
                        int second = 4;
                        minDistance! > 5000 ? second = 10 : 4;
                        FlutterBackgroundService().invoke('sendData', {'latitude' : des!.latitude,
                              'longitude' : des.longitude, 'distance' : minDistance, 'second' : second});
                      });
                  }) )
              ],
            ),
          ),
        ),
      ],
    );
  }
}