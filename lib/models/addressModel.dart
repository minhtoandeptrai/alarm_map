import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
class AutoCompleteAddress{
  late String address;
  late String distance;
  LatLng point;
  AutoCompleteAddress({
    required this.address,
    required this.distance,
    required this.point
  });
}