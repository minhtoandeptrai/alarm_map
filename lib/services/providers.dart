
import 'package:beta_alarm_map_app/models/addressModel.dart';
import 'package:beta_alarm_map_app/models/alramModel.dart';
import 'package:flutter/material.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

class GeneralInfo extends ChangeNotifier{
  List<AutoCompleteAddress> addressList = [];  
  late LatLng destinationPosition;

  void setAddressList(List<AutoCompleteAddress> list){
    addressList = list;
    notifyListeners();
  }
}
class DestinationModel extends ChangeNotifier{
  late AlarmModel model;
  late int distance;


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
