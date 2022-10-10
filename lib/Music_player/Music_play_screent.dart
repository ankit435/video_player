




import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/storage.dart';



import '../helper/file.dart';
import '../helper/files.dart';
import '../queue/queue_list_screen.dart';

class Music_play_screen extends StatefulWidget {
 static const routeName = '/Music_play_screen';

final String? m_id;
final String? p_id;
final String? m_path;
 Music_play_screen({Key? key, this.m_id, this.p_id, required this.m_path}) : super(key: key);

  @override
  State<Music_play_screen> createState() => _Music_play_screenState();
}

class _Music_play_screenState extends State<Music_play_screen> {
  @override

  final List<IconData> _icons = const [
   Icons.arrow_circle_right_sharp,
   Icons.repeat_one_sharp,
   Icons.shuffle,
   Icons.repeat_outlined,
  ];
  var queue;
  late Music music;
  void queue_list_video(BuildContext context) {
    // print(f_Id);
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: false,
      backgroundColor: Theme.of(context).backgroundColor,
      context: context,
      builder: (context) {
        return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: queue_list(
              queue_list_video: queue[3],
            ));
      },
    );
  }
Widget _appbar(){
  return AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              // leading: IconButton(
              //   onPressed: () => Navigator.pop(context),
              //   icon: icons(Icons.arrow_back),
              // ),
              
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: icons(Icons.equalizer),
                ),
                PopupMenuButton(
                     color: Theme.of(context).backgroundColor,
            icon: icons(Icons.more_vert),

                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child:  ListTile ( leading: icons(Icons.playlist_add), title: text('Add to playlist')),
                    ),
                    PopupMenuItem(
                      value: 2,
                        child:  ListTile ( leading: icons(Icons.queue_music_sharp), title: text('Add to queue')),
                    ),
                    PopupMenuItem(
                      value: 3,
                       child:  ListTile ( leading: icons(Icons.share), title: text('Share')),
                    ),
                    PopupMenuItem(
                      value: 4,
                       child:  ListTile ( leading: icons(Icons.delete), title: text('Delete')),
                    ),
                     PopupMenuItem(
                      value: 5,
                       child:  ListTile ( leading: icons(Icons.details), title: text('properties')),
                    ),
                    
                      
                  ],
                  elevation: 2
                  ,
                  onSelected: (value) {
                    switch (value) {
                      case 1:
                        break;
                      case 2:
                        break;
                      case 3:
                        break;
                      case 4:
                        break;
                      case 5:
                        break;
                    }
                  },
                )
                ],
  );
             
}
  Widget icons(IconData icon) {
    return Icon(
      icon,
      color: Theme.of(context).iconTheme.color,
    );
  }
 Widget text(String text,{TextStyle? style,double size=16,maxLines,Color? color,FontWeight? weight , TextAlign align= TextAlign.center,}) {
    return AutoSizeText(text,
    maxLines: maxLines,
    textAlign:align,
    overflow: TextOverflow.ellipsis,
    style: style?? TextStyle(
      color:color?? Theme.of(context).textTheme.bodyText1!.color,
      fontSize: size,
      fontWeight: weight,
    //  fontFamily: 'Roboto',
    ),);

  }

  Widget iconbutton(IconData? icon, Function? param1, {String? text =null}) {
    return SizedBox.fromSize(
      size: Size(56, 56), // button width and height
      child: ClipOval(
        child: Material(
          color: Colors.transparent, // button color
          child: InkWell(
            splashColor: Colors.green, // splash color
            onTap: () {
              param1!();
              
            }, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                text==null
                    ? icons(icon!)
                    : FittedBox(
                        child: Text(
                        "${text}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ))
                // text
              ],
            ),
          ),
        ),
      ),
    );
  }

 String getDuration(int value) {
    Duration duration = Duration(seconds: value.round());
    String time=   [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
    if(duration.inHours==0){
      return time;
    }
    return [duration.inHours, time].join(':');
  }



@override
  void initState() {
    // TODO: implement initState
     //Audio_player().initAudioPlayer();
    //  music = Provider.of<folder_details>(context, listen: false).getmusic(widget.m_id,widget.p_id);
     set_audio_path();
     super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    //Provider.of<folder_details>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDep
    // endencies

    // Provider.of<folder_details>(context, listen: false).dispose();
    super.didChangeDependencies();
  }

void set_audio_path(){
  Provider.of<Audio_player>(context, listen: false).set_audio_path( widget.m_path);
}



  Widget build(BuildContext context) {
     queue = Provider.of<queue_playerss>(context, listen: true).getqueuevideo();
   //  music = Provider.of<folder_details>(context, listen: true).getmusic(widget.m_id,widget.p_id);
   int postion=Provider.of<Audio_player>(context, listen: true).get_position();
      return Scaffold(
        body: Container( height: double.infinity,width: double.infinity, 
        decoration: const BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('assets/video/video-play-button.png'),
          fit: BoxFit.cover,
        ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: SafeArea( child:Padding(
            padding: const EdgeInsets.only(top: 13),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //SizedBox(height: 2,),
              _appbar(),
              Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage( "assets/video/video-play-button.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                 FittedBox (
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: icons(Icons.alarm),
                        ),
                        text(
                          Storage().get_file_title(widget.m_path??"No_music.Mp3"),
                          maxLines: 1,
                          size: 20,
                          weight: FontWeight.bold,
                      
                        ),
                        IconButton(onPressed: (){}, icon: icons(Icons.favorite_border))
                  
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  text(
                    "Artist Name",
                    maxLines: 1,
                    size: 20,
                    weight: FontWeight.bold,
                    
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      text(
                      getDuration(postion),
                        size: 15,
                          weight: FontWeight.bold,
                      ),
                     Expanded (
                        child: Slider(
                          value: postion.toDouble(),
                          onChanged: (value) {
                            Provider.of<Audio_player>(context, listen: false).seekToSecond(value.round());
                          },
                          min: 0,
                          max:Provider.of<Audio_player>(context, listen: false).get_duration().toDouble()+1.0 ,
                          activeColor: Colors.green,
                          inactiveColor: Colors.grey,
                        ),
                      ),
                      text(
                        getDuration(Provider.of<Audio_player>(context, listen: false).get_duration()-postion),
                       size: 15,
                          weight: FontWeight.bold,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                     iconbutton(_icons[2], (){}),
                    iconbutton(Icons.skip_previous, (){}),
                    
                      
                  Transform.scale (
                        scale: 1.5,
                        child:  iconbutton(Provider.of<Audio_player>(context, listen: true).get_is_playing()?Icons.pause_circle_outline_outlined :Icons.play_circle_outline_outlined, (){
                          Provider.of<Audio_player>(context, listen: false).play_pause();
                        
                        }),
                      ),
                   iconbutton(Icons.skip_next, (){
        
                   }),
                   iconbutton(Icons.menu,(){}),
                    ],
                  ),
                  SizedBox(
                height: 20,
              ),
                ],
              ),
             
              
        
        
        
            ],
        ),
          )),),),
      );

  }
}