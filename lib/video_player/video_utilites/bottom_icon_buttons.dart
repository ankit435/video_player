import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class icon_butoons extends StatefulWidget {
   final int repeat_mode;
   void Function({int? val}) repeat_mode_update;
   final  int decoder;
void Function({int? val}) Hw_sw_decoders;
void Function(int val) icon_button_press;
   icon_butoons( {Key? key, required this.repeat_mode, required this.repeat_mode_update, required this.decoder, required this. Hw_sw_decoders, required this.icon_button_press }) : super(key: key);

  @override
  State<icon_butoons> createState() => _icon_butoonsState();
}

class _icon_butoonsState extends State<icon_butoons> {

  Widget text(String text,{int? colors=null}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Text(text,
          style: TextStyle(
            color: colors==null?Theme.of(context).textTheme.bodyText1!.color :widget.decoder!=colors? Theme.of(context).textTheme.bodyText1!.color :Colors.red,fontWeight: FontWeight.bold
          )),
    );
  }

Widget iconbutton(IconData? icon, Function param1, {String text = "",int? light=null}) {
   //print("repeat_mode=== "+widget. repeat_mode.toString()+"  light== "+light.toString());
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
                        color:light==null? Theme.of(context).primaryIconTheme.color:widget.repeat_mode!=light?Theme.of(context).primaryIconTheme.color:Colors.red
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
        iconbutton(Icons.headphones,(){widget.icon_button_press(1);},text: "background_play"),
        iconbutton(Icons.branding_watermark_outlined,(){widget.icon_button_press(2);},text: "popup"),
        iconbutton(Icons.restore_page_sharp,(){widget.icon_button_press(3);},text: "AB Reapeat"),
        iconbutton(Icons.equalizer,(){widget.icon_button_press(4);},text: "Equalizer"),
      ],
    );
  }
  Widget row2(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        iconbutton(Icons.audiotrack,(){widget.icon_button_press(5);},text: "Audio"),
        iconbutton(Icons.subtitles,(){ Navigator.pop(context); widget.icon_button_press(6);},text: "Subtitles"),
        iconbutton(Icons.delete,(){widget.icon_button_press(7);},text: "Delete"),
        iconbutton(Icons.devices_other,(){widget.icon_button_press(8);},text: "Other"),
      ],
    );
  }
  Widget row3(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        iconbutton(Icons.arrow_circle_right_sharp,(){
          setState(() {
             widget.repeat_mode_update(val: 1);
          });
         
          
          },light: 1 ),
        iconbutton(Icons.repeat_one_sharp,(){setState(() {
             widget.repeat_mode_update(val: 2);
          });},light: 2),
        iconbutton(Icons.shuffle,(){setState(() {
             widget.repeat_mode_update(val: 3);
          });},light: 3),
        iconbutton(Icons.repeat_outlined,(){setState(() {
             widget.repeat_mode_update(val: 4);
          });},light: 4),
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
    // print("decoder=="+ widget.decoder.toString());
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
            TextButton(onPressed: (){
              setState(() {
                widget.Hw_sw_decoders(val: 1);
              });

            }, child: text("HW Decoder",colors: 1)),
            TextButton(onPressed: (){

                setState(() {
                  widget.Hw_sw_decoders(val: 2);
                });

            }, child: text("SW Decoder",colors:2))
          ],
        ),

        
        
       
      ],
    );
  }
}
