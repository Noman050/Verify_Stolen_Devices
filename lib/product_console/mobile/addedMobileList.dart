import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:verify_devices/product_console/mobile/searchAddedMobile.dart';

import '../../services/database.dart';
import '../../shared/widgets.dart';

// ignore: must_be_immutable
class AddedMobileList extends StatefulWidget {
  @override
  _AddedMobileListState createState() => _AddedMobileListState();
}

class _AddedMobileListState extends State<AddedMobileList> {
  /// Variables
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController mobileNameController = new TextEditingController();
  TextEditingController mobileIMEIController = new TextEditingController();
  TextEditingController userPhoneController = new TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String imageSnap, receiptSnap;
  late DateTime _dateTime;
  bool isLoading = false;

  /// Active image file
  late File _imageFile, _receipt;

  /// Update an image via gallery
  Future _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = selected;
    });
  }

  /// Update to Firebase
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

  /// TODO Upload Receipt
  Future _pickUploadMobileReceipt(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    setState(() {
      _receipt = selected;
    });
    final file = File(_receipt.path);
    final destination = "Mobile_Receipts/${DateTime.now()}.png";
    if (_receipt != null) {
      Reference reference = FirebaseStorage.instance
          .ref(_auth.currentUser?.email)
          .child(destination);
      UploadTask _uploadTask = reference.putFile(file);
      _uploadTask.whenComplete(() async {
        try {
          String uploadedImageUrl = await reference.getDownloadURL();
          receiptSnap = uploadedImageUrl;
          showToaster("Receipt uploaded successfully");
          print("This is URL: $receiptSnap");
        } catch (e) {
          print(e.toString());
        }
      });
    } else {
      showToaster("Grant Permission and try again !");
      Navigator.of(context).pop();
    }
  }

  /// Update Mobile Data Method
  void updateMobileData(BuildContext context, DocumentSnapshot ds) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0xff282e54),
            shape: shapeTwentyCircular(),
            title: Text('Update Mobile Record !!',
                style: TextStyle(fontSize: 20.0, color: Color(0xffFFC069))),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  /// Form
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
                              "^[0-9]{4}-[0-9]{7}",
                            ).hasMatch(val!)
                                ? null
                                : 'Format XXXX-XXXXXXX';
                          },
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),

                  /// Pick Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Purchasing Date',
                        style: simpleTextStyle(),
                      ),
                      IconButton(
                        onPressed: () => _pickDate(context),
                        icon: Icon(Icons.date_range_outlined),
                        color: pickDateIconColor,
                      ),
                    ],
                  ),

                  /// Show Picked Date
                  // Center(
                  //   child: Text(
                  //     _dateTime != null
                  //         // ? "${_dateTime.month}/${_dateTime.day}/${_dateTime.year}"
                  //         ? DateFormat('yyyy-MM-dd').format(_dateTime)
                  //         : "View Picked Date",
                  //     style: viewPickedDateTextStyle(),
                  //   ),
                  // ),
                  SizedBox(height: 20.0),

                  /// Add and Upload Image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Image', style: simpleTextStyle()),
                      SizedBox(width: 25.0),
                      GestureDetector(
                        onTap: () => _pickImage(ImageSource.gallery),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: bodyCircularItemsDecoration(),
                          child: Icon(Icons.add_a_photo_outlined),
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
                ],
              ),
            ),

            /// Update Data to Firebase
            actions: [
              // ignore: deprecated_member_use
              TextButton.icon(
              
                label: Text("Update", style: TextStyle(color: Colors.white)),
                icon: Icon(Icons.update_outlined, color: Colors.white),
            
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (imageSnap != null) {
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection("SDRA_Users_Data")
                          .doc(_auth.currentUser!.email)
                          .collection("Mobile_Data")
                          .doc(ds.id);

                      /// create Map to update data in key:value pair form
                      Map<String, dynamic> mobileData = ({
                        "Mobile_Name": mobileNameController.text,
                        "Mobile_IMEI": mobileIMEIController.text,
                        "Mobile_Contact": userPhoneController.text,
                        "Mobile_PurDate": _dateTime.toString(),
                        "Mobile_Image_Url": imageSnap,
                        "Time": DateTime.now(),
                      });

                      /// update data to Firebase
                      documentReference.update(mobileData);
                      showToaster("Data updated successfully");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddedMobileList()));
                    } else {
                      showToaster("Upload image first");
                    }
                  } else {
                    showToaster("Enter data first");
                  }
                },
              )
            ],
          );
        });
  }

  /// Add to lost Mobile list
  void addToLostMobileList(BuildContext context, DocumentSnapshot ds) {
    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("SDRA_Users_Data")
          .doc(_auth.currentUser!.email)
          .collection("Lost_Mobile_Data")
          .doc(ds.id);

      /// create Map to send lost data
      Map<String, dynamic> lostMobileData = ({
        "Lost_Mobile_Name": ds["Mobile_Name"],
        "Lost_Mobile_IMEI": ds["Mobile_IMEI"],
        "Lost_Mobile_Contact": ds["Mobile_Contact"],
        "Lost_Mobile_PurDate": ds["Mobile_PurDate"],
        "Lost_Mobile_Image_Url": ds["Mobile_Image_Url"],
        "Added_Mobile_Time": ds["Time"],
        "Time": DateTime.now(),
      });

      /// send Lost data to Firebase
      documentReference.set(lostMobileData).whenComplete(() {
        /// TODO Add Receipt URL to Firebase
        DocumentReference receiptDocReference = FirebaseFirestore.instance
            .collection("SDRA_Users_Data")
            .doc(_auth.currentUser!.email)
            .collection("Purchased_Mobile_Receipts")
            .doc(ds.id);

        /// create Map to send receipt image
        Map<String, dynamic> mobileReceiptData = ({
          "Mobile_Receipt": receiptSnap,
          "Time": DateTime.now(),
        });

        receiptDocReference.set(mobileReceiptData).whenComplete(() {
          /// TODO create separate lost mobile list
          DocumentReference docReference = FirebaseFirestore.instance
              .collection("Lost_Mobile_Data")
              .doc(ds.id);

          /// create separate Map
          Map<String, dynamic> lostMobileList = ({
            "Lost_Mobile_Name": ds["Mobile_Name"],
            "Lost_Mobile_IMEI": ds["Mobile_IMEI"],
            "Lost_Mobile_Contact": ds["Mobile_Contact"],
            "Lost_Mobile_PurDate": ds["Mobile_PurDate"],
            "Lost_Mobile_Image_Url": ds["Mobile_Image_Url"],
            "Added_Mobile_Time": ds["Time"],
            "Time": DateTime.now(),
          });

          /// set separate lost mobile list
          docReference.set(lostMobileList).whenComplete(() async {
            await FirebaseFirestore.instance
                .collection("SDRA_Users_Data")
                .doc(_auth.currentUser!.email)
                .collection("Mobile_Data")
                .doc(ds.id)
                .delete();
            showToaster("Data added successfully");
            Navigator.of(context).pop();
          });
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  /// Display Mobile Image with Data
  void displayMobileImageWithData(String mobileName, String mobileIMEI,
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
      appBar: appBarMain("Added Mobile List"),
      floatingActionButton: FloatingActionButton(
        backgroundColor: floatingButtonColor,
        elevation: 10.0,
        child: Icon(Icons.saved_search_outlined,
            color: insideFloatingButtonIconColor, size: 30.0),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchMobile()));
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 10.0),
            child: Column(
              children: [
                /// Stream Builder
                StreamBuilder(
                  stream: DatabaseService().fetchMobileData(),
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
                                      leading: GestureDetector(
                                        child: CircleAvatar(
                                          backgroundColor: Color(0xff0b0704),
                                          child: Icon(
                                            Icons.update_outlined,
                                            color: Colors.yellow[700],
                                          ),
                                        ),
                                        onTap: () =>
                                            updateMobileData(context, ds),
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
                                              displayMobileImageWithData(
                                                ds["Mobile_Name"],
                                                ds["Mobile_IMEI"],
                                                ds["Mobile_Contact"],
                                                ds["Mobile_PurDate"]
                                                    .toString()
                                                    .split(" ")
                                                    .first,
                                                ds["Mobile_Image_Url"],
                                              );
                                            },
                                          ),
                                          Text(
                                            ds["Mobile_PurDate"]
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
                                        ds["Mobile_Name"],
                                        style: outputListTileNameTextStyle(),
                                      ),

                                      /// IMEI
                                      subtitle: Text(
                                        ds["Mobile_IMEI"],
                                        style: outputListTileIMEITextStyle(),
                                      ),
                                    ),
                                  ),
                                ),

                                /// TODO Add to Lost Devices Icon
                                GestureDetector(
                                  // Icon
                                  child: Icon(Icons.add_circle_outline,
                                      color: addToLostListIconColor,
                                      size: 30.0),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.grey[300],
                                            shape: shapeTwentyCircular(),
                                            title: Text(
                                              "Conform your choice by uploading"
                                              " Purchased Mobile's Receipt !",
                                            ),
                                            content: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Upload Receipt',
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () =>
                                                      _pickUploadMobileReceipt(
                                                          ImageSource.gallery),
                                                  child: Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration:
                                                        bodyCircularItemsDecoration(),
                                                    child: Icon(Icons.photo),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              // ignore: deprecated_member_use
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                               
                                                child: Text("Cancel",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                              // ignore: deprecated_member_use
                                              TextButton(
                                                onPressed: () => receiptSnap !=
                                                        null
                                                    ? addToLostMobileList(
                                                        context, ds)
                                                    : showToaster(
                                                        "Upload receipt first"),
                                                
                                                child: Text("Add to Lost List",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ],
                                          );
                                        });
                                  },
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
