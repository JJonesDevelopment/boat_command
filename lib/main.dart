import 'package:flutter/material.dart';
import 'homepage.dart';
import 'shipyard.dart';
import 'radio.dart';
import 'package:url_launcher/url_launcher.dart';



void main() {
  runApp(const MyApp());
}
//Radio with playing controller
MyRadio radio = new MyRadio();
bool playing = false;


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      //Global Font
      theme: ThemeData(fontFamily: 'PixelType'),

      home: MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

//Function that controls browser
  _launchURLBrowser() async {
    var url = Uri.parse('https:/linktr.ee/boatcommand.zip');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override

  Widget build(BuildContext context) {
    if(playing == false){
      radio.mainMenu();
      playing = true;
    }
    return Scaffold(

      body: SafeArea(
        child: Container(
          decoration:BoxDecoration(  gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: Text(
                            'F L A P P Y   _B O A T ',
                            style: TextStyle(
                              color:const Color(0xFF894142),
                              fontSize: 65,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    ),
                    Expanded(
                      child: Image.asset('images/logo.png',
                       
                        fit:BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
             // Expanded(child:Center(child: Image.asset('images/logo.png'))),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,

                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30,),
                              child: DecoratedBox(
                                decoration:BoxDecoration(  gradient: LinearGradient(colors: [
                                  Color.fromRGBO(116, 116, 191, 1.0),
                                  Color.fromRGBO(52, 138, 199, 1.0)
                                ]),),
                                child: TextButton(
                                  style:TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                  ),
                                  onPressed: () {
                                    playing = false;
                                    radio.dispose();
                                Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) =>
    const Homepage()),
    );
    },


                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      "> B O A T",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                        color:Colors.white,

                                      ),
                                    ),

                                  ),

                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30,),
                              child: DecoratedBox(
                                decoration:BoxDecoration(  gradient: LinearGradient(colors: [
                                  Color.fromRGBO(116, 116, 191, 1.0),
                                  Color.fromRGBO(52, 138, 199, 1.0)
                                ]),),
                                child: TextButton(
                                  onPressed: () {
                                    _launchURLBrowser();
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      "> LISTEN TO BOAT COMMAND",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                        color: Colors.white,

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                 Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30,),
                                      child: TextButton( //Direct to animated screen with all the boats.
                                        onPressed: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                const Shipyard()),
                                          );
                                        },
                                        style:TextButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                        ),
                                        child:Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text('> SHIPYARD',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color:Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 40,

                                            ),
                                          ),
                                        ),
                                      ),
                                    ),



                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
