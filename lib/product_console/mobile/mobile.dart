import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:verify_devices/product_console/mobile/purchasedMobileReceiptList.dart';

import '../../shared/loading.dart';
import '../../shared/widgets.dart';
import 'addedMobileList.dart';
import 'lostMobileList.dart';

// ignore: must_be_immutable
class MobilePage extends StatefulWidget {
  @override
  _MobilePageState createState() => _MobilePageState();
}

class _MobilePageState extends State<MobilePage>
    with SingleTickerProviderStateMixin {
  /// Variables
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController mobileNameController = new TextEditingController();
  TextEditingController mobileIMEIController = new TextEditingController();
  TextEditingController userPhoneController = new TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String imageSnap;
  late DateTime _dateTime;
  bool isLoading = false;

  /// Active image file
  late File _imageFile;

  /// Select an image via gallery
  Future _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = selected;
    });
  }

  /// Upload to Firebase
  Future _uploadImage() async {
    final file = File(_imageFile.path);
    final destination = "Mobile_Images/${DateTime.now()}.png";
    if (_imageFile != null) {
      Reference reference = FirebaseStorage.instance
          .ref(_auth.currentUser!.email)
          .child(destination);
      UploadTask _uploadTask = reference.putFile(file);
      _uploadTask.whenComplete(() async {
        try {
          String uploadedImageUrl = await reference.getDownloadURL();
          imageSnap = uploadedImageUrl;
          showToaster("Image uploaded successfully");
          print("This is URL: $imageSnap");
        } catch (e) {
          print(e.toString());
        }
      });
    } else {
      showToaster("Grant Permission and try again !");
      Navigator.of(context).pop();
    }
  }

  /// Pick Date
  Future _pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.day,
      initialDate: _dateTime,
      // builder: (BuildContext context, Widget child) {
      //   return Theme(
      //     data: ThemeData.light().copyWith(
      //       colorScheme: ColorScheme.light(primary: Colors.teal[700]),
      //       // color of the text in the button "OK/CANCEL"
      //       // buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
      //     ),
      //     child: child,
      //   );
      // },
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (newDate != null) {
      setState(() => _dateTime = newDate);
    }
  }
  // =============== Pick Date =============== //
  // Future _pickDate(BuildContext context) async {
  //   final initialDate = DateTime.now();
  //   final newDate = await showDatePicker(
  //     context: context,
  //     initialDate: _dateTime ?? initialDate,
  //     firstDate: DateTime(DateTime.now().year - 10),
  //     lastDate: DateTime(DateTime.now().year + 10),
  //   );
  //   if (newDate != null) {
  //     setState(() => _dateTime = newDate);
  //   }
  // }

  /// Create Mobile Data Method
  createMobileData() async {
    try {
      if (formKey.currentState!.validate()) {
        setState(() => isLoading = true);
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection("SDRA_Users_Data")
            .doc(_auth.currentUser!.email)
            .collection("Mobile_Data")
            .doc();

        /// create Map to send data in key:value pair form
        Map<String, dynamic> mobileData = ({
          "Mobile_Name": mobileNameController.text,
          "Mobile_IMEI": mobileIMEIController.text,
          "Mobile_Contact": userPhoneController.text,
          "Mobile_PurDate": _dateTime.toString(),
          "Mobile_Image_Url": imageSnap,
          "Time": DateTime.now(),
        });

        /// send data to Firebase
        documentReference.set(mobileData).whenComplete(() {
          showToaster("Data uploaded successfully");
          mobileNameController.clear();
          mobileIMEIController.clear();
          userPhoneController.clear();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MobilePage()));
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  /// Update Mobile Data Method
  // updateMobileData(BuildContext context, DocumentSnapshot ds) async {
  //   try {
  //     if (formKey.currentState.validate()) {
  //       setState(() => isLoading = true);
  //       DocumentReference documentReference = FirebaseFirestore.instance
  //           .collection("SDRA_Users_Data")
  //           .doc(_auth.currentUser.email)
  //           .collection("Mobile_Data")
  //           .doc(ds.id);
  //
  //       /// create Map to update data in key:value pair form
  //       Map<String, dynamic> mobileData = ({
  //         "Mobile_Name": mobileNameController.text,
  //         "Mobile_IMEI": mobileIMEIController.text,
  //         "Mobile_PurDate": _dateTime.toString(),
  //         "Mobile_Image_Url": imageSnap,
  //         "Time": DateTime.now(),
  //       });
  //
  //       /// update data to Firebase
  //       documentReference.update(mobileData);
  //       showToaster("Data updated successfully");
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => MobilePage()));
  //     } else {
  //       setState(() => isLoading = false);
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  /// Display Mobile Image
  // void displayMobileImageWithData(String mobileName, String mobileIMEI,
  //     String mobilePurDate, String imageUrl) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape: alertDialogShape(),
  //         title: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text("Name: $mobileName", style: alertDialogTextStyle()),
  //             Text("IMEI No: $mobileIMEI", style: alertDialogTextStyle()),
  //             Text("Purchasing Date: $mobilePurDate",
  //                 style: alertDialogTextStyle()),
  //           ],
  //         ),
  //         content: Image.network(imageUrl, fit: BoxFit.fill),
  //         backgroundColor: Colors.yellow[700],
  //         actions: [
  //           MaterialButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             color: Colors.black,
  //             shape: materialButtonBorder(),
  //             child: Text('Ok', style: simpleTextStyle()),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Loading();
    } else {
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
                      child: Icon(Icons.phone_android_outlined, size: 50.0),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 80.0),
                  child: Column(
                    children: [
                      // TODO Form
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            /// Name
                            TextFormField(
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration(
                                'Enter Mobile Model',
                                Icon(Icons.phone_android_outlined,
                                    color: fieldIconColor),
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              controller: mobileNameController,
                              validator: (val) {
                                return val!.isEmpty || val.length > 21
                                    ? 'Name can\'t be longer than 20 characters'
                                    : null;
                              },
                            ),
                            SizedBox(height: 10.0),

                            /// IMEI
                            TextFormField(
                              style: simpleTextStyle(),
                              keyboardType: TextInputType.number,
                              decoration: textFieldInputDecoration(
                                'Enter Mobile IMEI No',
                                Icon(Icons.phone_android_outlined,
                                    color: fieldIconColor),
                              ),
                              controller: mobileIMEIController,
                              validator: (val) {
                                return val!.isEmpty || val.length != 15
                                    ? 'Enter 15-digit IMEI number'
                                    : null;
                              },
                            ),
                            SizedBox(height: 10.0),

                            /// Phone
                            TextFormField(
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration(
                                'Enter Contact No',
                                Icon(Icons.phone, color: fieldIconColor),
                              ),
                              controller: userPhoneController,
                              validator: (val) {
                                return RegExp(
                                  // "^(?:[+0]9)?[0-9]{10,12}",
                                  "^[0-9]{4} [0-9]{7}",
                                ).hasMatch(val!)
                                    ? null
                                    : 'Format XXXX XXXXXXX';
                              },
                            ),
                            // TextFormField(
                            //   style: simpleTextStyle(),
                            //   decoration: textFieldInputDecoration(
                            //     'Mobile Purchasing Date',
                            //     Icon(Icons.phone_android_outlined,
                            //         color: Colors.white54),
                            //   ),
                            //   controller: mobilePurDateController,
                            //   validator: (val) {
                            //     return RegExp(
                            //       r"^[0-9]{4}-[0-9]{2}-[0-9]{2}",
                            //     ).hasMatch(val)
                            //         ? null
                            //         : 'Format YYYY-MM-DD';
                            //   },
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      // TODO Pick Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select Mobile Purchasing Date',
                            style: simpleTextStyle(),
                          ),
                          IconButton(
                            onPressed: () => _pickDate(context),
                            icon: Icon(Icons.date_range_outlined),
                            color: pickDateIconColor,
                          ),
                        ],
                      ),
                      // TODO Show Picked Date
                      Center(
                        child: Text(
                          _dateTime != null
                              // ? "${_dateTime.month}/${_dateTime.day}/${_dateTime.year}"
                              ? DateFormat('yyyy-MM-dd').format(_dateTime)
                              : "View Picked Date",
                          style: viewPickedDateTextStyle(),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      // TODO Add Image
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pick Image',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: pickUploadImageTextColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _pickImage(ImageSource.gallery),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: bodyCircularItemsDecoration(),
                              child: Icon(Icons.add_a_photo_outlined),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      // TODO Upload Image
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Upload Image',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: pickUploadImageTextColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _uploadImage(),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: bodyCircularItemsDecoration(),
                              child: Icon(Icons.cloud_upload_outlined),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 100.0),
                      // TODO Add Button
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () => formKey.currentState!.validate()
                                  ? imageSnap != null
                                      ? createMobileData()
                                      : showToaster("Upload image first")
                                  : showToaster("Enter data first"),
                              color: buttonColor,
                              shape: shapeFiftyCircular(),
                              child: Text('ADD', style: simpleTextStyle()),
                            ),
                          ),
                        ],
                      ),
                      // TODO View Button
                      Row(
                        children: [
                          /// Added List Button
                          Expanded(
                            child: MaterialButton(
                              color: addedLostListButtonColor,
                              shape: shapeFiftyCircular(),
                              child: Text('Added List',
                                  style: textInsideButtonStyle()),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddedMobileList()));
                              },
                            ),
                          ),
                          SizedBox(width: 10.0),

                          /// Lost List Button
                          Expanded(
                            child: MaterialButton(
                              color: addedLostListButtonColor,
                              shape: shapeFiftyCircular(),
                              child: Text('Lost List',
                                  style: textInsideButtonStyle()),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LostMobileList()));
                              },
                            ),
                          ),
                        ],
                      ),

                      /// Stream Builder
                      // StreamBuilder(
                      //   stream: DatabaseService().fetchMobileData(),
                      //   builder: (context, snapshot) {
                      //     if (snapshot.hasData) {
                      //       return ListView.builder(
                      //           physics: NeverScrollableScrollPhysics(),
                      //           shrinkWrap: true,
                      //           itemCount: snapshot.data.docs.length,
                      //           itemBuilder: (context, index) {
                      //             DocumentSnapshot ds =
                      //                 snapshot.data.docs[index];
                      //             return Row(
                      //               children: [
                      //                 Expanded(
                      //                   child: Card(
                      //                     shape: cardShape(),
                      //                     color: Colors.blueGrey[700],
                      //                     child: ListTile(
                      //                       /// Update
                      //                       leading: GestureDetector(
                      //                         child: CircleAvatar(
                      //                           backgroundColor:
                      //                               Color(0xff0b0704),
                      //                           child: Icon(
                      //                             Icons.update_outlined,
                      //                             color: Colors.yellow[700],
                      //                           ),
                      //                         ),
                      //                         onTap: () => formKey.currentState
                      //                                 .validate()
                      //                             ? imageSnap != null
                      //                                 ? updateMobileData(
                      //                                     context, ds)
                      //                                 : showToaster(
                      //                                     "Upload image first")
                      //                             : showToaster(
                      //                                 "Enter data first"),
                      //                       ),
                      //
                      //                       /// Date
                      //                       trailing: Column(
                      //                         mainAxisAlignment:
                      //                             MainAxisAlignment.spaceEvenly,
                      //                         children: [
                      //                           GestureDetector(
                      //                             child: Icon(
                      //                               Icons
                      //                                   .remove_red_eye_outlined,
                      //                               color: Colors.yellow[700],
                      //                             ),
                      //                             onTap: () {
                      //                               displayMobileImageWithData(
                      //                                 ds["Mobile_Name"],
                      //                                 ds["Mobile_IMEI"],
                      //                                 ds["Mobile_PurDate"]
                      //                                     .toString()
                      //                                     .split(" ")
                      //                                     .first,
                      //                                 ds["Mobile_Image_Url"],
                      //                               );
                      //                               // Navigator.push(
                      //                               //   context,
                      //                               //   MaterialPageRoute(
                      //                               //     builder: (context) =>
                      //                               //         ImagePreview(
                      //                               //       // snap: snapshot
                      //                               //       //         .data.docs[index]
                      //                               //       //     ['Mobile_Image_URL'],
                      //                               //       imageSnapshot: ds[
                      //                               //           "Mobile_Image_Url"],
                      //                               //     ),
                      //                               //   ),
                      //                               // );
                      //                             },
                      //                           ),
                      //                           Text(
                      //                             ds["Mobile_PurDate"]
                      //                                 .toString()
                      //                                 .split(" ")
                      //                                 .first,
                      //                             textAlign: TextAlign.center,
                      //                             style: outputDateTextStyle(),
                      //                           ),
                      //                         ],
                      //                       ),
                      //
                      //                       /// Name
                      //                       title: Text(
                      //                         ds["Mobile_Name"],
                      //                         style: outputNameTextStyle(),
                      //                       ),
                      //
                      //                       /// IMEI
                      //                       subtitle: Text(
                      //                         ds["Mobile_IMEI"],
                      //                         style: outputIMEITextStyle(),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             );
                      //           });
                      //     } else {
                      //       return Align(
                      //         alignment: FractionalOffset.center,
                      //         child: CircularProgressIndicator(
                      //           backgroundColor: Colors.black,
                      //           color: Colors.yellow[700],
                      //         ),
                      //       );
                      //     }
                      //   },
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        /// Floating Action Button
        floatingActionButton: DraggableFab(
          child: FloatingActionButton(
            backgroundColor: Colors.lime,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MobileReceiptPage()));
            },
            child: Icon(Icons.list, color: Colors.black),
          ),
        ),
      );
    }
  }
}
