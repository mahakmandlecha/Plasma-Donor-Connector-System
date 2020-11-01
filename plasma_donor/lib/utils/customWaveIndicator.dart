import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WaveIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SpinKitWave(
          color: Colors.amberAccent[700], type: SpinKitWaveType.start),
    ));
  }
}
