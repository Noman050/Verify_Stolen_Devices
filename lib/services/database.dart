import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  FirebaseFirestore _user = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// TODO collection reference
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('SDRA_Users_Data');

  /// add user data
  Future<void> addUserData(
    String email,
    String pwd,
    String name,
    String phone,
    String cnic,
    String imageURL,
  ) async {
    return await usersCollection.doc(email).set({
      'Email': email,
      'Password': pwd,
      'Name': name,
      'Phone': phone,
      'CNIC': cnic,
      'Profile_Image': imageURL
    });
  }

  // // add reset password
  // Future<void> updateResetPwd(String pwd) async {
  //   return await usersCollection.doc(email).set({'Password': pwd});
  // }

  /// Fetch Mobile Record List
  fetchMobileData() {
    return _user
        .collection("SDRA_Users_Data")
        .doc(_auth.currentUser!.email)
        .collection("Mobile_Data")
        .orderBy("Time")
        .snapshots();
  }

  /// Fetch Lost Mobile Record List
  fetchLostMobileData() {
    return _user
        .collection("SDRA_Users_Data")
        .doc(_auth.currentUser!.email)
        .collection("Lost_Mobile_Data")
        .orderBy("Time")
        .snapshots();
  }

  /// Fetch Purchased Mobile Receipt
  fetchPurchasedMobileReceipt() {
    return _user
        .collection("SDRA_Users_Data")
        .doc(_auth.currentUser!.email)
        .collection("Purchased_Mobile_Receipts")
        .orderBy("Time")
        .snapshots();
  }

  /// Fetch Bike Record List
  fetchBikeData() {
    return _user
        .collection("SDRA_Users_Data")
        .doc(_auth.currentUser!.email)
        .collection("Bike_Data")
        .orderBy("Time")
        .snapshots();
  }

  /// Fetch Lost Bike Record List
  fetchLostBikeData() {
    return _user
        .collection("SDRA_Users_Data")
        .doc(_auth.currentUser!.email)
        .collection("Lost_Bike_Data")
        .orderBy("Time")
        .snapshots();
  }

  /// Fetch Purchased Bike Receipt
  fetchPurchasedBikeReceipt() {
    return _user
        .collection("SDRA_Users_Data")
        .doc(_auth.currentUser!.email)
        .collection("Purchased_Bike_Receipts")
        .orderBy("Time")
        .snapshots();
  }

  /// Fetch Car Record List
  fetchCarData() {
    return _user
        .collection("SDRA_Users_Data")
        .doc(_auth.currentUser!.email)
        .collection("Car_Data")
        .orderBy("Time")
        .snapshots();
  }

  /// Fetch Lost Car Record List
  fetchLostCarData() {
    return _user
        .collection("SDRA_Users_Data")
        .doc(_auth.currentUser!.email)
        .collection("Lost_Car_Data")
        .orderBy("Time")
        .snapshots();
  }

  /// Fetch Purchased Car Receipt
  fetchPurchasedCarReceipt() {
    return _user
        .collection("SDRA_Users_Data")
        .doc(_auth.currentUser!.email)
        .collection("Purchased_Car_Receipts")
        .orderBy("Time")
        .snapshots();
  }

  /// Upload user reset password
  uploadUserResetPassword(userMap) async {
    usersCollection
        .doc(_auth.currentUser!.email)
        .update(userMap)
        .catchError((e) => print(e.toString()));
  }

  /// Get user record using Password
  getUserByUserPassword(String currentPassword) {
    try {
      return usersCollection
          .where('Password', isEqualTo: currentPassword)
          .get();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// Get user record using Email
  getUserByUserEmail(String userEmail) {
    try {
      return usersCollection.where('Email', isEqualTo: userEmail).get();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
