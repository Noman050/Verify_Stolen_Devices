class Usser {
  final String uid;
  final String email;
  Usser({required this.uid,required this.email});
}

/// purpose of above class is actually
/// to turn Firebase_User_Obj into a
/// User_Obj based on this class
/// so we turn FirebaseUser's obj--> "user" and "email"
/// into our CustomUser's obj--> "uid" and "email"

// ======================== //
// User data model
// class UserData {
//   final String name;
//   final String email;
//   final String phone;
//   final String cnic;
//   UserData({this.name, this.email, this.phone, this.cnic});
// }
