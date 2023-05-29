import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../../../services/auth.dart';
import '../../../services/database.dart';
import '../../../shared/widgets.dart';
import '../settingHomePage.dart';

class PasswordReset extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController userEmailController = new TextEditingController();
  TextEditingController currentPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController userConformPwdController = new TextEditingController();
  bool _isObscure = true;

  /// Search User Data from Firebase
  void resetPassword(String currentPassword, String newPassword) async {
    ///
    if (formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      AuthCredential credential = EmailAuthProvider.credential(
          email: user!.email.toString(), password: currentPassword);
      await user.reauthenticateWithCredential(credential).then((value) async {
        await AuthService().updatePassword(newPassword).then((value) async {
          QuerySnapshot snapshot = await DatabaseService()
              .getUserByUserPassword(currentPasswordController.text);
          if (snapshot != null) {
            Map<String, dynamic> userPassword = ({
              "Password": newPassword,
            });
            await DatabaseService().uploadUserResetPassword(userPassword);

            /// On Complete
            showToaster("Password reset successfully");
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SettingsHomePage()));
          }
        });
      }).catchError((onError) => showToaster("Credentials Error"));
    } else {
      showToaster("Something went wrong!");
    }
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
                    child: Icon(Icons.password_outlined, size: 50.0),
                  ),
                ),
              ),

              /// Text
              Padding(
                padding: EdgeInsets.only(top: 100.0, left: 30.0),
                child: Text(
                  "Hi !\nReset Your Password.",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              /// View Password
              Padding(
                padding: EdgeInsets.only(top: 160.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // ignore: deprecated_member_use
                    IconButton(
                      onPressed: () => setState(() => _isObscure = !_isObscure),
                      color: Colors.yellow,
                      iconSize: 30.0,
                      icon: Icon(
                        _isObscure
                            ? Icons.visibility
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ],
                ),
              ),

              /// Forms
              Padding(
                padding: EdgeInsets.only(top: 200.0, left: 20.0, right: 20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      /// Email
                      TextFormField(
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration(
                          'EMAIL',
                          Icon(Icons.email_outlined, color: fieldIconColor),
                        ),
                        controller: userEmailController,
                        validator: (val) {
                          return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                          ).hasMatch(val!)
                              ? null
                              : "Valid email required";
                        },
                      ),
                      SizedBox(height: 20.0),

                      /// Current Password
                      TextFormField(
                        style: simpleTextStyle(),
                        obscureText: _isObscure,
                        decoration: textFieldInputDecoration(
                          "CURRENT PASSWORD",
                          Icon(Icons.vpn_key, color: fieldIconColor),
                        ),
                        controller: currentPasswordController,
                        validator: (val) {
                          return val!.isEmpty || val.length < 6
                              ? 'Minimum 6 characters required'
                              : null;
                        },
                      ),
                      SizedBox(height: 20.0),

                      /// New Password
                      TextFormField(
                        style: simpleTextStyle(),
                        obscureText: _isObscure,
                        decoration: textFieldInputDecoration(
                          "NEW PASSWORD",
                          Icon(Icons.vpn_key_outlined, color: fieldIconColor),
                        ),
                        controller: newPasswordController,
                        validator: (val) {
                          return val!.isEmpty || val.length < 6
                              ? 'Minimum 6 characters required'
                              : null;
                        },
                      ),
                      SizedBox(height: 20.0),

                      /// Conform Password
                      TextFormField(
                        style: simpleTextStyle(),
                        obscureText: _isObscure,
                        decoration: textFieldInputDecoration(
                          "CONFORM PASSWORD",
                          Icon(Icons.vpn_key_outlined, color: fieldIconColor),
                        ),
                        controller: userConformPwdController,
                        validator: (val) {
                          return val == newPasswordController.text
                              ? null
                              : 'Password did\'nt matched';
                        },
                      ),
                      SizedBox(height: 30.0),

                      /// Button
                      Center(
                        // ignore: deprecated_member_use
                        child: TextButton(
                         
                          onPressed: () => resetPassword(
                              currentPasswordController.text,
                              newPasswordController.text),
                          child: Text("Reset Password",
                              style: viewOutputAlertDialogButtonTextStyle()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
