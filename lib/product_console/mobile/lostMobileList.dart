import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:verify_devices/product_console/mobile/searchLostMobile.dart';

import '../../services/database.dart';
import '../../shared/widgets.dart';


// ignore: must_be_immutable
class LostMobileList extends StatefulWidget {
  @override
  _LostMobileListState createState() => _LostMobileListState();
}

class _LostMobileListState extends State<LostMobileList> {
  get alertDialogColor => null;

  /// Display Lost Mobile Image with Data
  void displayLostMobileImageWithData(String mobileName, String mobileIMEI,
      String mobileContact, String mobilePurDate, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: alertDialogColor,
          shape: shapeTwentyCircular(),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Model: $mobileName",
                  style: viewOutputAlertDialogTextStyle()),
              Text("IMEI No: $mobileIMEI",
                  style: viewOutputAlertDialogTextStyle()),
              Text("Contact No: $mobileContact",
                  style: viewOutputAlertDialogTextStyle()),
              Text("Purchasing Date: $mobilePurDate",
                  style: viewOutputAlertDialogTextStyle()),
            ],
          ),
          content: InteractiveViewer(
            minScale: 0.1,
            maxScale: 5,
            child: Image.network(imageUrl, fit: BoxFit.fill),
          ),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.black,
              shape: shapeFiftyCircular(),
              child: Text('Ok', style: viewOutputAlertDialogButtonTextStyle()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain("Lost Mobile List"),
      floatingActionButton: FloatingActionButton(
        backgroundColor: floatingButtonColor,
        elevation: 10.0,
        child: Icon(Icons.saved_search_outlined,
            color: insideFloatingButtonIconColor, size: 30.0),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SearchLostMobile()));
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: Column(
              children: [
                /// Stream Builder
                StreamBuilder(
                  stream: DatabaseService().fetchLostMobileData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.toString().length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data.toString()[index] as DocumentSnapshot<Object?>;
                            return Row(
                              children: [
                                Expanded(
                                  child: Card(
                                    shape: shapeTwentyCircular(),
                                    color: alertDialogColor,
                                    child: ListTile(
                                      /// Update
                                      leading: CircleAvatar(
                                        backgroundColor: Color(0xff0b0704),
                                        child: Icon(Icons.update_outlined,
                                            color: Colors.grey),
                                      ),

                                      /// Date
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            child: Icon(
                                              Icons.remove_red_eye,
                                              color: Colors.black,
                                              size: 30.0,
                                            ),
                                            onTap: () {
                                              displayLostMobileImageWithData(
                                                ds["Lost_Mobile_Name"],
                                                ds["Lost_Mobile_IMEI"],
                                                ds["Lost_Mobile_Contact"],
                                                ds["Lost_Mobile_PurDate"]
                                                    .toString()
                                                    .split(" ")
                                                    .first,
                                                ds["Lost_Mobile_Image_Url"],
                                              );
                                            },
                                          ),
                                          Text(
                                            ds["Lost_Mobile_PurDate"]
                                                .toString()
                                                .split(" ")
                                                .first,
                                            textAlign: TextAlign.center,
                                            style:
                                                outputListTileDateTextStyle(),
                                          ),
                                        ],
                                      ),

                                      /// Name
                                      title: Text(
                                        ds["Lost_Mobile_Name"],
                                        style: outputListTileNameTextStyle(),
                                      ),

                                      /// IMEI
                                      subtitle: Text(
                                        ds["Lost_Mobile_IMEI"],
                                        style: outputListTileIMEITextStyle(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
