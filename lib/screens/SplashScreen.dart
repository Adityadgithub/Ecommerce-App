// Following is the code for Splash Screen that will
// display for 2000 milli second while starting the application.

import 'package:flutter/material.dart';
import 'package:nirman_store/screens/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

var globalusertoken;

class _SplashScreenState extends State<SplashScreen> {
  void _getKey() async {
    // print('running');
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.get('token');
    setState(() {
      globalusertoken = key;
    });
    // print('YOUR KEY - "$key"');
  }

  //this function will run as the app starts
  @override
  void initState() {
    super.initState();
    _getKey();
    _navigatetohome();
  }

  //with a delay of 2000 millisec, the title and logo will appear on the screen.
  _navigatetohome() async {
    await Future.delayed(Duration(milliseconds: 2000), () {});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => globalusertoken == null ? SignUp() : HomePage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Image(
              height: 250,
              image: AssetImage("assets/images/splashscreen.png"))),
    );
  }
}
