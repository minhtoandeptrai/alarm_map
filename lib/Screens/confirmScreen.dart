import 'package:beta_alarm_map_app/models/alramModel.dart';
import 'package:beta_alarm_map_app/services/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
const double _kItemExtent = 32.0;
const List<int> distanceList = <int>[
  500,
  600,
  700,
  800,
  900,
  1000,
  1100,
  1200,
  1300,
  1400,
  1500,
  1600,
  1700,
  1800,
  1900,
  2000,
];
class CupertinoPickerExample extends StatefulWidget {
  const CupertinoPickerExample({super.key});
  @override
  State<CupertinoPickerExample> createState() => _CupertinoPickerExampleState();
}
class _CupertinoPickerExampleState extends State<CupertinoPickerExample> {
  int distanceItem = 0;
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    AlarmModel model = Provider.of<TmpDestinationMode>(context, listen: false).tmpModel;
    // ignore: unnecessary_null_comparison
    return  model != null ? Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        title: const Text('Kiểm tra thông tin'),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(
            Icons.arrow_back,
            size: 22,)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  child: Text('Địa điểm : ', 
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                    )),
                ),
                Expanded(
                  child: Text(model.targetDestination.address,
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.grey[900]
                    ),),
                )
              ],
            ),
            SizedBox(height: 7),
            SizedBox(height: 7),
            Row(
              children: [
                Container(
                  width: 150,
                  child: Text('Khoảng cách: ', 
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                    )),
                ),
                Text('${model.targetDestination.distance} km',
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.grey[900]
                  ),)
              ],
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  child: Text('Thời tiết: ', 
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                    )),
                ),
                Row(
                  children: [
                    Text('${model.weather}',
                        style: TextStyle(
                    fontSize: 19,
                    color: Colors.grey[900]
                  )),
                  Text(' o', style: TextStyle(fontSize: 12, color: Colors.grey[800])),
                  Text('C', style: TextStyle(fontSize: 19, color: Colors.grey[900])),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text('Khoảng cách tối thiểu báo thức: ',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500
                )),
                        SizedBox(width: 5),
                        DefaultTextStyle(
                        style: TextStyle(
                        color: Colors.orange[500],
                        fontSize: 22,
                        ),
                        child: Center(
                          child: Row(
            children: <Widget>[
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => _showDialog(
                  CupertinoPicker(
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: _kItemExtent,
                    scrollController: FixedExtentScrollController(
                      initialItem: distanceItem,
                    ),
                    onSelectedItemChanged: (int selectedItem) {
                      setState(() {
                        distanceItem = selectedItem;
                      });
                    },
                    children:
                        List<Widget>.generate(distanceList.length, (int index) {
                      return Center(child: Text(distanceList[index].toString()));
                    }),
                  ),
                ),
                child: Text(
                  '${distanceList[distanceItem].toString()} m',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange[400]
                  ),
                ),
              ),
            ],
                          ),
                        ),
                      ),
          SizedBox(height: 20,),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[500],
                      ),
                    onPressed: (){
                      Provider.of<DestinationModel>(context, listen: false).setModel(model, distanceList[distanceItem]);
                      Navigator.pushNamed(context, '/tracking');
                    },
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                      )),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    ) : Container();
}
}