import 'package:flutter/material.dart';

class CustomCenter extends StatelessWidget {
  final Widget child;
  final double extraValue;

  const CustomCenter({Key key, @required this.child, this.extraValue = 0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height -
          AppBar().preferredSize.height -
          kToolbarHeight - extraValue),
      child: Center(child: child),
    );
  }
}
