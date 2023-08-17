import 'dart:async';
import 'package:boat_command/barrier.dart';
import 'package:boat_command/main.dart';
import 'package:flutter/material.dart';
import 'boat.dart';
import 'money.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'wallet.dart';
import  'radio.dart';
class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //boat variables
  static double boatY = 0;
  late int balance;
  double initialPos = boatY;
  double height = 0;
  double time = 0;
  double gravity = -3.1; //Strength of Gravity -4.9
  double velocity = 2.2; //How strong the jump is 2.5
  late final double boatWidth;
 late final double boatHeight;

 //Money Variables
  double moneyWidth = .3;
  double moneyHeight = .4;
  double moneyX = 2.5;
  double moneyY = 0;
  int gameBalance = 0;
  Wallet wallet = Wallet();

  //Score Variables
  int score = 0;
  late int highScore;
  bool isHighscore = false;

  //Constructor Variables
  late double width;
  late String name;
  late int selectedBoat = 0;
  bool loaded = false;

  //Radio
  MyRadio radio = MyRadio();

//game settings
  bool gameHasStarted = false;

  //Boat Fleet
  List<MyBoat> myBoats = [
    MyBoat(
      boatY:  boatY,
      boatWidth: .23,
      boatHeight: .35,
      boatName: 'classic',
      boatCost: 0,
    ),
    MyBoat(
      boatY: boatY,
      boatWidth: .3,
      boatHeight: .18,
      boatName: 'smoothSailor',
      boatCost: 50,
    ),
    MyBoat(
      boatY: boatY,
      boatWidth: .27,
      boatHeight: .3,
      boatName: 'steamBoat',
      boatCost: 75,
    ),
    MyBoat(
      boatY: boatY,
      boatWidth: .3,
      boatHeight: .186,
      boatName: 'daYacht',
      boatCost: 100,
    ),
  ];


  //Construct Boat
  Future<void> fetchBoat() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int _selected = prefs.getInt('selected') ?? 0;
    setState(() => selectedBoat=  _selected);
    getWidth();
    getHeight();
    getName();

  }
    void getWidth(){

      boatWidth = myBoats[selectedBoat].boatWidth;

    }
    void getHeight(){

      boatHeight = myBoats[selectedBoat].boatHeight;
    }
    void getName(){

    name = myBoats[selectedBoat].boatName;
    }


  bool moneyObtained() {
    if (moneyX <= boatWidth &&
        moneyX + moneyWidth >= -boatWidth &&
        (boatY >= moneyY && boatY + boatHeight <= moneyY + moneyHeight)) {

      return true;
    }
    return false;
  }



  //Scoring Methods
  Future<void> getHighscore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int _highscore = prefs.getInt('highscore') ?? 0;
    setState(() => highScore = _highscore);
  }

  Future<void> checkHighscore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (score > highScore) {
      prefs.setInt('highscore', score);
      isHighscore = true;
    }
    getHighscore();
  }

  bool boatScored() {
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] >= -.001 && barrierX[i] <= .001) {
        return true;
      }
    }
    return false;
  }

  //Wallet
  Future<void> getBalance() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int _balance = prefs.getInt('money') ?? 0;
    setState(()  =>   balance = _balance);
    print(balance);

  }
  //Barrier Methods

  static List<double> barrierX = [
    2,
    2 + 1.5,
    2 + 3,
    2 + 4.5
  ];

  static double barrierWidth = .5; //maximum 2.

  List<List<double>> barrierHeight = [
    //topHeight,bottomHeight
    //Max height is 2, where 2 is top of screen
    [.6, .4],
    [.4, .6],
    [.2, .5],
    [.1,.3],
  ];
  void barrierReset() {
    barrierX = [
      2,
      2 + 1.5,
      2 + 3,
      2 + 4.5,
    ];
  }
//Gameplay Methods
  bool boatCrashed() {
    if (boatY < -1 || boatY > 1) {

      return true;


    }
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= boatWidth &&
          barrierX[i] + barrierWidth >= -boatWidth &&
          (boatY <= -1 + barrierHeight[i][0] ||
              boatY + boatHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }

    return false;
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      boatY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = boatY;
      isHighscore = false;
      setState(() {
        barrierReset();
        moneyX = 2.5;
        gameBalance = 0;
      });

      score = 0;
    });
  }

  void gameOver() { //Consolidate Scores and Show Death Alert

    checkHighscore(score);
    getHighscore();
    wallet.addBalance(gameBalance); //Add Collected money to wallet
    radio.death(); //Play Death Music
    Alert(
        style: AlertStyle(
          isCloseButton: false,
          isOverlayTapDismiss: false,
        ),
        context: context,
        image:
            Image.asset('images/IBOATED.png', alignment: Alignment.topCenter),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
              child: Text(isHighscore ? 'N E W   H I G H   S C O R E!' : '',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )), //TODO:Animate
            )),

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text('$score',
                              style: TextStyle(fontSize: 40)),
                        ),
                        Text('SCORE', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text('$gameBalance',
                              style: TextStyle(fontSize: 40)),
                        ),
                        Text('CASH', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0,8.0,1.0,8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text('$highScore',
                              style: TextStyle(fontSize: 40)),
                        ),
                        Text('HIGHSCORE', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold,)),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        buttons: [
          DialogButton(
            child: Text(
              "PLAY AGAIN",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            onPressed: () {
              radio.restart();
              resetGame();
            },
            gradient: LinearGradient(colors: [
              Color.fromRGBO(116, 116, 191, 1.0),
              Color.fromRGBO(52, 138, 199, 1.0)
            ]),
          ),
          DialogButton(
            child: Text(
              "MAIN MENU",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            onPressed: () {
              resetGame();
              radio.dispose();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MainMenu()),
              );
            },
            gradient: LinearGradient(colors: [
              Color.fromRGBO(116, 116, 191, 1.0),
              Color.fromRGBO(52, 138, 199, 1.0)
            ]),
          )
        ]).show();
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= .005;
        moneyX -= .00130;
      });
      if (moneyX < -1.5) {
        moneyX += 5;
      }

      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
      }
    }
  }


  void startGame() {
    getHighscore();
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      height = (gravity * time * time) + (velocity * time);
      setState(() {
        boatY = initialPos - height;
      });
      if (boatCrashed()) {
        timer.cancel();
        //_showDialog();
        gameOver();
      }
      if (boatScored()) {
        score++;
        checkHighscore(score);
      }
      if (moneyObtained()) {
        setState(() {
          gameBalance++;
          moneyX += 3.5;
        });
      }

      moveMap();

      time += 0.01;
    });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = boatY;
    });
  }


  @override
  void initState(){
    super.initState();
   fetchBoat();

   radio.initialize();
  }
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [

            Expanded(
              flex: 3,
              child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/space.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Stack(
                      children: [

                        //Create money
                        Money(moneyX: moneyX, moneyY: moneyY, moneyWidth:.25, moneyHeight:.35),

                        //Final Boat
                        MyBoat(
                          boatY:  boatY,
                          boatWidth: boatWidth,
                          boatHeight: boatHeight,
                          boatName: name,
                          boatCost: 0,
                        ),

                        //Create Barriers
                        //top barrier 0

                        MyBarrier(
                          barrierX: barrierX[0],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[0][0],
                          isThisBottomBarrier: false,
                        ),

                        //bottom barrier 0
                        MyBarrier(
                          barrierX: barrierX[0],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[0][1],
                          isThisBottomBarrier: true,
                        ),
                        //top barrier 1
                        MyBarrier(
                          barrierX: barrierX[1],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[1][0],
                          isThisBottomBarrier: false,
                        ),
                        MyBarrier(
                          barrierX: barrierX[1],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[1][1],
                          isThisBottomBarrier: true,
                        ),

                        MyBarrier(
                          barrierX: barrierX[2],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[2][0],
                          isThisBottomBarrier: false,
                        ),
                        MyBarrier(
                          barrierX: barrierX[2],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[2][1],
                          isThisBottomBarrier: true,
                        ),
                        MyBarrier(
                          barrierX: barrierX[2],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[3][0],
                          isThisBottomBarrier: false,
                        ),
                        MyBarrier(
                          barrierX: barrierX[2],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[3][1],
                          isThisBottomBarrier: true,
                        ),

                        Container(
                          alignment: Alignment(0, -.5),
                          child: Text(
                              gameHasStarted
                                  ? score.toString()
                                  : 'T A P   T O   B O A T',
                              style: TextStyle(
                                fontSize: 60,
                                color: Colors.white,
                              )),
                        ),

                      Container(
                        alignment: Alignment(.8, -.8),
                        child: Text(gameHasStarted ? '\$ $gameBalance' : '',
                        style:TextStyle(fontSize: 50,
                        color: Colors.white,)),
                      ),








                      ],
                    ),
                  )),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('images/boatWater.png'), //TODO: make move
                  fit: BoxFit.cover,
                )),
                child:Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                        Center(child: Text('BOATING TO',
                        style:TextStyle(fontSize:40, color:Colors.black,))),
                        Center(child:Text(radio.getTitle(),
                            style:TextStyle(fontSize:60,))),
                    ],
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
