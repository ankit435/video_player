

import 'package:flutter/material.dart';


class iconsbutton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final Widget? child;
  final IconData? icon;
  final Color? icon_colors;

  const iconsbutton({
    Key? key,
    this.onPressed,
    this.text,
    this.child,
    this.icon,
    this.icon_colors
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return SizedBox.fromSize(
      size: Size(56, 56), // button width and height
      child: ClipOval(
        child: Material(
          color: Colors.transparent, // button color
          child: InkWell(
            splashColor: Colors.green, // splash color
            onTap: () {
              onPressed;
            }, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon,color:Theme.of(context).primaryIconTheme.color,), // icon
                // text
              ],
            ),
          ),
        ),
      ),
    );
  }
}