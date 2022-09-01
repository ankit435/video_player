

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Colour_picker_bottomsheet extends StatefulWidget {
  final text;
  const Colour_picker_bottomsheet({Key? key,required this.text}) : super(key: key);

  @override
  State<Colour_picker_bottomsheet> createState() => _Colour_picker_bottomsheetState();
}

class _Colour_picker_bottomsheetState extends State<Colour_picker_bottomsheet> {
  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: MediaQuery.of(context).size.height*0.5,
      color: Colors.transparent,
      child: Center(child: Text(widget.text)),
    
    );
  }
}