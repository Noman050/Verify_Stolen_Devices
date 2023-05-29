import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verify_devices/product_console/settings/settingHomePage.dart';

import '../shared/widgets.dart';
import 'bike/bike.dart';
import 'car/car.dart';
import 'mobile/mobile.dart';


class ProductDashboard extends StatefulWidget {
  @override
  _ProductDashboardState createState() => _ProductDashboardState();
}

class _ProductDashboardState extends State<ProductDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              /// TODO Settings
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsHomePage()));
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 300.0),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: bodyCircularItemsDecoration(),
                    child: Icon(Icons.settings),
                  ),
                ),
              ),

              /// TODO Logo
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 10.0),
                child:
                    Image.asset('images/product_dashboard.png', width: 130.0),
              ),

              /// TODO Heading
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 170),
                child: Text(
                  'Product Dashboard',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 15.0,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),

              /// TODO Cards
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 250.0),
                    //TODO Mobile
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 800),
                            transitionsBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secAnimation,
                                Widget child) {
                              return ScaleTransition(
                                scale: animation,
                                alignment: Alignment.center,
                                child: child,
                              );
                            },
                            pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation) {
                              return MobilePage();
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: 320,
                        height: 120.0,
                        child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: Text(
                                  "Add Mobiles",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Times New Roman',
                                    fontSize: 18.0,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Image(
                                height: 60,
                                image: AssetImage("images/mobile.png"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    //TODO Bike
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 800),
                            transitionsBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secAnimation,
                                Widget child) {
                              return ScaleTransition(
                                scale: animation,
                                alignment: Alignment.center,
                                child: child,
                              );
                            },
                            pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation) {
                              return BikePage();
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: 320,
                        height: 120.0,
                        child: Card(
                          elevation: 5.0,
                          color: Colors.yellow[300],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: Text(
                                  "Add Bikes",
                                  style: TextStyle(
                                      fontFamily: 'Times New Roman',
                                      fontSize: 18.0,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Image(
                                height: 60,
                                image: AssetImage("images/bike.png"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    //TODO Car
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 800),
                            transitionsBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secAnimation,
                                Widget child) {
                              return ScaleTransition(
                                scale: animation,
                                alignment: Alignment.center,
                                child: child,
                              );
                            },
                            pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation) {
                              return CarPage();
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: 320.0,
                        height: 120.0,
                        child: Card(
                          elevation: 5.0,
                          color: Colors.red[300],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: Text(
                                  "Add Cars",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Times New Roman',
                                    fontSize: 18.0,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Image(
                                height: 60,
                                image: AssetImage("images/car.png"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
