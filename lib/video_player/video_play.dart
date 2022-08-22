import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:video_player/video_player.dart';

import '../cliper/left_border_cliper.dart';
import '../cliper/right_border_cliper.dart';
import '../helper/files.dart';

class Play_video extends StatefulWidget {
  const Play_video({Key? key}) : super(key: key);
  static const routeName = '/video_played';

  @override
  State<Play_video> createState() => _Play_videoState();
}

class _Play_videoState extends State<Play_video> {
  @override
  bool show = false;
  late int currentDuration;

  VideoPlayerController? _controller;
  var f;

  bool left = false;
  bool background_play = false;
  bool lock = false;
  int newCurrentPosition = 0;
  var queue_player;
  //Future<void>screen_display;

  

  void _load_video(String v_videoPath, int index) {
    f = File(v_videoPath);
    _controller = VideoPlayerController.file(f!)
      ..initialize().then((_) {
        setState(() {
          if (queue_player[3][index].v_open == false &&
              queue_player[3][index].v_duration == -1) {
            Provider.of<folder_details>(context, listen: false).Setduration(
                _controller!.value.duration.inSeconds,
                queue_player[3][index].v_id,
                queue_player[3][index].parent_folder_id);
          }
          Provider.of<folder_details>(context, listen: false).updatevideoopen(
              queue_player[3][index].v_id,
              queue_player[3][index].parent_folder_id);
        });
      });
    // _controller!.addListener(
    //   () => setState(() => currentDurationInSecond = _controller!.value.position.inSeconds),
    // );
    _controller!.play();
  }

  Future<void> _onControllerChange(String link, int index) async {
    if (_controller == null) {
      _load_video(link, index);
    } else {
      final oldController = _controller;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await oldController!.dispose();
        _load_video(link, index);
      });
      // setState(() {
      //   _controller = null;
      // });
    }
  }

  void initState() {
    // setState(() {
    //   //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    //   index = widget.index;
    // });

    defaultsorenatation();
    queue_player =
        Provider.of<queue_playerss>(context, listen: false).getqueuevideo();
    if (queue_player[0] && false) {
      setState(() {
        _controller = queue_player[1];
      });
    } else {
      _onControllerChange(getcurr_video(), queue_player[2]);
    }
    _controller!.addListener(() {
      updateseeker();
    });
    super.initState();
  }

  void updateseeker() {
    setState(() {
      currentDuration = _controller!.value.position.inMilliseconds;
    });
  }

  // void _getValuesAndPlay(String videoPath) {
  //   newCurrentPosition = _controller.value.position;
  //   _startPlay(videoPath);
  //   print(newCurrentPosition.toString());
  // }

  void update_curent_watch_time() {
    // print("currentDurationInSecond===" +currentDurationInSecond.toString());
    Provider.of<folder_details>(context, listen: false).SetWatchedduration(
        currentDuration,
        queue_player[3][getcurrent_index()].v_id,
        queue_player[3][getcurrent_index()].parent_folder_id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
//  update_curent_watch_time();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // if(!background_play)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    defaultsorenatation();

    if (_controller!.value.isPlaying) _controller!.pause();
    _controller!.removeListener(() {
      updateseeker();
    });

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
                Icon(
                  icon,
                  color: Theme.of(context).primaryIconTheme.color,
                ), // icon
                // text
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool play_next() {
    bool cond =
        Provider.of<queue_playerss>(context, listen: false).getskipnextvideo();

    print("cond==" + cond.toString());
    return cond;
  }

// Container(
//       child: Row(
//         children: [
//           Text('00:37'),
//           Expanded(
//               child: Slider(...),
//              ),
//           Text('01:15'),
//          SizedBox(width: 16),
//         ],
//       ),
//     );
  bool play_prv() {
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
        play_prv()
            ? {
                update_curent_watch_time(),
                _onControllerChange(getcurr_video(), getcurrent_index())
              }
            : null;
      }),
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
      iconbutton(Icons.skip_next, () {
        play_next()
            ? {
                update_curent_watch_time(),
                _onControllerChange(getcurr_video(), getcurrent_index())
              }
            : null;
      }),
      iconbutton(Icons.fullscreen, () {
       SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
        dispose();
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
        title: AutoSizeText(

            Provider.of<queue_playerss>(context, listen: false).video_title(),
            maxLines: 2,
            minFontSize: 17,
            maxFontSize: 18,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color:Theme.of(context).primaryIconTheme.color,),
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

  //  Text(getDuration(currentDuration.inMilliseconds.toDouble()), style: TextStyle(color: Colors.grey, fontSize: 12.5, fontWeight: FontWeight.w500)),
  //       Text(getDuration(endduration.inMilliseconds.toDouble()), style: TextStyle(color: Colors.grey, fontSize: 12.5, fontWeight: FontWeight.w500)),

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
                      color: Colors.red,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500)),
              Expanded(
                child: Slider(
                  inactiveColor: Colors.blue,
                  activeColor: Colors.red,
                  min: 0.0,
                  max: _controller!.value.duration.inMilliseconds.toDouble(),
                  value: currentDuration.toDouble(),
                  onChanged: (value) {
                     _controller!.seekTo(Duration(milliseconds: value.round()));
                  },
                ),
              ),
              Text(
                  getDuration(
                      _controller!.value.duration.inMilliseconds.toDouble() -
                          currentDuration.toDouble()),
                  style: TextStyle(
                      color: Colors.blue,
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

// Slider(inactiveColor: Colors.black12,activeColor: Colors.black,min: minimumValue,max: maximumValue,value: currentValue,onChanged: (value) {
//   currentValue=value;
//   player.seek(Duration(milliseconds: currentValue.round()));
// },),

  Widget build(BuildContext context) {
    
    return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
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
          GestureDetector(
            onHorizontalDragEnd: (details) => fastforward(),
            onTap: show_content,
            onDoubleTap: () {
              fastforward();
            },
            child: ClipPath(
              clipper: OvalLeftBorderClipper(
                  curveHeight: MediaQuery.of(context).size.width),
              child: Container(
                  color: Colors.transparent,
                  height: double.infinity,
                  width: double.infinity),
            ),
          ),
          GestureDetector(
            onTap: show_content,
            onDoubleTap: () {
              print("left");
              backward();
            },
            child: ClipPath(
              clipper: OvalRightBorderClipper(
                  curveHeight: MediaQuery.of(context).size.height),
              child: Container(
                  color: Colors.transparent,
                  height: double.infinity,
                  width: double.infinity),
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
