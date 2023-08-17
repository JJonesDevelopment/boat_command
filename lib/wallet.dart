import 'package:shared_preferences/shared_preferences.dart';

class Wallet{

late int balance;


  Future<void>addBalance(int money) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int _oldBalance = prefs.getInt('money') ?? 0;
    int newBalance = _oldBalance + money;
    prefs.setInt('money',newBalance);

  }

  Future<void>subtractBalance(int money) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int _oldBalance = prefs.getInt('money') ?? 0;
    int newBalance = _oldBalance - money;
    prefs.setInt('money',newBalance);
  }



}