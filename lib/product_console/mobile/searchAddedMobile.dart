import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../../shared/widgets.dart';

class SearchMobile extends StatefulWidget {
  @override
  _SearchMobileState createState() => _SearchMobileState();
}

class _SearchMobileState extends State<SearchMobile> {
  /// Variables
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController searchAddedMobileController =
      new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Search Mobile Data from Firebase
  late Map<String, dynamic> searchedAddedMobileMap;
  void searchMobileData() async {
    formKey.currentState!.validate()
        ? await FirebaseFirestore.instance
            .collection("SDRA_Users_Data")
            .doc(_auth.currentUser!.email)
            .collection("Mobile_Data")
            .where("Mobile_IMEI", isEqualTo: searchAddedMobileController.text)
            .get()
            .then((result) {
            setState(() => searchedAddedMobileMap = result.docs[0].data());
            print(searchedAddedMobileMap);
          })
        : showToaster("Enter IMEI first");
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
                          keyboardType: TextInputType.number,
                          decoration: textFieldInputDecoration(
                            'Search by IMEI...',
                            Icon(Icons.phone_android_outlined,
                                color: fieldIconColor),
                          ),
                          controller: searchAddedMobileController,
                          validator: (val) {
                            return val!.isEmpty || val.length != 15
                                ? 'Enter 15-digit IMEI number'
                                : null;
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => searchMobileData(),
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
                child: searchedAddedMobileMap != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Model: " + searchedAddedMobileMap["Mobile_Name"],
                            style: searchedDataOutputTextStyle(),
                          ),
                          Text(
                            "IMEI No: " + searchedAddedMobileMap["Mobile_IMEI"],
                            style: searchedDataOutputTextStyle(),
                          ),
                          Text(
                            "Contact No: " +
                                searchedAddedMobileMap["Mobile_Contact"],
                            style: searchedDataOutputTextStyle(),
                          ),
                          Text(
                            "Purchasing Date: " +
                                searchedAddedMobileMap["Mobile_PurDate"]
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
                              searchedAddedMobileMap["Mobile_Image_Url"],
                            ),
                          ),
                        ],
                      )
                    : Text(
                        "Search data to view !!",
                        textAlign: TextAlign.center,
                        style: simpleTextStyle(),
                      ),
              ),

              /// Buttons
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                // ignore: deprecated_member_use
                child: TextButton.icon(
                 
                  label: Text('Refresh', style: simpleTextStyle()),
                  icon: Icon(Icons.refresh_outlined, color: Colors.white),
                  onPressed: () => setState(() {
                    searchAddedMobileController.clear();
                    searchedAddedMobileMap = {};
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
