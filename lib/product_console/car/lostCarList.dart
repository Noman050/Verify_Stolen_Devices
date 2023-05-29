import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:verify_devices/product_console/car/searchLostCar.dart';

import '../../services/database.dart';
import '../../shared/widgets.dart';

// ignore: must_be_immutable
class LostCarList extends StatefulWidget {
  @override
  _LostCarListState createState() => _LostCarListState();
}

class _LostCarListState extends State<LostCarList> {
  get alertDialogColor => null;

  /// Display Lost Mobile Image with Data
  void displayLostMobileImageWithData(String carName, String carVIN,
      String carContact, String carPurDate, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: alertDialogColor,
          shape: shapeTwentyCircular(),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Model: $carName", style: viewOutputAlertDialogTextStyle()),
              Text("IMEI No: $carVIN", style: viewOutputAlertDialogTextStyle()),
              Text("Contact No: $carContact",
                  style: viewOutputAlertDialogTextStyle()),
              Text("Purchasing Date: $carPurDate",
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
      appBar: appBarMain("Lost Car List"),
      floatingActionButton: FloatingActionButton(
        backgroundColor: floatingButtonColor,
        elevation: 10.0,
        child: Icon(Icons.saved_search_outlined,
            color: insideFloatingButtonIconColor, size: 30.0),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SearchLostCar()));
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
                  stream: DatabaseService().fetchLostCarData(),
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
                                                ds["Lost_Car_Name"],
                                                ds["Lost_Car_VIN"],
                                                ds["Lost_Car_Contact"],
                                                ds["Lost_Car_PurDate"]
                                                    .toString()
                                                    .split(" ")
                                                    .first,
                                                ds["Lost_Car_Image_Url"],
                                              );
                                            },
                                          ),
                                          Text(
                                            ds["Lost_Car_PurDate"]
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
                                        ds["Lost_Car_Name"],
                                        style: outputListTileNameTextStyle(),
                                      ),

                                      /// IMEI
                                      subtitle: Text(
                                        ds["Lost_Car_VIN"],
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
