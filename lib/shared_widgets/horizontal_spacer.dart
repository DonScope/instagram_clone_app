import 'package:flutter/material.dart';

class HorizontalSpacer extends StatelessWidget {
  final double size;

  const HorizontalSpacer({Key? key, this.size = 16.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size);
  }
}
