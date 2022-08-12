import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:video/search/search.dart';
import 'package:video_player/video_player.dart';

import '../cliper/left_border_cliper.dart';
import '../cliper/right_border_cliper.dart';
import '../helper/file.dart';
import '../helper/files.dart';

class Play_video extends StatefulWidget {
  final List<video> file;
  final int index;

  Play_video({Key? key, required this.file, required this.index})
      : super(key: key);
  static const routeName = '/video_played';

  @override
  State<Play_video> createState() => _Play_videoState();
}

class _Play_videoState extends State<Play_video> {
  @override
  bool show = false;
  int currentDurationInSecond = 0;
  VideoPlayerController? _controller;
  var f;
  late int index;
  bool left = false;
  bool background_play = false;
  bool lock = false;

  void _load_video(String v_videoPath) {
    f = File(v_videoPath);
    _controller = VideoPlayerController.file(f!)
      ..initialize().then((_) {
        setState(() {
          if (widget.file[index].v_open == false &&
              widget.file[index].v_duration == -1) {
            Provider.of<folder_details>(context, listen: false).Setduration(
                _controller!.value.duration.inSeconds,
                widget.file[index].v_id,
                widget.file[index].parent_folder_id);
          }
          Provider.of<folder_details>(context, listen: false).updatevideoopen(
              widget.file[index].v_id, widget.file[index].parent_folder_id);
        });
      });
    // _controller!.addListener(
    //   () => setState(() => currentDurationInSecond = _controller!.value.position.inSeconds),
    // );
    _controller!.play();
  }

  Future<void> _onControllerChange(String link) async {
    if (_controller == null) {
      _load_video(link);
    } else {
      final oldController = _controller;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await oldController!.dispose();
        _load_video(link);
      });
      // setState(() {
      //   _controller = null;
      // });
    }
  }

  void initState() {
    setState(() {
      //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
      index = widget.index;
    });
    defaultsorenatation();
    _onControllerChange(widget.file[index].v_videoPath);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Provider.of<folder_details>(context, listen: false).SetWatchedduration(
        currentDurationInSecond,
        widget.file[index].v_id,
        widget.file[index].parent_folder_id);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // if(!background_play)
    defaultsorenatation();
    _controller!.dispose();
  }

  @override
  Widget video_played() {
    return Center(
      child: _controller!.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: GestureDetector(
                child: VideoPlayer(_controller!),
                onTap: () {
                  // setState(() {
                  //   show = !show;
                  // });
                },
              ))
          : Container(),
    );
  }

  void _bottoplaylist(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            //contdition to be ture for one video
            child: Container(
              height: 300,
            ));
      },
    );
  }

  void defaultsorenatation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void specificorenation(bool orientation) {
    orientation
        ? SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ])
        : SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
  }

  Widget iconbutton(IconData icon, Function param1) {
    return SizedBox.fromSize(
      size: Size(56, 56), // button width and height
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
                Icon(icon), // icon
                // text
              ],
            ),
          ),
        ),
      ),
    );
  }

  void play_next() {
    setState(() {
      index++;
    });
    _onControllerChange(widget.file[index].v_videoPath);
  }

  void play_prv() {
    setState(() {
      index--;
    });
    _onControllerChange(widget.file[index].v_videoPath);
  }

  List<Widget> Bottom_button() {
    return [
      iconbutton(lock ? Icons.lock : Icons.lock_open, () {
        if (!lock) {
          setState(() {
            specificorenation(
                MediaQuery.of(context).orientation == Orientation.portrait);
            lock = !lock;
          });
        } else {
          setState(() {
            defaultsorenatation();
            lock = !lock;
          });
        }
      }),
      iconbutton(Icons.arrow_left, index - 1 < 0 ? () {} : play_prv),
      iconbutton(_controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
          () {
        setState(() {
          if (_controller!.value.isPlaying) {
            _controller!.pause();
          } else {
            _controller!.play();
          }
        });
      }),
      iconbutton(Icons.arrow_right,
          index + 1 >= widget.file.length ? () {} : play_next),
      iconbutton(Icons.fullscreen, () {}),
    ];
  }

  List<Widget> fixed_button() {
    return [
      iconbutton( Icons.screen_rotation_outlined,
          () {
        specificorenation(
            !(MediaQuery.of(context).orientation == Orientation.portrait));
      }),
      SizedBox(
        width: 10,
      ),
      iconbutton(
          _controller!.value.volume == 1.0 ? Icons.volume_up : Icons.volume_off,
          () {
        setState(() {
          if (_controller!.value.volume == 1.0) {
            _controller!.setVolume(0.0);
          } else {
            _controller!.setVolume(1.0);
          }
        });
      }),
      SizedBox(
        width: 10,
      ),
      iconbutton(Icons.headphones, () {
        setState(() {
          background_play = true;
        });
        Navigator.of(context).pop();
      }),
      SizedBox(
        width: 10,
      ),
      iconbutton(Icons.speed, () {}),
      SizedBox(
        width: 10,
      ),
    ];
  }

  List<Widget> variable_button() {
    return [
      iconbutton(Icons.brightness_1, () {}),
      SizedBox(
        width: 10,
      ),
      iconbutton(Icons.lock_clock,() {}),
      SizedBox(
        width: 10,
      ),
    ];
  }

  List<Widget> action() {
    return [

       IconButton(
          onPressed: () {
            _bottoplaylist(context);
          },
          icon: Icon(Icons.closed_caption_outlined)),
      IconButton(
          onPressed: () {
            _bottoplaylist(context);
          },
          icon: Icon(Icons.playlist_add_check_circle)),
      IconButton(
          onPressed: () {
            _bottoplaylist(context);
          },
          icon: Icon(Icons.more_vert)),
    ];
  }

  List<Widget> topbaar() {
    return [
      AppBar(
        title: AutoSizeText(widget.file[index].v_title,
            maxLines: 2,
            minFontSize: 17,
            maxFontSize: 18,
            overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: action(),
      ),
      Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: fixed_button(),
              ),
              left
                  ? SizedBox(
                      child: Row(
                        children: variable_button(),
                      ),
                    )
                  : SizedBox(),
              iconbutton(left ? Icons.arrow_left : Icons.arrow_right, () {
                setState(() {
                  left = !left;
                });
              })
            ],
          ),
        ),
      )
    ];
  }

  List<Widget> bottobar() {
    return [
      _controller!.value.isPlaying
          ? VideoProgressIndicator(
              _controller!,
              allowScrubbing: true,
              colors: VideoProgressColors(
                  //playedColor: Theme.of(context).primaryColor),
                  playedColor: Colors.blue),
              padding: EdgeInsets.all(10),
            )
          : Container(),
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: Bottom_button(),
        ),
      ),
    ];
  }

void fastforward(){
         Duration currentPosition = _controller!.value.position;
          Duration targetPosition = currentPosition + const Duration(seconds: 10);
          _controller!.seekTo(targetPosition);
}

void backward(){
          Duration currentPosition = _controller!.value.position;
          Duration targetPosition = currentPosition - const Duration(seconds: 10);
          _controller!.seekTo(targetPosition);
}

void show_content(){
  setState(() {
                      show = !show;
                    });
}

  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          video_played(),
          !lock
              ? GestureDetector(
                
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.transparent,
                  ),
                  onTap: () {
                    show_content();
                  },
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          iconbutton(Icons.lock, () {
                            setState(() {
                              defaultsorenatation();
                              lock = !lock;
                            });
                          }),
                          iconbutton(Icons.lock, () {
                            setState(() {
                              defaultsorenatation();
                              lock = !lock;
                            });
                          })
                        ],
                      ),
                    )
                  ],
                ),
         GestureDetector (
          onHorizontalDragEnd:(details) => fastforward() ,
          onTap: show_content,
          onDoubleTap: (){
           
            fastforward();
          },
            child: ClipPath(
              clipper: OvalLeftBorderClipper(curveHeight: MediaQuery.of(context).size.width),
              child: Container(color: Colors.transparent,height:double.infinity,width:double.infinity) ,),
          ),
          GestureDetector(

               onTap: show_content,
               onDoubleTap: (){
                 print("left");
                 backward();
               },
            child: ClipPath(
              clipper: OvalRightBorderClipper(curveHeight: MediaQuery.of(context).size.height),
              child: Container(color: Colors.transparent,height:double.infinity,width:double.infinity) ,),
          ),


          show && !lock
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: topbaar(),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: bottobar(),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}

class customclippath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    double w = size.width;
    double h = size.height;

    final path = Path();

    path.lineTo(0, h);
    path.quadraticBezierTo(w * 0.5, h - 100, w, h);
    path.lineTo(w, 0);
    path.close();
    throw UnimplementedError();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    throw UnimplementedError();
  }
}
