import 'dart:async';

import 'package:beta_alarm_map_app/AutoCompleteModel.dart';
import 'package:beta_alarm_map_app/addressmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
class NotificationModel2 extends ChangeNotifier{
  bool status = false;
  late String place = ' ';
  double distaceLeft = 0;
  int currentValue = 5;
  List<AddressModel> addressList = []; 
  List<AutoCompleteAddress> addressList2 = []; 
  Timer appTimer = new Timer(Duration(seconds: 0), () { });
  late GeoPoint currentPostion ;
 void updateList(List<AddressModel> list){
  addressList = list;
  notifyListeners();
 }
 void updateList2(List<AutoCompleteAddress> list){
  addressList2 = list;
  notifyListeners();
 }
 void updateCurrentLocation() async {
  Position p = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);     
  currentPostion = GeoPoint(latitude: p.latitude, longitude: p.longitude);
  notifyListeners();
 }
 void setDistace(double x){
  distaceLeft = x;
  notifyListeners();
 }
 void changeStatus(String pl){
  if(status == false){
      status = true;
      place = pl;
  }
  notifyListeners();
 }
 void cancelApp(){
  status = false;
  distaceLeft = 0;
  notifyListeners();
 }
 void increValue(){
  currentValue = 100;
  print(currentValue);
  notifyListeners();
 }
 void descreValue(){
  currentValue = 1;
  print(currentValue);
  notifyListeners();
 }
}