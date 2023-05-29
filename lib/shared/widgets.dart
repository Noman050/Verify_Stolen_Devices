import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

appBarMain(String title) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(
          fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
    ),
    elevation: 10.0,
    centerTitle: true,
    toolbarHeight: 45.0,
    automaticallyImplyLeading: false,
    // backgroundColor: Color(0xff4F0E0E),
    backgroundColor: Colors.teal,
    iconTheme: IconThemeData(color: Colors.black),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  );
}

/// Admin ////////////////////////////////////

Decoration adminSignInPageButtonDecoration() {
  return BoxDecoration(
    color: Color(0xFF1C1C1C),
    borderRadius: BorderRadius.all(Radius.circular(25.0)),
    boxShadow: [
      BoxShadow(
        color: Color(0xFF1C1C1C).withOpacity(0.2),
        spreadRadius: 3.0,
        blurRadius: 4.0,
        offset: Offset(0, 3),
      ),
    ],
  );
}

Decoration adminSignInPageBackgroundDecoration() {
  return BoxDecoration(
    color: Color(0xffe1a300),
    borderRadius: BorderRadius.only(
      bottomRight: Radius.circular(70.0),
      bottomLeft: Radius.circular(70.0),
    ),
  );
}

Decoration homePageBottomNavigationDecoration() {
  return BoxDecoration(
    color: Colors.black54,
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(70.0),
      topLeft: Radius.circular(70.0),
    ),
  );
}

InputDecoration adminInputDecoration(
    String labelText, Icon iconType, Widget postIconType) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(width: 0.0, style: BorderStyle.none),
    ),
    filled: true,
    fillColor: Color(0xFFECCB45),
    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
    prefixIcon: iconType,
    suffixIcon: postIconType,
    labelText: labelText,
    labelStyle: TextStyle(
        color: Colors.black38, fontSize: 16.0, fontWeight: FontWeight.bold),
  );
}

/// User /////////////////////////////////////
showToaster(String msg) {
  return Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.grey.shade700,
    textColor: Colors.white,
  );
}

/// Colors ////////////////////////////////
Color activeRadioButtonColor = Colors.black;
Color fieldIconColor = Colors.grey;
Color pickUploadImageTextColor = Colors.white70;
Color homePageRadioButtonIconColors = Colors.white;
Color iconInsideButtonColors = Colors.black;
Color homePageIconInsideButtonColors = Colors.white;
Color buttonColor = Colors.teal;
Color loginRegisterForgotPwdButtonColor = Color(0xffFFC069);
Color addedLostListButtonColor = Color(0xffFFC069);
Color settingButtonColor = Color(0xffFFC069);
// Color settingButtonColor = Color(0xffEA907A);
Color pickDateIconColor = Color(0xffFFC069);
Color searchBarColor = Color(0xff222831);
// Color searchBarColor = Color(0x54FFFFFF);
Color alertDialogColor = Color(0xffFFC069);
Color addToLostListIconColor = Colors.white;
Color floatingButtonColor = Colors.teal;
Color insideFloatingButtonIconColor = Colors.white;

/// Password View on Login and Register Page ////////////////
InputDecoration passwordViewInputDecoration(
    String labelText, Icon preIconType, Widget postIconType) {
  return InputDecoration(
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
    prefixIcon: preIconType,
    suffix: postIconType,
    labelText: labelText,
    labelStyle: TextStyle(
      color: Colors.grey,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
    ),
  );
}

InputDecoration homePageTextFieldInputDecoration(
    String labelText, Icon iconType) {
  return InputDecoration(
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
    prefixIcon: iconType,
    labelText: labelText,
    labelStyle: TextStyle(
      color: Colors.black87,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
    ),
  );
}

InputDecoration textFieldInputDecoration(String labelText, Icon iconType) {
  return InputDecoration(
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
    prefixIcon: iconType,
    labelText: labelText,
    labelStyle: TextStyle(
      color: Colors.grey,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
    ),
  );
}

/// RoundedRectangleBorder ///////////////////

RoundedRectangleBorder shapeFiftyCircular() {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50.0),
    // borderRadius: BorderRadius.horizontal(
    //   left: Radius.elliptical(50, 50),
    //   right: Radius.elliptical(50, 50),
    // ),
    ////////////////////////////////////
    // borderRadius: BorderRadius.vertical(
    //   top: Radius.elliptical(15, 15),
    //   bottom: Radius.elliptical(40, 40),
    // ),
  );
}

RoundedRectangleBorder shapeTwentyCircular() {
  return RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0));
}

/// Decoration ///////////////////////////////

Decoration stackTopLeftCornerIconDecoration() {
  return BoxDecoration(
    color: Color(0xffFFC069),
    borderRadius: BorderRadius.only(
      bottomRight: Radius.circular(30.0),
      bottomLeft: Radius.circular(30.0),
    ),
  );
}

Decoration bodyCircularItemsDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(20.0),
    color: Color(0xffFFC069),
  );
}

/// TextStyle ///////////////////////////////

TextStyle simpleTextStyle() {
  return TextStyle(fontSize: 16.0, color: Colors.white);
}

TextStyle homePageTextInsideButtonStyle() {
  return TextStyle(
    fontSize: 17.0,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'Montserrat',
  );
}

TextStyle textInsideButtonStyle() {
  return TextStyle(
    fontSize: 17.0,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: 'Montserrat',
  );
}

TextStyle viewPickedDateTextStyle() {
  return TextStyle(fontSize: 14.0, color: Colors.grey);
}

TextStyle viewOutputAlertDialogTextStyle() {
  return TextStyle(fontSize: 15.0, color: Colors.black);
}

TextStyle viewOutputAlertDialogButtonTextStyle() {
  return TextStyle(fontSize: 16.0, color: Colors.white);
}

TextStyle searchedDataOutputTextStyle() {
  return TextStyle(
      fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w600);
}

TextStyle outputListTileNameTextStyle() {
  return TextStyle(
      fontSize: 17.0, color: Colors.black, fontWeight: FontWeight.w900);
}

TextStyle outputListTileIMEITextStyle() {
  return TextStyle(fontSize: 14.0, color: Colors.black87);
}

TextStyle outputListTileDateTextStyle() {
  return TextStyle(
      fontSize: 13.0, color: Colors.black54, fontWeight: FontWeight.bold);
}

TextStyle settingHomeButtonTextStyle() {
  return TextStyle(
      fontSize: 17.0, color: Colors.black, fontWeight: FontWeight.w900);
}

TextStyle settingViewAccountTextStyle() {
  return TextStyle(
      fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.w600);
}

TextStyle settingDeleteAccountTextStyle() {
  return TextStyle(
      fontSize: 16.0, color: Colors.white70, fontWeight: FontWeight.w600);
}
