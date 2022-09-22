import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/Playlist/video_song_screen/video_and_song_screent.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/storage.dart';

import '../Videos/video.dart';
import '../helper/files.dart';

class Skip_time extends StatefulWidget {

        Skip_time(
      {Key? key,}
      )
      : super(key: key);
  @override
  State<Skip_time> createState() => _Skip_timeState();
}

class _Skip_timeState extends State<Skip_time> {
  final List<int>_skip_time=[0,5,10,15,20,25,30,35,40,45,50,55,60];
  Widget text(String text){
  return Text(text , style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ));
    }
  
  late int _currentIndex=0;

  @override
  void initState() {
    int t=Provider.of<Setting_data>(context,listen: false).get_skip_time();
    
    _currentIndex=_skip_time.indexWhere((element) => element==t);
  
    super.initState();
  }

  Widget build(BuildContext context) {
    return GestureDetector (
      onTap: (){
        Navigator.of(context).pop();
      
      },
      child: Scaffold(
        
          backgroundColor: Colors.transparent,
          body: AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            insetPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            scrollable: true,
            title: ListTile(title: text("Skip Time"),subtitle: text("${Provider.of<Setting_data>(context,listen: true).get_skip_time()} sec  "),),
            
            content: SizedBox(
             
              width: double.minPositive,
                    height: 300,
             child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _skip_time.length,
                      itemBuilder: (BuildContext context, int index) {
                        return RadioListTile(
                          activeColor: Theme.of(context).textTheme.bodyText1!.color,
                          value: index,
                          groupValue:_currentIndex,
                          title: text(" ${_skip_time[index]}Sec"),
                          onChanged: ( value) {
                            setState(() {
                              _currentIndex = value as int;
                               Provider.of<Setting_data>(context,listen: false).set_skip_time(_skip_time[_currentIndex]);
                             
                            });
                          },
                        );
                      },
                    ),
            ),
           
          )),
    );
  }
}
