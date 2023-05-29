import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verify_devices/product_console/productDashboard.dart';
import 'package:verify_devices/screens/after_splashScreen.dart';

import 'helper/helperFunctions.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late bool userIsLoggedIn;
  late String loggedInUserEmail;

  getLoggedInState() async {
    bool? loggedIn = await HelperFunctions.getUserLoggedInSharedPreference();
    String? email = await HelperFunctions.getUserEmailSharedPreference();
    setState(() {
      userIsLoggedIn = loggedIn!;
      loggedInUserEmail = email!;
    });
  }

  /// TODO initState
  void initState() {
    getLoggedInState();
    super.initState();
    Timer(Duration(seconds: 3), homeScreen);
  }

  /// Callback function
  void homeScreen() {
    if (userIsLoggedIn != null && userIsLoggedIn == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ProductDashboard()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              backgroundImage: AssetImage('images/logo1.png'),
              backgroundColor: Colors.transparent,
              radius: 60.0,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            'Stolen Devices Recovery\nApp',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.yellow,
              fontFamily: 'Monsterrat',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
