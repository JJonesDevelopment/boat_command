import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'boat.dart';
import 'wallet.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Shipyard extends StatefulWidget {
  const Shipyard({Key? key}) : super(key: key);

  @override
  State<Shipyard> createState() => _ShipyardState();
}

class _ShipyardState extends State<Shipyard> {
  //Money Variables
  Wallet wallet = Wallet();
  late int balance;

  //Boat and Display Variables
  bool classicOwned = true;
  late final int boatSelected;
  String name = 'classic';
  int cost = 0;
  int boatNumber = 0;
  bool owned = true;
  late bool _isSelected;

  //Create display boats
  List<MyBoat> boatList = [
    MyBoat(
      boatY: -.2,
      boatWidth: .46,
      boatHeight: .70,
      boatName: 'classic',
      boatCost: 0,
    ),
    MyBoat(
      boatY: -.2,
      boatWidth: .5,
      boatHeight: .3,
      boatName: 'smoothSailor',
      boatCost: 50,
    ),
    MyBoat(
      boatY: -.2,
      boatWidth: .5,
      boatHeight: .56,
      boatName: 'steamBoat',
      boatCost: 75,
    ),
    MyBoat(
      boatY: -.2,
      boatWidth: .6,
      boatHeight: .375,
      boatName: 'daYacht',
      boatCost: 100,
    ),
  ];

  //Select Methods
  Future<int> getBoat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int selected = prefs.getInt('selected') ?? 0;
    boatSelected = selected;
    return boatSelected;
  }

  Future<void> selectBoat() async {
    setState(() {
      _isSelected = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selected', boatNumber);
    setState(() {
      boatSelected = boatNumber;
    });
  }

  Future<bool> isSelected() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int selected = prefs.getInt('selected') ?? 0;
    if (boatNumber == selected) {
      setState(() {
        _isSelected = true;
      });
      return true;
    } else {
      setState(() {
        _isSelected = false;
      });
      return false;
    }
  }

  //Purchasing methods
  Future<void> setOwned(String _name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_name, true);
  }

  Future<void> checkOwned(String viewing) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool boatOwned = prefs.getBool(viewing) ?? false;
    setState(() {
      if (viewing == 'classic') {
        owned = true;
      } else {
        setState(() {
          owned = boatOwned;
        });
      }
    });
  }

  void purchaseBoat() {
    if (balance >= boatList[boatNumber].boatCost) {
      Alert(
          style: AlertStyle(
            isCloseButton: false,
            isOverlayTapDismiss: false,
          ),
          context: context,
          title: "PURCHASE $name?",
          buttons: [
            DialogButton(
              child: Text(
                "TERMINATE",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            DialogButton(
              child: Text(
                "CONFIRM",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                wallet.subtractBalance(boatList[boatNumber].boatCost);
                setState(() {
                  getBalance();
                });
                setOwned(boatList[boatNumber].boatName);
                checkOwned(boatList[boatNumber].boatName);

                Navigator.pop(context);
              },
              gradient: LinearGradient(colors: [
                Color.fromRGBO(116, 116, 191, 1.0),
                Color.fromRGBO(52, 138, 199, 1.0)
              ]),
              color: Color.fromRGBO(0, 179, 134, 1.0),
            ),
          ]).show();
    } else {
      Alert(
              style: AlertStyle(
                  isCloseButton: false,
                  isOverlayTapDismiss: false,
                  titleStyle: TextStyle(
                    fontSize: 30,
                  ),
                  descStyle: TextStyle(
                    fontSize: 25,
                  )),
              context: context,
              title: "INSUFFICIENT FUNDS",
              desc: "ACQUIRE MORE MONEY AND COME BACK LATER")
          .show();
    }
  }

  //Display Methods
  void nextBoat() {
    if (boatNumber < boatList.length - 1) {
      boatNumber++;
      setState(() {
        name = boatList[boatNumber].boatName;
        cost = boatList[boatNumber].boatCost;
      });
      checkOwned(name);
      isSelected();
    }
  }

  void prevBoat() {
    if (boatNumber > 0) {
      boatNumber--;

      setState(() {
        name = boatList[boatNumber].boatName;
        cost = boatList[boatNumber].boatCost;
      });
      checkOwned(name);
      isSelected();
    }
  }

  //Get Wallet
  Future<void> getBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int _balance = prefs.getInt('money') ?? 0;
    setState(() => balance = _balance);
  }

  @override
  void initState() {
    getBoat();
    getBalance();
    isSelected();
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color(0x44000000),
          elevation: 0,
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('images/shipYard.png'), //TODO: make move
              fit: BoxFit.cover,
            )),
            child: Column(
              children: [
                Expanded(
                    child: Center(
                        child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 80,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        owned ? 'OWNED' : '\$ $cost',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                        ),
                      ),
                    )
                  ],
                ))),
                Expanded(
                    child: Center(
                        child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            prevBoat();
                          });
                        },
                        child: Text(
                          '<',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 80,
                          ),
                        )),
                    boatList[boatNumber],
                    TextButton(
                        onPressed: () {
                          setState(() {
                            nextBoat();
                          });
                        },
                        child: Text(
                          '>',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 80,
                          ),
                        )),
                  ],
                ))),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: _isSelected
                                ? Text('SELECTED',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 50,
                                    ))
                                : DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Color.fromRGBO(116, 116, 191, 1.0),
                                        Color.fromRGBO(52, 138, 199, 1.0)
                                      ]),
                                    ),
                                    child: ElevatedButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                      ),
                                      onPressed: () {
                                        owned ? selectBoat() : purchaseBoat();
                                      },
                                      child: Text(owned ? 'SELECT' : 'PURCHASE',
                                          style: TextStyle(
                                            fontSize: 40,
                                            backgroundColor: Colors.transparent,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Center(
                            child: Text('BALANCE: \$ $balance',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
