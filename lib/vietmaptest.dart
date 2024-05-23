import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:beta_alarm_map_app/class_provider.dart';
import 'package:beta_alarm_map_app/noti_service.dart';
import 'package:beta_alarm_map_app/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:location/location.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class VietMapTesting extends StatefulWidget {
  const VietMapTesting({super.key});
  @override
  State<VietMapTesting> createState() => VietMapTestingState();
}
class VietMapTestingState extends State<VietMapTesting> {
  VietmapController? _mapController;
  var textController = TextEditingController();
  var panelController = PanelController();
  Line? line;
  Timer? timer;
  List<LatLng> geometries = [];
  double distaceLeft = -1;
  LatLng? _currentP = LatLng(10.8235933, 106.63041329999999);
  Location _locationController = new Location();
  int disValue = 1;
  Future<void> drawPolylines() async{
    await _mapController?.addPolyline(
      PolylineOptions(
          geometry: geometries,
          polylineColor: Colors.blueAccent,
          polylineWidth: 10.0,
          polylineOpacity: 0.5),
    );
  }
  Future<void> _cameraToPosition(LatLng pos) async{
    CameraPosition  _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 16);
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition));
  }
    Future<void> initializeService() async{
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: getLocationUpdate, 
      autoStart: false,
      isForegroundMode: true));
}
  @pragma('vm:entry-point')
  Future<void> getLocationUpdate(ServiceInstance service) async{
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
                
                _cameraToPosition(_currentP!);
              if(Provider.of<NotificationModel2>(context, listen: false).status){
                geometries.add(tmpLatLng);
                drawPolylines();
              }});
            }
    });
  }
  Future<void> touchToDestination(GeoPoint destination, Timer timer) async {
    if(Provider.of<NotificationModel2>(context, listen: false).status == true){
      GeoPoint position = GeoPoint(latitude: _currentP!.latitude, longitude: _currentP!.longitude);
      double distance = await Geolocator.distanceBetween(
      position.latitude, position.longitude, 
      destination.latitude, destination.longitude);
      setState(() {
        distaceLeft = distance;
      });
    if(distance < 500)
    {
      await NotificationService.showNotification(
        title: 'this is notification', 
        body: 'Distance:  $distance',
        summary: 'ok',
        notificationLayout: NotificationLayout.Messaging,
        payload: {
          "navigate" : "true"
        }
      );
    }
    if(distance < 100){
      await NotificationService.showNotification(
        title: 'this is notification', 
        body: 'Approach to Destination',
        summary: 'ok',
        notificationLayout: NotificationLayout.Messaging,
        payload: {
          'navigate' : 'true'
        }
      );
      timer.cancel();
      Provider.of<NotificationModel2>(context, listen: false).status = false;
    }
    }
    else{
      timer.cancel();
    }
  }

  final VietmapGL vietmapGL = new VietmapGL(initialCameraPosition: CameraPosition(
              target: LatLng(106.654551,10.762317),
              zoom: 16), 
              styleString: 'https://maps.vietmap.vn/api/maps/light/styles.json?apikey=92435c386a05dea0980989d03ae44eb77629d8e91167e943');
  @override
  void initState()  {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
Column(
  mainAxisSize: MainAxisSize.max,
  children: [
     Center(
    child: GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 50),
        height: distaceLeft > 0 ? 45 : 0,
        width: 200,
        child: Text(
          distaceLeft.toString(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500
          )),
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
        ),
      ),
    ),
  ),
  ],
),
// Positioned(
//     bottom: 70,
//     right: 10,
//     child: FloatingActionButton(
//       backgroundColor: Colors.white,
//       onPressed: ()async {
//         Position p = await Geolocator.getCurrentPosition();
//         print(p.latitude);
//         print(p.longitude);
//         LatLng ll = LatLng(p.latitude, p.longitude);
//         await _mapController?.moveCamera(CameraUpdate.newLatLngZoom(ll, 16));
//       },
//       child: Icon(
//         Icons.location_searching_sharp,
//         size: 25,
//         color: Colors.black,
//       )),
//    ),
SlidingUpPanel(  
  minHeight: 65,
  maxHeight: 800,
  controller: panelController,
  backdropEnabled: true,
  backdropTapClosesPanel: true,
  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
  collapsed: Container(
         decoration: BoxDecoration(
           color: Colors.white
         ),
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             Container(
               height: 5,
               width: 45,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(20),
                 color: Colors.grey
               ),
             ),
             SizedBox(
               height: 4,
             ),
             SearchWidget(textController: textController, panelController: panelController, vietMapGL: vietmapGL),
           ],
         ),
       ),
    panel: Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(height: 10),   
      SearchWidget(textController: textController, panelController: panelController,vietMapGL: vietmapGL),
      Expanded(
        child: ListView.builder(
          itemCount: Provider.of<NotificationModel2>(context, listen: false).addressList2.length,
          itemBuilder: (context, index){
            var item = Provider.of<NotificationModel2>(context, listen: false).addressList2[index];
            return ListTile(
              onTap: (){
                    showDialog(
                      context: context, 
                      builder: (BuildContext context){
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                const Center(
                                  child: const Text(
                                      'Information',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700
                                      )),
                                ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 90,
                                        child: Text(
                                          'Placement',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Expanded(
                                        child: Text('${item.address}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400
                                          )),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 90,
                                        child: Text(
                                          'Distance',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Text('${item.distance.toString()} km',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400
                                        )),
                                      
                                    ],
                                  ),
                                  SizedBox(height: 15),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Choosse the distance: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    GestureDetector(
                                      onTap: () => setState(() => disValue--),
                                      child: Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: Colors.amber[400],
                                          borderRadius: BorderRadius.circular(100)
                                        ),
                                        child: Center(
                                          child: Text(
                                            '-',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                              fontSize: 15
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '$disValue',
                                      style: const TextStyle(
                                        fontSize: 18
                                      ),   
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () => setState(() => disValue++),
                                      child: Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: Colors.amber[400],
                                      borderRadius: BorderRadius.circular(100)                                   
                                    ),
                                    child: Center(
                                      child: Text(
                                        '+',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          fontSize: 15
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[400],
                                ),
                                onPressed: (){
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context, 
                                    builder: (BuildContext context){
                                      return AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('Your alarm will bang when your distance is: 5km'),
                                            SizedBox(height: 15),
                                            Row(
                                              children: [
                                                Expanded(child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.green[400]
                                                  ),
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                    Timer appTimer = Provider.of<NotificationModel2>(context, listen: false).appTimer;
                                                    GeoPoint p = GeoPoint(
                                                      latitude: item.point.latitude, 
                                                      longitude: item.point.longitude);
                                                      Provider.of<NotificationModel2>(context, listen: false).changeStatus(item.address);
                                                      appTimer = Timer.periodic(const Duration(seconds: 10), (timer) { 
                                                        setState(() {
                                                          touchToDestination(p, appTimer);
                                                        });
                                                      });
                                                  },
                                                  child: Text(
                                                    'Confirm',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.white
                                                    )),
                                                )),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    });
                                },
                                child: 
                                  Text('Set Alarm',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400
                                    ))),
                            ),
                          ],
                        )
                  ],
                          ),
                        );
                      }                        
                      );
          },
          leading: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[300]
            ),
            child: Center(
              child: Icon(
                Icons.location_on,
                size: 18,
                color: Colors.white,),
            )),
          title: Text(
            item.address,
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 18,
              fontWeight: FontWeight.w400
            )),
          subtitle: Text(
            item.distance.toString(),
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
              fontWeight: FontWeight.w400
            )),
            );  
  },
        ),
      )
    ],
  ),
 )
],
);
  }
}