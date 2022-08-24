import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class icon_butoons extends StatefulWidget {
  const icon_butoons({Key? key}) : super(key: key);

  @override
  State<icon_butoons> createState() => _icon_butoonsState();
}

class _icon_butoonsState extends State<icon_butoons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity / 2,
      child: Column(
        children: [
          Column(
            children: [
              Row(),
              Row(),
            ],
          ),
          Text("Repeat"),
          Divider(),
          Row()
        ],
      ),
    );
  }
}
