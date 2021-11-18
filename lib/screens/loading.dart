import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber[100],
      child: Center(
        child: SpinKitFoldingCube(
          color: Colors.green[200],
          size: 100,
        ),
      ),
    );
  }
}