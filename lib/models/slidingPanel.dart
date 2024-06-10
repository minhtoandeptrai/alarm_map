import 'package:beta_alarm_map_app/models/alramModel.dart';
import 'package:beta_alarm_map_app/models/searchBar.dart';
import 'package:beta_alarm_map_app/services/providers.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
class BottomSlidingPanel extends StatefulWidget {
  BottomSlidingPanel({super.key});
  @override
  State<BottomSlidingPanel> createState() => _BottomSlidingPanelState();
}

class _BottomSlidingPanelState extends State<BottomSlidingPanel> {
  var panelController = PanelController();
  var textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<GeneralInfo>(
      builder: (context, GeneralInfo, child){
        return SlidingUpPanel(
          minHeight: 70,
          maxHeight: 770,
          controller: panelController,
          backdropEnabled: true,
          backdropTapClosesPanel: true,
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          collapsed: Container(
           decoration: BoxDecoration(
             color: Colors.white
           ),
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               Container(
                 height: 5,
                 width: 45,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(20),
                   color: Colors.grey
                 ),
               ),
               SizedBox(
                 height: 4,
               ),
               SearchBarWidget(textController: textController, panelController: panelController),
             ],
           ),
         ),
          panel: Column(
            children: [
              SizedBox(height: 10,),
              SearchBarWidget(textController: textController, panelController: panelController),
              Expanded(
            child: ListView.builder(
            itemCount:  GeneralInfo.addressList.length,
            itemBuilder: (context, index){
              var item = GeneralInfo.addressList[index];
              return ListTile(
                onTap: (){
                  AlarmModel model = AlarmModel(item);
                  Provider.of<TmpDestinationMode>(context, listen: false).setModel(model);
                  Navigator.pushNamed(context, '/confirm');
                },
            leading: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey[300]
              ),
              child: Center(
                child: Icon(
                  Icons.location_on,
                  size: 18,
                  color: Colors.white),
              )),
            title: Text(
              item.address,
              style: TextStyle(
                color: Colors.grey[900],
                fontSize: 18,
                fontWeight: FontWeight.w400
              )),
            subtitle: Text(
              item.distance.toString(),
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
                fontWeight: FontWeight.w400
              )),
              );  
        },
          ),
        )
            ],
          ),
      );
  });
  }
}