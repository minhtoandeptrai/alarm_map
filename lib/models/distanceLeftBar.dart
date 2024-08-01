import 'package:beta_alarm_map_app/services/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DistanceLeftBar extends StatefulWidget {
   DistanceLeftBar ({super.key, required this.distace});
  double distace;
  @override
  State<DistanceLeftBar> createState() => _DistanceLeftBarState();
}
class _DistanceLeftBarState extends State<DistanceLeftBar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 50),
        height: 100 > 0 ? 45 : 0,
        width: 200,
        child: Center(
          child: Text(
            '${widget.distace}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500
            )),
        ),
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
        ),
      ),
    );
  }
}