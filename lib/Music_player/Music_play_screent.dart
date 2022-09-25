




import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/files.dart';
import '../queue/queue_list_screen.dart';

class Music_play_screen extends StatefulWidget {
 static const routeName = '/Music_play_screen';


  const Music_play_screen({Key? key}) : super(key: key);

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
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: icons(Icons.arrow_back),
              ),
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

  Widget build(BuildContext context) {
     queue = Provider.of<queue_playerss>(context, listen: true).getqueuevideo();
      return Scaffold(
        body: Container( height: double.infinity,width: double.infinity, 
        decoration: BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('assets/video/video-play-button.png'),
          fit: BoxFit.cover,
        ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: SafeArea( child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: icons(Icons.alarm),
                    ),
                    text(
                      "Song Name",
                      maxLines: 1,
                      
                     size: 20,
                    weight: FontWeight.bold,
                  
                    ),
                    IconButton(onPressed: (){}, icon: icons(Icons.favorite_border))

                  ],
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
                      "0:00",
                      size: 15,
                        weight: FontWeight.bold,
                    ),
                   Expanded (
                      child: Slider(
                        value: 0,
                        onChanged: (value) {},
                        min: 0,
                        max: 100,
                        activeColor: Colors.green,
                        inactiveColor: Colors.grey,
                      ),
                    ),
                    text(
                      "0:00",
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
                    IconButton(
                      onPressed: () {},
                      icon: icons(_icons[2]),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: icons(Icons.skip_previous),
                    ),
                    Transform.scale (
                      scale: 1.5,
                      child: IconButton(
                        onPressed: () {},
                        icon: icons(Icons.play_circle_outline_outlined),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: icons(Icons.skip_next),
                    ),
                    IconButton(
                      onPressed: () { queue_list_video(context);},
                      icon: icons(Icons.menu),
                    ),
                  ],
                ),
                SizedBox(
              height: 20,
            ),
              ],
            ),
           
      



          ],
        )),),),
      );

  }
}