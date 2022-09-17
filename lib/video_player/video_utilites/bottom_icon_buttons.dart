import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class icon_butoons extends StatefulWidget {
  const icon_butoons( {Key? key}) : super(key: key);

  @override
  State<icon_butoons> createState() => _icon_butoonsState();
}

class _icon_butoonsState extends State<icon_butoons> {

  Widget text(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Text(text,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color,fontWeight: FontWeight.bold
          )),
    );
  }

Widget iconbutton(IconData? icon, Function param1, {String text = ""}) {
    return SizedBox.fromSize(
      size: Size(65, 65), // button width and height
      child: ClipOval(
        child: Material(
          color: Colors.transparent, // button color
          child: InkWell(
            splashColor: Colors.green, // splash color
            onTap: () {
              param1();
              
            }, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              
                     Icon(
                        icon,
                        color: Theme.of(context).primaryIconTheme.color,
                      ),
                      SizedBox(height: 5,),
                    text.isNotEmpty? FittedBox(
                        child: Text(
                        "${text}",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color, fontWeight: FontWeight.bold),
                      )):Container()
                // text
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget row1(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        iconbutton(Icons.headphones,(){},text: "background_play"),
        iconbutton(Icons.branding_watermark_outlined,(){},text: "popup"),
        iconbutton(Icons.restore_page_sharp,(){},text: "AB Reapeat"),
        iconbutton(Icons.equalizer,(){},text: "Equalizer"),
      ],
    );
  }
  Widget row2(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        iconbutton(Icons.audiotrack,(){},text: "Audio"),
        iconbutton(Icons.subtitles,(){},text: "Subtitles"),
        iconbutton(Icons.delete,(){},text: "Delete"),
        iconbutton(Icons.devices_other,(){},text: "Other"),
      ],
    );
  }
  Widget row3(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        iconbutton(Icons.arrow_circle_right_sharp,(){},),
        iconbutton(Icons.repeat_one_sharp,(){},),
        iconbutton(Icons.shuffle,(){}),
        iconbutton(Icons.repeat_outlined,(){}),
      ],
    );
  }
  Widget row4(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        iconbutton(Icons.audiotrack,(){},text: "Audio"),
        iconbutton(Icons.subtitles,(){},text: "Subtitles"),
        iconbutton(Icons.delete,(){},text: "Delete"),
        iconbutton(Icons.devices_other,(){},text: "Other"),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [

        Column(
          children: [
            SizedBox(height: 20,),
            row1(),
            SizedBox(height: 20,),
            row2(),
          ],
        ),
        Divider(),
        text("Repeat"),
        row3(),
        Divider(),
        text("Decorder"),
        Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(onPressed: (){}, child: text("HW Decoder")),
            TextButton(onPressed: (){}, child: text("SW Decoder"))
          ],
        ),

        
        
       
      ],
    );
  }
}
