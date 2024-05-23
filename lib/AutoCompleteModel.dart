import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
class AutoCompleteAddress{
  late String address;
  late String distance;
  GeoPoint point;
  AutoCompleteAddress({
    required this.address,
    required this.distance,
    required this.point
  });
}