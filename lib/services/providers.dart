
import 'package:beta_alarm_map_app/models/addressModel.dart';
import 'package:beta_alarm_map_app/models/alramModel.dart';
import 'package:flutter/material.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

class GeneralInfo extends ChangeNotifier{
  List<AutoCompleteAddress> addressList = [];  
  late double distaceLeft;
  late LatLng destinationPosition;

  double getDistanceLeft(){
    return distaceLeft;
  }
  void setDistanceLeft(double dis){
    distaceLeft = dis;
    notifyListeners();
  }
  void setAddressList(List<AutoCompleteAddress> list){
    addressList = list;
    notifyListeners();
  }
}
class DestinationModel extends ChangeNotifier{
  late AlarmModel model;
  late int distance;
  late double distaceLeft;

  void setDistanceLeft(double x){
    distaceLeft = x;
    notifyListeners();
  }
  double getDistanceLeft(){
    return distaceLeft;
  }
  void setModel(AlarmModel am, int x){
    model = am;
    distance = x;
    notifyListeners();
  }
  LatLng? getLatLng() {
    return model.targetDestination.point;
  }
  int? getDistance(){
    return distance;
  }
}
class TmpDestinationMode extends ChangeNotifier{
  late AlarmModel tmpModel;
  void setModel(AlarmModel am){
    tmpModel = am;
    notifyListeners();
  }
}
