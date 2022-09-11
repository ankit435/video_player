import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:video/helper/theme_model.dart';
import 'package:video/video_player/video_utilites/slider.dart';
import 'package:video/video_player/video_utilites/video_player_bottomsheet.dart';

import 'package:video_player/video_player.dart';

import '../cliper/left_border_cliper.dart';
import '../cliper/right_border_cliper.dart';
import '../helper/file.dart';
import '../helper/files.dart';

class Play_video extends StatefulWidget {

  const Play_video({Key? key}) : super(key: key);
  static const routeName = '/video_played';

  @override
  State<Play_video> createState() => _Play_videoState();
}

class _Play_videoState extends State<Play_video> {
  @override
  bool show = true;
  late int currentDuration;
  
  late double volume;

  VideoPlayerController? _controller;
  var f;
  bool mounted = true;

  bool left = false;
  bool background_play = false;
  bool lock = false;
  int newCurrentPosition = 0;
  var queue_player;
  double speed = 1.0;
    late Timer _timer;
  int _start = 3;
  String? f_id, p_id;


  //Future<void>screen_display;

  void _load_video(video v) {
    if (mounted) {
      f = File(v.v_videoPath);
      _controller = VideoPlayerController.file(f!)
        ..initialize().then((_) {
          setState(() {
            if (v.v_open == false && v.v_duration == -1) {
              Provider.of<folder_details>(context, listen: false).Setduration(
                  _controller!.value.duration.inMilliseconds,
                  v.v_id,
                  v.parent_folder_id);
            }
            Provider.of<folder_details>(context, listen: false)
                .updatevideoopen(v.v_id, v.parent_folder_id);
            updateseeker(v.v_watched.toDouble());
          });
        });
      _controller!.addListener(() {
        setlistenerseeker();
      });

      _controller!.play();
    }
  }


void setfolderplylist(){
  
  f_id= Provider.of<queue_playerss>(context, listen: false).getf_id();
  p_id= Provider.of<queue_playerss>(context, listen: false).getp_id();

  
}
  Future<void> _onControllerChange(video link) async {
    if (mounted) {
      if (_controller == null) {
        _load_video(link);
      } else {
        final oldController = _controller;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await oldController!.dispose();
          _load_video(link);
        });
      }
    }
  }

  void initState() {
    // setState(() {
    //   //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    //   index = widget.index;
    // });
startTimer();
    defaultsorenatation();
    if (mounted) {
      setfolderplylist();
      video v = getvideo();
      _onControllerChange(v);
      _controller!.addListener(() {
        setlistenerseeker();
      });
      // _controller!.addListener(() {
      //   volume_listener();
      // });
    }
    super.initState();
  }


  void setlistenerseeker() {
    if (mounted) {
      setState(() {
        currentDuration = _controller!.value.position.inMilliseconds;
      });
    }
  }

  void updateslider(double value) {
    setState(() {
      speed = value;
      _controller!.setPlaybackSpeed(speed);
    });
  }

  // void volume_listener(){

  //   if(mounted){
  //     setState(() {
  //       volume=_controller!.value.
  //     });
  //   }

  // }

  void updateseeker(double value) {
    _controller!.seekTo(Duration(milliseconds: value.round()));
  }

  video getvideo() {

    video v= Provider.of<queue_playerss>(context, listen: false).getvideo_by_id();
    
    Provider.of<recent_videos>(context, listen: false).add_to_recent(v) ;

    return v;
  }

  void update_curent_watch_time() {
    video v = getvideo();
    Provider.of<folder_details>(context, listen: false)
        .SetWatchedduration(currentDuration, v.v_id, v.parent_folder_id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }


void exitfullscreen(){
 SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}
  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
        exitfullscreen();

    mounted = false;

   
    defaultsorenatation();

    if (_controller!.value.isPlaying || _controller != null) {
      _controller!.pause();
      _controller!.removeListener(() {
        setlistenerseeker();
      });
    }
    // update_curent_watch_time();

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

  void _bottofolder_queue_list(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      backgroundColor: Theme.of(context).backgroundColor,
      builder: (context) {
        return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            //contdition to be ture for one video
            child: video_bottom_sheet(
                playfolder_video: playfolder_video, f_id:f_id, p_id: p_id));
      },
    );
  }

  void _bottombutton(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      backgroundColor: Theme.of(context).backgroundColor,
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

  void playfolder_video(int index) {
    update_curent_watch_time();
    if (Provider.of<queue_playerss>(context, listen: false)
        .set_current_index(index)) {
      _onControllerChange(getvideo());
    } else {
      print("somthing went wrong");
    }
  }

  void icon_button_press(int val) {}

  void _bottoslider(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      backgroundColor: Theme.of(context).backgroundColor,
      builder: (context) {
        return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            //contdition to be ture for one video
            child: playback_slider(updateslider: updateslider, speed: speed));
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

  Widget iconbutton(IconData? icon, Function param1, {String text = ""}) {
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
                text.isEmpty
                    ? Icon(
                        icon,
                        color: Theme.of(context).primaryIconTheme.color,
                      )
                    : FittedBox(
                        child: Text(
                        "${text}X",
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

  bool play_next() {
    update_curent_watch_time();
    bool cond =
        Provider.of<queue_playerss>(context, listen: false).getskipnextvideo();
    return cond;
  }

  bool play_prv() {
    update_curent_watch_time();
    return Provider.of<queue_playerss>(context, listen: false)
        .getskipprevvideo();
  }

  String getcurr_video() {
    return Provider.of<queue_playerss>(context, listen: false)
        .getcurrentvideo();
  }

  int getcurrent_index() {
    return Provider.of<queue_playerss>(context, listen: false)
        .getcurrent_index();
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
      iconbutton(Icons.skip_previous, () {
        play_prv() ? _onControllerChange(getvideo()) : null;
      }),
      iconbutton(_controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
          () {
        setState(() {
          update_curent_watch_time();
          if (_controller!.value.isPlaying) {
            _controller!.pause();
          } else {
            _controller!.play();
          }
        });
      }),
      iconbutton(Icons.skip_next, () {
        play_next() ? _onControllerChange(getvideo()) : null;
      }),
      iconbutton(Icons.fullscreen, () {
          !show? SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky):exitfullscreen();
      }),
    ];
  }

  List<Widget> fixed_button() {
    return [
      iconbutton(Icons.screen_rotation_outlined, () {
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
        Provider.of<queue_playerss>(context, listen: false)
            .togle_bacground_play();
        Provider.of<queue_playerss>(context, listen: false)
            .setvideo_controler(_controller!);
        Navigator.of(context).pop();
        if (_controller!.value.isPlaying) {
          _controller!.pause();
        }
        //  dispose();
      }),
      SizedBox(
        width: 10,
      ),
      iconbutton(Icons.speed, () {
        _bottoslider(context);
      }, text: speed.toString()),
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
      iconbutton(Icons.lock_clock, () {}),
      SizedBox(
        width: 10,
      ),
    ];
  }

  List<Widget> action() {
    return [
      IconButton(
          onPressed: () {
            _bottombutton(context);
          },
          icon: Icon(Icons.closed_caption_outlined)),

      if(p_id!=null||f_id!=null)    
      IconButton(
        onPressed: () {
          _bottofolder_queue_list(context);
        },
        icon: Icon(Icons.playlist_play),
      ),
      IconButton(
          onPressed: () {
            _bottombutton(context);
          },
          icon: Icon(Icons.more_vert)),
    ];
  }

  List<Widget> topbaar() {
    return [
      AppBar(
        //  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: AutoSizeText(
          Provider.of<queue_playerss>(context, listen: false).video_title(),
          maxLines: 2,
          minFontSize: 17,
          maxFontSize: 18,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).primaryIconTheme.color,
          ),
        ),
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

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {

         if(show&&_controller!.value.isPlaying){
           
          if (_start < 1) {
            setState(() {
              show = false;
              _start=3;
            });
            timer.cancel();
          } else {
            _start = _start - 1;
          }
         }
        },
        
      ),
    );
  }


  List<Widget> bottobar() {
    return [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(getDuration(currentDuration.toDouble()),
                  style: TextStyle(
                      color: Theme.of(context).sliderTheme.activeTrackColor,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500)),
              Expanded(
                child: Slider(
                  // inactiveColor: Colors.blue,
                  // activeColor: Colors.red,
                  min: 0.0,
                  max: _controller!.value.duration.inMilliseconds.toDouble(),
                  value: currentDuration.toDouble(),
                  onChanged: (value) {
                    updateseeker(value);
                  },
                ),
              ),
              Text(
                  getDuration(
                      _controller!.value.duration.inMilliseconds.toDouble() -
                          currentDuration.toDouble()),
                  style: TextStyle(
                      color: Theme.of(context).sliderTheme.inactiveTrackColor,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: Bottom_button(),
        ),
      ),
    ];
  }

  void fastforward() {
    Duration currentPosition = _controller!.value.position;
    Duration targetPosition = currentPosition + const Duration(seconds: 10);
    _controller!.seekTo(targetPosition);
  }

  void backward() {
    Duration currentPosition = _controller!.value.position;
    Duration targetPosition = currentPosition - const Duration(seconds: 10);
    _controller!.seekTo(targetPosition);
  }

  void show_content() {
    setState(() {
      show = !show;
    });
  }

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          child: Stack(
            children: [
              video_played(),
        //  Padding(
        //   padding: EdgeInsets.only(left: 20),
        //   child:
        //      Align (
        //       alignment: Alignment.centerLeft,
        //         child: SizedBox(
        //           height: 200,
        //           child: RotatedBox (
        //             quarterTurns: -1,
        //             child: LinearProgressIndicator(
        //               minHeight: 20,
        //               value: 0.89,
        //               valueColor: AlwaysStoppedAnimation(Colors.purple),
        //               backgroundColor: Colors.lime,
        //             ),
        //           ),
        //         ),
        //       )
        // ),
        // Padding(
        //   padding: EdgeInsets.only(right: 20),
        //   child:
        //      Align (
        //       alignment: Alignment.centerRight,
        //         child: SizedBox(
        //           height: 200,
        //           child: RotatedBox (
        //            quarterTurns: -1,
        //            child: LinearProgressIndicator(
        //              minHeight: 20,
        //              value: 0.89,
        //              valueColor: AlwaysStoppedAnimation(Colors.purple),
        //              backgroundColor: Colors.lime,
        //            ),
        //               ),
        //         ),
        //       )
        // ),
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


              GestureDetector(
                onHorizontalDragEnd: (details) => fastforward(),
                onTap: show_content,
                onDoubleTap: () {
                  fastforward();
                },
                onVerticalDragUpdate: (details) {
                  int sensitivity = 1;
                  if (details.delta.dy > sensitivity) {
                     print("swipe down + "+details.delta.dy .toString() );
                  } else if (details.delta.dy < -sensitivity) {
                      print("swipe up + "+details.delta.dy .toString() );
                  }
                },
                child: ClipPath(
                  clipper: OvalLeftBorderClipper(
                      curveHeight: MediaQuery.of(context).size.width),
                  child: Container(
                      color: Colors.transparent,
                      height: double.infinity,
                      width: double.infinity,
                      

        //               child: RotatedBox(quarterTurns: -1,
        // child: LinearProgressIndicator(
        //   value: 0.12,
        // ),),

                      ),
                ),
              ),
              GestureDetector(
                onTap: show_content,
                onDoubleTap: () {
                  print("left");
                  backward();
                },
                onVerticalDragUpdate: (details) {
                  int sensitivity = 0;
                  if (details.delta.dy > sensitivity) {
                  print("swipe down");
                  } else if (details.delta.dy < -sensitivity) {
                  print("swipe up");
                  }
                },
                child: ClipPath(
                  clipper: OvalRightBorderClipper(
                      curveHeight: MediaQuery.of(context).size.height),
                  child: Container(
                      color: Colors.transparent,
                      height: double.infinity,
                      width: double.infinity,
                     // child: LinearProgressIndicator(value: 0.3),
                      ),
                ),
              ),
              show && !lock
                  ? Container(
                      child: Column(
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
                      ),
                    )
                  : Container(),
            ],
          ),
        ));
  }
}
