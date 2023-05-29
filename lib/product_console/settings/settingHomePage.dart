import 'package:flutter/material.dart';
import 'package:verify_devices/product_console/settings/passwordSetting/passwordReset.dart';

import '../../helper/helperFunctions.dart';
import '../../screens/after_splashScreen.dart';
import '../../services/auth.dart';
import '../../shared/widgets.dart';
import 'accountSetting/viewAccount.dart';


class SettingsHomePage extends StatefulWidget {
  @override
  _SettingsHomePageState createState() => _SettingsHomePageState();
}

class _SettingsHomePageState extends State<SettingsHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15.0, top: 10.0),
              // ignore: deprecated_member_use
              child: TextButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                label: Text("Back", style: TextStyle(color: Colors.white)),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 100.0, 0.0, 0.0),
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(200.0, 80.0, 0.0, 0.0),
              child: Text(
                '.',
                style: TextStyle(
                  fontSize: 80.0,
                  fontWeight: FontWeight.bold,
                  color: settingButtonColor,
                ),
              ),
            ),

            /// Account settings
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 220.0, 20, 0.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ViewAccount()));
                },
                child: Container(
                  height: 50.0,
                  child: Material(
                    shape: shapeFiftyCircular(),
                    color: settingButtonColor,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Account Setting',
                              style: settingHomeButtonTextStyle()),
                          Icon(Icons.arrow_forward, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),

            /// Password reset
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 300.0, 20, 0.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PasswordReset()));
                },
                child: Container(
                  height: 50.0,
                  child: Material(
                    shape: shapeFiftyCircular(),
                    color: settingButtonColor,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Password Reset',
                              style: settingHomeButtonTextStyle()),
                          Icon(Icons.arrow_forward, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),

            /// Logout
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 380.0, 20, 0.0),
              child: GestureDetector(
                onTap: () async {
                  await AuthService().signOut();
                  HelperFunctions.saveUserLoggedInSharedPreference(false);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Container(
                  height: 50.0,
                  child: Material(
                    shape: shapeFiftyCircular(),
                    color: settingButtonColor,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Logout', style: settingHomeButtonTextStyle()),
                          Icon(Icons.login_outlined, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// App Name and Logo
            Padding(
              padding: EdgeInsets.only(top: 600.0),
              child: Column(
                children: [
                  /// Logo
                  Center(
                    child: CircleAvatar(
                      backgroundImage: AssetImage('images/logo1.png'),
                      backgroundColor: Colors.transparent,
                      radius: 30.0,
                    ),
                  ),

                  /// App Name
                  Center(
                    child: Text(
                      'Stolen Devices Recovery App',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.yellow,
                        fontFamily: 'Monsterrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
