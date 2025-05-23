import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class MyCustomLoader extends StatelessWidget {
  const MyCustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 80,
        width: 80,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: LoadingIndicator(
            indicatorType: Indicator.lineScale,
            colors: const [
              Color(0xFF90CAF9),
              Color(0xFF42A5F5),
              Color(0xFF2196F3),
              Color(0xFF1E88E5),
              Color(0xFF1976D2),
              Color(0xFF1565C0),
            ],
            strokeWidth: 8,
            backgroundColor: Colors.white,
            pathBackgroundColor: Colors.black12,
          ),
        ),
      ),
    );
  }
}

class ButtonProgressIndicator extends StatelessWidget {
  const ButtonProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      strokeWidth: 2,
    );
  }
}
