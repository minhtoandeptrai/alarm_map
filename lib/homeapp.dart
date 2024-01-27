
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:beta_alarm_map_app/mainstatecontroller.dart';
import 'package:beta_alarm_map_app/noti_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp>{
  late GeoPoint destination;
  var mainController = Get.put(MainStateController());
  var textController = TextEditingController();
  Future<String> localTimeZone =  AwesomeNotifications().getLocalTimeZoneIdentifier();

  final mapController = MapController.withUserPosition(
    trackUserLocation: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: false
    )
  );
  drawMarker (GeoPoint p) async{
    if(p != null)
    {
       await mapController.addMarker(p, markerIcon: MarkerIcon(
            icon: Icon( 
              Icons.pin_drop, 
              size: 50,
              color: Colors.red),
          ));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OSMFlutter( 
        controller:mapController,
        osmOption: OSMOption(
              userTrackingOption: const UserTrackingOption(
              enableTracking: true,
              unFollowUser: false
            ),
            zoomOption: const ZoomOption(
                  initZoom: 15,
                  minZoomLevel: 14,
                  maxZoomLevel: 19,
                  stepZoom: 1.0,
            ),
            userLocationMarker: UserLocationMaker(
                personMarker: const MarkerIcon(
                    icon: Icon(
                        Icons.location_history_rounded,
                        color: Colors.red,
                        size: 48,
                    ),
                ),
                directionArrowMarker: const MarkerIcon(
                    icon: Icon(
                        Icons.double_arrow,
                        size: 48,
                    ),
                ),
            ),
            roadConfiguration: const RoadOption(
                    roadColor: Colors.yellowAccent,
            ),
            markerOption: MarkerOption(
                defaultMarker: MarkerIcon(
                    icon: Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 56,
                    ),
                )
            ),
        ),
        onMapIsReady: (isReady) async{
              Position p = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
              GeoPoint position = GeoPoint(latitude: p.latitude, longitude: p.longitude);
              await mapController.changeLocation(position);await mapController.currentLocation();
        }
       
    ),
        SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onFieldSubmitted: (value) async {
                            var data = await addressSuggestion(value);
                            if(data != null)
                            {
                              mainController.listSource.value = data;

                            }
                            else mainController.listSource.value = [];                             
                          },
                          
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.blue
                              )
                            ),
                            hintText: 'Search your place here...',
                            hintStyle: TextStyle(
                              fontSize: 18
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            
                          ),
                          suffixIcon: IconButton(
                            onPressed: (){}, 
                            icon: Icon(
                              Icons.notifications,
                              color: Colors.grey,
                              size: 26)),
                          ),
                          
                          controller: textController,
                        )),
                    ],
                  ),
                ),  
              Obx( ()=> Expanded(child: ListView.builder(
                  itemCount: mainController.listSource.length,
                  itemBuilder: (context, index){ 
                    return ListTile(
                      title: GestureDetector(
                        onTap: () async{
                          GeoPoint p = GeoPoint(
                              latitude: mainController.listSource[index].point!.latitude, 
                              longitude: mainController.listSource[index].point!.longitude);
                          // await mapController.changeLocation(p);
                          String addName = mainController.listSource[index].address.toString();
                          Position p1 = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                          GeoPoint point2 = GeoPoint(latitude: p.latitude, longitude: p.longitude);
                          destination = point2;
                          double distance = await Geolocator.distanceBetween(
                            p1.latitude, p1.longitude,
                            point2.latitude, point2.longitude);
                          showInfor(addName, distance);
                        },
                        child: Text(mainController.listSource[index].address.toString())),
                );
              })))
              ],
            ),
          ),

    Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () async{
                await NotificationService.showNotification(
                  title: 'this is 1st noti', 
                  body: 'hello world',
                  summary: 'small summary',
                  notificationLayout: NotificationLayout.Messaging,
                  payload: {
                    'navigate' : 'true'
                  }
                  );
                Position p = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                GeoPoint position = GeoPoint(latitude: p.latitude, longitude: p.longitude);
                await mapController.changeLocation(position);

              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, right: 10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white
                ),
                child: Icon(Icons.my_location_outlined,
                  size: 43,
                  color:Colors.grey[500]),
              ),
            )
          ],
        )
      ],
    )
      ],
    );
  }
  void showInfor(String addName, double distance){
    double fixDistance = distance/1000;
    String finalDis = fixDistance.toStringAsFixed(1);
    showModalBottomSheet(context: context, builder: (context){
      return Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(addName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  )),
                IconButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              icon: 
                Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.black))
              ],
            ),
            Text('Khoảng cách giữa hai Thành phố là: $finalDis km',
              style: TextStyle(
                fontSize: 17
              ))
          ],
        ),
      );
    });
  }
}

