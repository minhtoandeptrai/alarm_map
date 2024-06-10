import 'dart:convert';

import 'package:beta_alarm_map_app/models/addressModel.dart';
import 'package:beta_alarm_map_app/services/providers.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class SearchBarWidget extends StatefulWidget {
  var textController = TextEditingController();
  var panelController = PanelController();
  SearchBarWidget({
    super.key,
    required this.textController,
    required this.panelController,});
  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {

  //function
  Future getData(String key) async{
    final uri = Uri.parse('https://maps.vietmap.vn/api/autocomplete/v3?apikey=1c03f84d35eeabbf622cb486ba616b713aef60f0c46d1543&text=$key');
    final response = await http.get(uri);
    var jsonData = jsonDecode(response.body);
    List<AutoCompleteAddress> list = [];
    for(var eachItem in jsonData){
      final uri2 = Uri.parse('https://maps.vietmap.vn/api/place/v3?apikey=1c03f84d35eeabbf622cb486ba616b713aef60f0c46d1543&refid=${eachItem['ref_id']}');
      final response2 = await http.get(uri2);
      var jsonData2 = jsonDecode(response2.body);
      LatLng p = LatLng(jsonData2['lat'], jsonData2['lng']);
      Position p1 = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);     
      double distance = Geolocator.distanceBetween(
        p1.latitude, p1.longitude,
        p.latitude, p.longitude);
        double fixDistance = distance/1000;
        String finalDis = fixDistance.toStringAsFixed(2);
      var t = AutoCompleteAddress(address: eachItem['display'], distance: finalDis, point: p);
      list.add(t);
    }
    // ignore: use_build_context_synchronously
    Provider.of<GeneralInfo>(context, listen: false).setAddressList(list);
   }
  @override
  Widget build(BuildContext context) {
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
                  onFieldSubmitted: (e)async{
                    await getData(e);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    prefixIconColor: Colors.grey[500],
                    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    fillColor: Colors.grey[200],
                    filled: true,
                    hintText: 'Bạn muốn đến đâu...',
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
            ))
        ],
      );
  }
}