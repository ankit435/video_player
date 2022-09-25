import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class playback_slider extends StatefulWidget {
  void Function(double value) updateslider;
  double speed;
   playback_slider({Key? key, required this.updateslider, required this.speed }) : super(key: key);

  @override
  State<playback_slider> createState() => _playback_sliderState();
}

class _playback_sliderState extends State<playback_slider> {
  @override
 Widget text(String text,{TextStyle? style,double size=16,maxLines,Color? color,FontWeight? weight , TextAlign align= TextAlign.center,}) {
    return Text(text,
    maxLines: maxLines,
    textAlign:align,
    style: style?? TextStyle(
      color:color?? Theme.of(context).textTheme.bodyText1!.color,
      fontSize: size,
      fontWeight: weight,
    //  fontFamily: 'Roboto',
    ),);

  }
  Widget iconbutton(double spe) {
    return SizedBox.fromSize(
      size: Size(56, 56), // button width and height
      child: ClipOval(
        child: Material(
          color: widget.speed==spe?Colors.green: Colors.transparent, // button color
          child: InkWell(
            splashColor: Colors.green, // splash color
            onTap: () {
                widget.updateslider(spe);
                Navigator.of(context).pop();
             
            }, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                text("${spe}X")
                // text
              ],
            ),
          ),
        ),
      ),
    );
  }
double dp(double val, int places){ 
   num mod = pow(10.0, places); 
   return ((val * mod).round().toDouble() / mod); 
}
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Align(
              alignment: Alignment.center,
              child: text(widget.speed.toStringAsFixed(2) + " X"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: Row(
              children: [
                Text("0.25",style: TextStyle(color: Theme.of(context).sliderTheme.activeTrackColor,),),
                Expanded(
                  child: Slider(
                    min: 0.25,
                    max: 4.0,
                    value: widget.speed,
                    onChanged: (value) {
                     
                     setState(() {
                       widget.speed=dp(value, 2);
                     });
                      widget.updateslider(widget.speed);
                    
                    },
                  ),
                ),
                Text("4.0",style: TextStyle(color: Theme.of(context).sliderTheme.activeTrackColor,)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      iconbutton(0.25),
                      iconbutton(0.5),
                      iconbutton(
                        1,
                      ),
                      iconbutton(1.25),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      iconbutton(1.5),
                      iconbutton(2),
                      iconbutton(3),
                      iconbutton(4),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
