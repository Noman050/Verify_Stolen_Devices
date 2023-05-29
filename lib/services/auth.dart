import 'package:firebase_auth/firebase_auth.dart';

import '../model/user.dart';
import 'database.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  // Set userID to "UserOfFirebase" Class
  Usser? _userFromFirebase(User user) {
    // ignore: unnecessary_null_comparison
    return user != null ? Usser(uid: user.uid, email: user.email.toString()) : null;
    // return Usser(uid: user.uid);
  }

  // auth change user stream
  // Stream<Usser> get user {
  //   return _auth.authStateChanges().map(_userFromFirebase);
  //   // .map((User user) => _userFromFirebase(user));
  // }

  // TODO register with email and password
  Future<User?> registerWithEmailAndPassword(String email, String pwd,
      String name, String phone, String cnic, String imageURL) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: pwd);
      User? user = credential.user;
      // create a new document for the user with the uid
      await DatabaseService()
          .addUserData(email, pwd, name, phone, cnic, imageURL);
      // print(user.uid);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // TODO sign in with email and password
  Future signInWithEmailAndPassword(String email, String pwd) async {
    try {
      UserCredential credential =
          await _auth.signInWithEmailAndPassword(email: email, password: pwd);
      User? user = credential.user;
      if (user!.emailVerified) {
        return _userFromFirebase(user);
      } else {
        print("Verify your Email First!");
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// TODO Returns true if email address is in use.
  // Future<bool> checkIfEmailInUse(String emailAddress) async {
  //   try {
  //     final list = await _auth.fetchSignInMethodsForEmail(emailAddress);
  //     if (list.isNotEmpty) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (error) {
  //     return true;
  //   }
  // }

  /// TODO update current password
  Future<void> updatePassword(String newPwd) async {
    User user = _auth.currentUser!;
    user.updatePassword(newPwd);
  }

  // TODO reset password
  Future resetForgotPassword(String email) async {
    return await _auth.sendPasswordResetEmail(email: email);
  }

  // TODO sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
