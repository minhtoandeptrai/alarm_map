import 'package:beta_alarm_map_app/models/addressModel.dart';
class AlarmModel{
  late AutoCompleteAddress targetDestination;
  late String weather;
  AlarmModel(AutoCompleteAddress p, String s){
   targetDestination = p;
   weather = s;
 }
}