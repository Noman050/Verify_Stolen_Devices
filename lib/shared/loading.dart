import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff334257),
      // color: Color(0xffFdfcfa),
      // color: Color(0xff0b0704),
      child: Center(
        child: SpinKitWave(
          color: Color(0xffFFC069),
          size: 40.0,
        ),
      ),
    );
  }
}
