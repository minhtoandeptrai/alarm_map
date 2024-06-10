import 'dart:async';
import 'package:beta_alarm_map_app/models/slidingPanel.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  //variables
  VietmapController? _mapController;
  Location _locationController = new Location();
  String apiKey = '1c03f84d35eeabbf622cb486ba616b713aef60f0c46d1543';
  LatLng? _currentP;
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
                _currentP = tmpLatLng;
                _cameraToPosition(_currentP!);});
          }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationUpdate();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //map
        _currentP == null ? const Center(child: Text('Loading...')) : VietmapGL(
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
        BottomSlidingPanel(),
      ],
    );
  }
}