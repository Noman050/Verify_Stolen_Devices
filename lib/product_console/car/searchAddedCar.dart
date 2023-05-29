import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../../shared/widgets.dart';

class SearchCar extends StatefulWidget {
  @override
  _SearchCarState createState() => _SearchCarState();
}

class _SearchCarState extends State<SearchCar> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController searchCarController = new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Search Car Data from Firebase
  late Map<String, dynamic> searchedAddedCarMap;
  void searchCarData() async {
    formKey.currentState!.validate()
        ? await FirebaseFirestore.instance
            .collection("SDRA_Users_Data")
            .doc(_auth.currentUser!.email)
            .collection("Car_Data")
            .where("Car_VIN", isEqualTo: searchCarController.text)
            .get()
            .then((result) {
            setState(() => searchedAddedCarMap = result.docs[0].data());
            print(searchedAddedCarMap);
          })
        : showToaster("Enter VIN first");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// Form
              Container(
                color: searchBarColor,
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration(
                            'Search by VIN...',
                            Icon(Icons.drive_eta_outlined, color: Colors.grey),
                          ),
                          controller: searchCarController,
                          validator: (val) {
                            return val!.isEmpty || val.length != 17
                                ? 'Enter 17 characters VIN number'
                                : null;
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => searchCarData(),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: bodyCircularItemsDecoration(),
                        child: Icon(Icons.search),
                      ),
                    ),
                  ],
                ),
              ),

              /// Divider
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child:
                    Divider(thickness: 1.0, height: 20.0, color: Colors.green),
              ),

              /// Display Searched Data
              Padding(
                padding: EdgeInsets.all(10.0),
                child: searchedAddedCarMap != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Model: " + searchedAddedCarMap["Car_Name"],
                            style: searchedDataOutputTextStyle(),
                          ),
                          Text(
                            "VIN No: " + searchedAddedCarMap["Car_VIN"],
                            style: searchedDataOutputTextStyle(),
                          ),
                          Text(
                            "Contact No: " + searchedAddedCarMap["Car_Contact"],
                            style: searchedDataOutputTextStyle(),
                          ),
                          Text(
                            "Purchasing Date: " +
                                searchedAddedCarMap["Car_PurDate"]
                                    .toString()
                                    .split(" ")
                                    .first,
                            style: searchedDataOutputTextStyle(),
                          ),
                          SizedBox(height: 20.0),
                          InteractiveViewer(
                            minScale: 0.1,
                            maxScale: 5,
                            child: Image.network(
                              searchedAddedCarMap["Car_Image_Url"],
                            ),
                          ),
                        ],
                      )
                    : Text("Search data to view !!",
                        textAlign: TextAlign.center, style: simpleTextStyle()),
              ),

              /// Buttons
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                // ignore: deprecated_member_use
                child: TextButton.icon(
                  label: Text('Refresh', style: simpleTextStyle()),
                  icon: Icon(Icons.refresh_outlined, color: Colors.white),
                  onPressed: () => setState(() {
                    searchCarController.clear();
                    searchedAddedCarMap = {};
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
