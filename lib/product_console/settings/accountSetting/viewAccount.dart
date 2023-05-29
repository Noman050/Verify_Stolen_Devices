import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../shared/widgets.dart';
import 'deleteAccount.dart';


class ViewAccount extends StatefulWidget {
  @override
  _ViewAccountState createState() => _ViewAccountState();
}

class _ViewAccountState extends State<ViewAccount> {
  /// Variables
  FirebaseFirestore _user = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Map<String, dynamic> searchedUserMap;
  bool isLoading = false;

  /// Read user account details
  readUserAccountDetails() async {
    await _user
        .collection('SDRA_Users_Data')
        .doc(_auth.currentUser!.email)
        .get()
        .then((value) {
      setState(() => searchedUserMap = value.data()!);
      // print(searchedMobileMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.10,
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: stackTopLeftCornerIconDecoration(),
                  child: Center(
                    child: Icon(Icons.account_circle, size: 50.0),
                  ),
                ),
              ),

              /// Click to view
              Container(
                padding: EdgeInsets.fromLTRB(20.0, 100.0, 15.0, 0.0),
                child: Row(
                  children: [
                    Text(
                      'Click to view details',
                      style: TextStyle(fontSize: 20.0, color: Colors.white70),
                    ),
                    SizedBox(width: 90.0),
                    IconButton(
                      onPressed: () => readUserAccountDetails(),
                      color: Colors.yellow,
                      icon: Icon(Icons.remove_red_eye, size: 30.0),
                    )
                  ],
                ),
              ),

              /// Display account details
              searchedUserMap != null
                  ? Padding(
                      padding:
                          EdgeInsets.only(top: 180.0, left: 10.0, right: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// Circle Avatar
                          CircleAvatar(
                            maxRadius: 60.0,
                            backgroundColor: Color(0xffFFC069),
                            child: CircleAvatar(
                              maxRadius: 57.0,
                              backgroundColor: Color(0xff334257),
                              backgroundImage: NetworkImage(
                                searchedUserMap["Profile_Image"],
                              ),
                            ),
                          ),
                          // CircleAvatar(
                          //   maxRadius: 50.0,
                          //   backgroundColor: Color(0xffFFC069),
                          //   child: Text(
                          //     searchedUserMap["Name"]
                          //         .toString()
                          //         .substring(0, 1),
                          //     style: outputListTileNameTextStyle(),
                          //   ),
                          // ),
                          SizedBox(height: 30.0),

                          /// Name
                          Center(
                            child: Text(
                              "Name: " + searchedUserMap["Name"],
                              style: settingViewAccountTextStyle(),
                            ),
                          ),
                          SizedBox(height: 12.0),

                          /// Phone
                          Center(
                            child: Text(
                              "Phone: " + searchedUserMap["Phone"],
                              style: settingViewAccountTextStyle(),
                            ),
                          ),
                          SizedBox(height: 12.0),

                          /// CNIC
                          Center(
                            child: Text(
                              "CNIC: " + searchedUserMap["CNIC"],
                              style: settingViewAccountTextStyle(),
                            ),
                          ),
                          SizedBox(height: 12.0),

                          /// Email
                          Center(
                            child: Text(
                              "Email: " + searchedUserMap["Email"],
                              style: settingViewAccountTextStyle(),
                            ),
                          ),
                          SizedBox(height: 50.0),
                          // ignore: deprecated_member_use
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DeleteAccount()));
                            },
                         
                            icon: Icon(Icons.delete, color: Colors.white),
                            label: Text("Delete Account",
                                style: viewOutputAlertDialogButtonTextStyle()),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: 350),
                      child: SpinKitWanderingCubes(
                        // color: Color(0xffbd6c82),
                        color: Color(0xffFFC069),
                        size: 40.0,
                      ),
                    ),

              /// Logo and App Name
              Padding(
                padding: EdgeInsets.only(top: 600),
                child: Column(
                  children: [
                    Center(
                      child: CircleAvatar(
                        backgroundImage: AssetImage('images/logo1.png'),
                        backgroundColor: Colors.transparent,
                        radius: 30.0,
                      ),
                    ),
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
                    SizedBox(height: 10.0),
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
