
import 'dart:convert';

import 'package:beta_alarm_map_app/AutoCompleteModel.dart';
import 'package:beta_alarm_map_app/addressmodel.dart';
import 'package:beta_alarm_map_app/class_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart' as http;
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
class SearchWidget extends StatefulWidget {
    var textController = TextEditingController();
    var panelController = PanelController();
    final VietmapGL vietMapGL;
   SearchWidget({
      super.key,
      required this.textController,
      required this.panelController,
      required this.vietMapGL
    });
  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}
class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
  bool isNot = Provider.of<NotificationModel2>(context, listen: false).status;
  VietmapGL vietmapGL;
  Future<GeoPoint> getGeoPoint(String refId) async {
      final uri2 = Uri.parse('https://maps.vietmap.vn/api/autocomplete/v3?apikey=1c03f84d35eeabbf622cb486ba616b713aef60f0c46d1543&text=$refId');
      final response2 = await http.get(uri2);
      var jsonData2 = jsonDecode(response2.body);
      return GeoPoint(latitude: jsonData2['lat'], longitude: jsonData2['lng']);
  }
  Future getData(String key) async{
    final uri = Uri.parse('https://maps.vietmap.vn/api/autocomplete/v3?apikey=1c03f84d35eeabbf622cb486ba616b713aef60f0c46d1543&text=$key');
    final response = await http.get(uri);
    var jsonData = jsonDecode(response.body);
    List<AutoCompleteAddress> list = [];
    for(var eachItem in jsonData){
      final uri2 = Uri.parse('https://maps.vietmap.vn/api/place/v3?apikey=1c03f84d35eeabbf622cb486ba616b713aef60f0c46d1543&refid=${eachItem['ref_id']}');
      final response2 = await http.get(uri2);
      var jsonData2 = jsonDecode(response2.body);
      GeoPoint p = GeoPoint(latitude: jsonData2['lat'], longitude: jsonData2['lng']);
      Position p1 = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);     
      double distance = Geolocator.distanceBetween(
        p1.latitude, p1.longitude,
        p.latitude, p.longitude);
        double fixDistance = distance/1000;
        String finalDis = fixDistance.toStringAsFixed(2);
      var t = AutoCompleteAddress(address: eachItem['display'], distance: finalDis, point: p);
      list.add(t);
    }
    Provider.of<NotificationModel2>(context, listen: false).updateList2(list);
   }
  Future returnDataSource(var value, _mainController) async {
    var data = await addressSuggestion(value);
    List<AddressModel> addressList = []; 
      data.forEach((e) async {
        GeoPoint p =  GeoPoint(latitude: e.point!.latitude, longitude: e.point!.longitude);
        Position p1 = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        double distance = Geolocator.distanceBetween(
        p1.latitude, p1.longitude,
        p.latitude, p.longitude);
        double fixDistance = distance/1000;
        String finalDis = fixDistance.toStringAsFixed(2);
        AddressModel m = new AddressModel();
        m.distance = finalDis;
        m.si = e;
        addressList.add(m);
      });
}
    return Consumer(
      builder: (context, value, child){
        return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: Material(
                child: TextFormField(
                  onTap: (){
                    widget.panelController.open();
                  },
                  onFieldSubmitted: (e){
                    getData(e);          
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    prefixIconColor: Colors.grey[500],
                    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    fillColor: Colors.grey[200],
                    filled: true,
                    hintText: 'Search your place here...',
                    hintStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                  ),
                  ),
                  controller: widget.textController,
                ),
              ),
            )),
          GestureDetector(
                onTap: (){
                  showDialog(
                  context: context, 
                  builder: (BuildContext context){
                    return AlertDialog(
                      content: Consumer<NotificationModel2>(
                        builder: (context, model, child) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Notification',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500
                              ),
                              
                            ),
                            SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                  Container(
                                    width: 90,
                                    child: Text(
                                    'Destination',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500
                                    ),                              ),
                                  ),
                                SizedBox(width: 50),
                                Expanded(
                                  child: Text(
                                    isNot ? model.place : 'No destination choosen',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                      color:  isNot ? Colors.black : Colors.grey[500]
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                              Row(
                              children: [
                                  Container(
                                    width: 90,
                                    child: Text(
                                    'Status',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500
                                    ),
                                                                    ),
                                  ),
                                SizedBox(width: 50),
                                Text(
                                  isNot ? 'Waiting' : 'Empty',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: isNot ? Colors.black : Colors.grey[500]
                                  ),
                                ),
                              ],
                            ),
                          
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                      Provider.of<NotificationModel2>(context, listen: false).cancelApp();
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isNot ? Colors.red[600] : Colors.grey[400],
                                      shadowColor: Color(0)
                                    ),
                                  )),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }
                );
                }, 
                child: Stack(
                  children: [
                    Icon(
                      Icons.notifications,
                      color: isNot ? Colors.yellow[600] : Colors.grey[400],
                      size: 30),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        height: 7,
                        width: 7,
                        decoration: BoxDecoration(
                          color:isNot ? Colors.red : Colors.transparent,
                          borderRadius: BorderRadius.circular(100)
                        ),
                      ))  
                  ]
                )),
        ],
      );}
    );
  }
}