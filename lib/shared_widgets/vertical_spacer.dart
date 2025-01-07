import 'package:flutter/material.dart';

class VerticalSpacer extends StatelessWidget {
  final double size;

  const VerticalSpacer({Key? key, this.size = 16.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: size);
  }
}
