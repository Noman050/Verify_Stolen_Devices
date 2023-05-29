import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets.dart';

class SearchBike extends StatefulWidget {
  @override
  _SearchBikeState createState() => _SearchBikeState();
}

class _SearchBikeState extends State<SearchBike> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController searchBikeController = new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Search Bike Data from Firebase
  late Map<String, dynamic> searchedAddedBikeMap;
  void searchBikeData() async {
    formKey.currentState!.validate()
        ? await FirebaseFirestore.instance
            .collection("SDRA_Users_Data")
            .doc(_auth.currentUser!.email)
            .collection("Bike_Data")
            .where("Bike_VIN", isEqualTo: searchBikeController.text)
            .get()
            .then((result) {
            setState(() => searchedAddedBikeMap = result.docs[0].data());
            print(searchedAddedBikeMap);
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
                            Icon(Icons.directions_bike_outlined,
                                color: Colors.grey),
                          ),
                          controller: searchBikeController,
                          validator: (val) {
                            return val!.isEmpty || val.length != 17
                                ? 'Enter 17 characters VIN number'
                                : null;
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => searchBikeData(),
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
                child: searchedAddedBikeMap != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Model: " + searchedAddedBikeMap["Bike_Name"],
                            style: searchedDataOutputTextStyle(),
                          ),
                          Text(
                            "VIN No: " + searchedAddedBikeMap["Bike_VIN"],
                            style: searchedDataOutputTextStyle(),
                          ),
                          Text(
                            "Contact No: " +
                                searchedAddedBikeMap["Bike_Contact"],
                            style: searchedDataOutputTextStyle(),
                          ),
                          Text(
                            "Purchasing Date: " +
                                searchedAddedBikeMap["Bike_PurDate"]
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
                              searchedAddedBikeMap["Bike_Image_Url"],
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
                    searchBikeController.clear();
                    searchedAddedBikeMap = {};
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
