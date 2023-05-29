import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:verify_devices/splashScreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        unselectedWidgetColor: Colors.black54,
        scaffoldBackgroundColor: Color(0xff334257),

        /// scaffoldBackgroundColor: Color(0xff0b0704),
        // scaffoldBackgroundColor: Color(0xff1F1F1F),
        // scaffoldBackgroundColor: Color(0xff80461b),
        primaryColor: Color(0xff145C9E),
      ).copyWith(),
      home: SplashScreen(),
    );
  }
}
