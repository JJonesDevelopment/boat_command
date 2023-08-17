import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MyBoat extends StatelessWidget {
  late final double boatY;
  late final double boatWidth;
 late final double boatHeight;
 late final String boatName;
 late final int boatScale;
 late final bool boatOwned;
late final int boatCost;

  MyBoat({
    required this.boatY, required this.boatWidth, required this.boatHeight, required this.boatName, required this.boatCost, //required this.selected,
  });

  @override

  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0,(2* boatY + boatHeight)  / (2-boatHeight)),
      child:Image.asset('images/$boatName.png',
        width:MediaQuery.of(context).size.height * boatWidth/2,
        height:MediaQuery.of(context).size.height * 3/ 4 * boatHeight/2,
        fit:BoxFit.fill,
      ),
    );
  }
}
