import 'package:beta_alarm_map_app/Screens/mainScreen.dart';
import 'package:flutter/material.dart';

class CancelSreen extends StatefulWidget {
  const CancelSreen({super.key});

  @override
  State<CancelSreen> createState() => _CancelSreenState();
}

class _CancelSreenState extends State<CancelSreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.alarm_on_sharp,
              size: 40,
              color: Colors.white),
              SizedBox(height: 15),
              ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[400]
              ),
              onPressed: (){
                 Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Scaffold(body: MainScreen())),
                  (Route<dynamic> route) => false,
                );
              }, 
              child: Text(
                'Hủy',
                style: TextStyle(
                  color: Colors.white
                ),)),
              SizedBox(height: 15),
              const Text(
                'Bạn đã đến nơi',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400
                ),)
          ],
        ),
      ),
    );
  }
}