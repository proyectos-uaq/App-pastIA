import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Widget adaptable para mostrar un logo circular con un icono
class Logo extends StatelessWidget {
  const Logo({
    super.key,
    required this.height,
    required this.width,
    required this.iconSize,
  });
  final double height;
  final double width;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          FontAwesomeIcons.pills,
          size: 60,
          color: Colors.blue.shade800,
        ),
      ),
    );
  }
}
