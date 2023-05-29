import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/database.dart';
import '../../shared/widgets.dart';


class BikeReceiptPage extends StatefulWidget {
  @override
  _BikeReceiptPageState createState() => _BikeReceiptPageState();
}

class _BikeReceiptPageState extends State<BikeReceiptPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBarMain("Purchased Mobile Receipts"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0),
            child: Column(
              children: [
                /// Stream Builder
                StreamBuilder(
                  stream: DatabaseService().fetchPurchasedBikeReceipt(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.toString().length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data.toString()[index] as DocumentSnapshot<Object?>;
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              color: Colors.black,
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                child: InteractiveViewer(
                                  minScale: 0.1,
                                  maxScale: 5,
                                  child: Image.network(
                                    ds["Bike_Receipt"],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Align(
                        alignment: FractionalOffset.center,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black,
                          color: Colors.yellow[700],
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
