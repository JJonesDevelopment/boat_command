import 'package:flutter/material.dart';


class Money extends StatelessWidget {
  late final  double moneyWidth;
  late final double moneyHeight;
 late  final double moneyX;
  late final double moneyY;

  Money(
  {
    required this.moneyX,
    required this.moneyY,
    required this.moneyWidth,
    required this.moneyHeight,
  }
      );

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment((2* moneyX + moneyWidth)/ (2-moneyWidth), moneyY),
      child:Container(
        width: MediaQuery.of(context).size.width * moneyWidth/2,
        height: MediaQuery.of(context).size.height * 3 / 4* moneyHeight/2,
        child:Image.asset('images/Shmoney.png'),
      ),

    );
  }
}
