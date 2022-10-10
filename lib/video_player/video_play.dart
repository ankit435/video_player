import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video/helper/theme_model.dart';
import 'package:video/video_player/video_utilites/bottom_icon_buttons.dart';
import 'package:video/video_player/video_utilites/slider.dart';
import 'package:video/video_player/video_utilites/video_player_bottomsheet.dart';

import 'package:video_player/video_player.dart';

import '../cliper/left_border_cliper.dart';
import '../cliper/right_border_cliper.dart';
import '../helper/file.dart';
import '../helper/files.dart';
import '../showdialogbox/Shubtitle_screen.dart';
import '../showdialogbox/create_timer.dart';
import '../showdialogbox/show_subtitile.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';

class Play_video extends StatefulWidget {
  const Play_video({Key? key}) : super(key: key);
  static const routeName = '/video_played';

  @override
  State<Play_video> createState() => _Play_videoState();
}

class _Play_videoState extends State<Play_video> {
  @override
  bool show = true;
  late double volume;

  VideoPlayerController? _controller;
  var f;
  bool mounted = true;
  bool left = false;
  bool background_play = false;
  bool lock = false;

  var queue_player;
  double speed = 1.0;
  late Timer _timer;
  Timer? _sleep_timer;
  int _start = 3;
  String? f_id, p_id;
  late int repeat_mode;
  int decoder = 1;
  int sleep = 0;
  bool mirror = false;
  int aspect_ratio = 0;
  double currentvol = 0.5;
  double current_brightness = 0.5;

  double _maxVolume = 1.0;
  bool _showVolumeStatus = false;
  Timer? _closeVolumeStatus;
  double _maxBright_ness = 1.0;
  bool _showBright_nessStatus = false;
  Timer? _closeBright_nessStatus;
  StreamSubscription<double>? volume_subscription;

  List<IconData> icon = [
    Icons.fullscreen,
    Icons.aspect_ratio,
    Icons.image_aspect_ratio,
    Icons.smart_display,
    Icons.image_aspect_ratio,
    Icons.smart_display
  ];

  void setfolderplylist() {
    f_id = Provider.of<queue_playerss>(context, listen: false).getf_id();
    p_id = Provider.of<queue_playerss>(context, listen: false).getp_id();
  }

  Future<void> _onControllerChange(video link) async {
    if (mounted) {
       WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<Video_player>(context, listen: false)
          .set_video_path(link.v_videoPath);
        });
      
    }
  }

  String buttontype = "none";
  void initState() {
    repeat_mode_update();
    Hw_sw_decoders();
    if (Provider.of<Setting_data>(context, listen: false)
        .get_setting_remember_aspect_ratio()) {
      aspect_ratio = Provider.of<Setting_data>(context, listen: false)
          .get_setting_aspect_ratio();
    }
   
    if (mounted) {
      startTimer();
      defaultsorenatation();
      setfolderplylist();
      video v = getvideo();
      _onControllerChange(v);
      _controller = Provider.of<Video_player>(context, listen: false)
          .get_video_player_controller();
      Future.delayed(Duration.zero, () async {
        currentvol = (await PerfectVolumeControl.getVolume());
        setState(() {
          //refresh UI
        });
        PerfectVolumeControl.hideUI = true;
      });
      volume_subscription = PerfectVolumeControl.stream.listen((volume) {
        if (volume != currentvol) {
          if (volume > currentvol) {
            buttontype = "up";
          } else {
            buttontype = "down";
          }
        }
        setState(() {
          currentvol = volume;
        });
      });
    }
    
    super.initState();
  }

  void updateslider(double value) {
    speed = value;
    Provider.of<Video_player>(context, listen: false).set_play_speed(speed);
  }

  void repeat_mode_update({int? val}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (val == null) {
      repeat_mode = prefs.getInt('repeat_mode') ?? 1;
    } else {
      setState(() {
        try {
          repeat_mode = val;

          prefs.setInt('repeat_mode', repeat_mode);
        } catch (e) {
          print(e);
        }
      });
    }
  }

  int get_repeat_mode() {
    return repeat_mode;
  }

  void set_sleep_timer(int value) {
    setState(() {
      sleep = value * 60;
    });

    sleeptimer();
  }

  void mirror_video_toggel() {
    setState(() {
      mirror = !mirror;
    });
  }

  void sleeptimer() {
    if (_sleep_timer != null && _sleep_timer!.isActive) {
      _sleep_timer!.cancel();
      _sleep_timer = null;
      sleep = 0;
    } else {
      startsleepTimer();
    }
  }

  void startsleepTimer() {
    if (mounted) {
      const oneSec = const Duration(seconds: 1);
      _sleep_timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(
          () {
            if (sleep < 1) {
              if (_controller!.value.isPlaying) {
                _controller!.pause();
              }
              timer.cancel();
            } else {
              print(sleep);
              sleep = sleep - 1;
            }
          },
        ),
      );
    }
  }

  void repeat_mode_updated_video() {
    if (repeat_mode == 1) {
      Provider.of<queue_playerss>(context, listen: false).getskipnextvideo();
      _onControllerChange(getvideo());
    } else if (repeat_mode == 2) {
      _controller!.seekTo(const Duration(microseconds: 0));
      _controller!.play();
    } else if (repeat_mode == 3) {
      Provider.of<queue_playerss>(context, listen: false).get_random_video();
      _onControllerChange(getvideo());
    } else if (repeat_mode == 4) {
      Provider.of<queue_playerss>(context, listen: false).get_rotate_video();
      _onControllerChange(getvideo());
    }
  }

void Hw_sw_decoders({int? val}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (val == null) {
      decoder = prefs.getInt('decoder') ?? 1;
    } else {
      setState(() {
        decoder = val;
      });
    }
  }

  video getvideo() {
    video v =
        Provider.of<queue_playerss>(context, listen: false).getvideo_by_id();
    if (Provider.of<Setting_data>(context, listen: false)
        .get_setting_show_History()) {
      Provider.of<recent_videos>(context, listen: false).add_to_recent(v);
    }
    return v;
  }

  void update_curent_watch_time() {
    video v = getvideo();
    Provider.of<folder_details>(context, listen: false).SetWatchedduration(
        Provider.of<Video_player>(context, listen: false).get_position(),
        v.v_id,
        v.parent_folder_id);
  }

  @override
  void didChangeDependencies() {
    //update_curent_watch_time();
    super.didChangeDependencies();
  }

  void exitfullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  void dispose() {
    volume_subscription!.cancel();
    super.dispose();
    _timer.cancel();
    if (_sleep_timer != null) {
      _sleep_timer!.cancel();
      _sleep_timer = null;
    }
    exitfullscreen();
    mounted = false;
    defaultsorenatation();
    if (Provider.of<Video_player>(context, listen: false).get_is_playing()) {
      Provider.of<Video_player>(context, listen: false).dispose();
    }
  }

  void setAspectratio() {
    if (aspect_ratio == 0) {
      Provider.of<Video_player>(context, listen: false)
          .set_aspect_ratio(_controller!.value.aspectRatio);
      aspect_ratio = 1;
    } else if (aspect_ratio == 1) {
      Provider.of<Video_player>(context, listen: false)
          .set_aspect_ratio(16 / 9);
      aspect_ratio = 2;
    } else if (aspect_ratio == 2) {
      Provider.of<Video_player>(context, listen: false).set_aspect_ratio(4 / 3);
      aspect_ratio = 3;
    } else if (aspect_ratio == 3) {
      Provider.of<Video_player>(context, listen: false).set_aspect_ratio(1 / 1);
      aspect_ratio = 4;
    } else if (aspect_ratio == 4) {
      Provider.of<Video_player>(context, listen: false)
          .set_aspect_ratio(9 / 16);
      aspect_ratio = 5;
    } else if (aspect_ratio == 5) {
      Provider.of<Video_player>(context, listen: false).set_aspect_ratio(3 / 4);
      aspect_ratio = 0;
    } else {
      aspect_ratio = 0;
    }

    if (Provider.of<Setting_data>(context, listen: true)
        .get_setting_remember_aspect_ratio()) ;
    {
      Provider.of<Setting_data>(context, listen: true)
          .setAspectiovalue(aspect_ratio);
    }
  }

  void setfullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void setfullscreen_portrait() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void setfullscreen_landscape() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void setfullscreen_auto() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void setfullscreen_user() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void setfullscreen_landscape_left() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
  }

  void setfullscreen_landscape_right() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
  }

  void setfullscreen_portrait_up() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget video_played() {
    return Center(
      child: Provider.of<Video_player>(context, listen: true).is_initailized
          ? AspectRatio(
              aspectRatio: Provider.of<Video_player>(context, listen: true).get_aspect_ratio(),
                      
              child: GestureDetector(
                child: Stack(
                  children: [
                    Transform.scale(
                        scaleX: mirror ? -1 : 1,
                        child: VideoPlayer(_controller!)),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: caption_play()),
                  ],
                ),
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
            child: video_bottom_sheet(
                playfolder_video: playfolder_video, f_id: f_id, p_id: p_id));
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
            child: icon_butoons(
                repeat_mode_update: repeat_mode_update,
                repeat_mode: repeat_mode,
                Hw_sw_decoders: Hw_sw_decoders,
                decoder: decoder,
                icon_button_press: icon_button_press));
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

  void icon_button_press(int val) {
    switch (val) {
      case 1:
        {
          print("1");
        }
        break;
      case 2:
        {
          print("2");
        }
        break;
      case 3:
        {
          print("3");
        }
        break;
      case 4:
        {
          print("4");
        }
        break;
      case 5:
        {
          print("5");
        }
        break;
      case 6:
        {
          print("6");
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Subtitle_screen();
              });
        }
        break;
      case 7:
        {
          print("7");
        }
        break;
      case 8:
        {
          print("8");
        }
        break;
    }
  }

  void _bottoslider(BuildContext context) {
    print("called_slider");
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

  Widget icons_theme(IconData? icon) {
    return Icon(
      icon,
      color: Colors.white,
    );
  }

  Widget iconbutton(IconData? icon, Function? param1, {String? text = null}) {
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
                text == null
                    ? icons_theme(icon)
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

  void toggle_play_pause() {
    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
  }

  bool isLand_scape() {
    return MediaQuery.of(context).orientation == Orientation.landscape;
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
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLand_scape()
              ? iconbutton(Icons.fast_rewind, () {
                  backward();
                })
              : Container(),
          Transform.scale(
            scale: 1.5,
            child: iconbutton(Icons.skip_previous, () {
              play_prv() ? _onControllerChange(getvideo()) : null;
            }),
          ),
          Transform.scale(
            scale: 2,
            child: iconbutton(
                Provider.of<Video_player>(context, listen: true)
                        .get_is_playing()
                    ? Icons.pause_circle_outline_outlined
                    : Icons.play_circle_outline_outlined, () {
              Provider.of<Video_player>(context, listen: false).play_pause();
            }),
          ),
          Transform.scale(
            scale: 1.5,
            child: iconbutton(Icons.skip_next, () {
              play_next() ? _onControllerChange(getvideo()) : null;
            }),
          ),
          isLand_scape()
              ? Transform.scale(
                  scaleX: -1,
                  child: iconbutton(Icons.fast_rewind, () {
                    fastforward();
                  }))
              : Container(),
        ],
      ),
      iconbutton(icon[aspect_ratio], () {
        setAspectratio();
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
          Provider.of<Video_player>(context, listen: true).get_is_muted()
              ? Icons.volume_off
              : Icons.volume_up, () {
        Provider.of<Video_player>(context, listen: false).set_muted();
      }),
      SizedBox(
        width: 10,
      ),
      Provider.of<Setting_data>(context, listen: false)
              .get_setting_background_play()
          ? iconbutton(Icons.headphones, () {
              //  dispose();
            })
          : SizedBox(),
      SizedBox(
        width: 10,
      ),
      iconbutton(Icons.speed, () {
        _bottoslider(context);
      }, text: speed.toString() + "X"),
      SizedBox(
        width: 10,
      ),
    ];
  }

  String formatHHMMSS(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  List<Widget> variable_button() {
    return [
      iconbutton(Icons.brightness_medium_outlined, () {}),
      SizedBox(
        width: 10,
      ),
      iconbutton(Icons.alarm_rounded, () {
        _sleep_timer != null && _sleep_timer!.isActive
            ? _sleep_timer!.cancel()
            : showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Create_timer(
                      video_duration: _controller!.value.duration.inMinutes -
                          _controller!.value.position.inMinutes,
                      set_sleep_timer: set_sleep_timer);
                });
      },
          text: _sleep_timer != null && _sleep_timer!.isActive
              ? formatHHMMSS(sleep)
              : null),
      SizedBox(
        width: 10,
      ),
      iconbutton(Icons.mobile_screen_share_rounded, () {
        mirror_video_toggel();
      }),
    ];
  }

  List<Widget> action() {
    return [
      iconbutton(
        Icons.closed_caption_outlined,
        () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Subtitle_screen();
              });
        },
      ),
      if (p_id != null || f_id != null)
        iconbutton(
          Icons.playlist_play,
          () {
            _bottofolder_queue_list(context);
          },
        ),
      iconbutton(
        Icons.more_vert,
        () {
          _bottombutton(context);
        },
      ),
    ];
  }

  List<Widget> topbaar() {
    return [
      AppBar(
        leading: iconbutton(
          Icons.arrow_back,
          () {
            Navigator.of(context).pop();
          },
        ),
        title: AutoSizeText(
          Provider.of<queue_playerss>(context, listen: true).video_title(),
          maxLines: 2,
          minFontSize: 17,
          maxFontSize: 18,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              // color: Theme.of(context).primaryIconTheme.color,
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
    if (mounted) {
      const oneSec = const Duration(seconds: 1);
      _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(
          () {
            if (show == false) {
              timer.cancel();
            }

            if (show && _controller!.value.isPlaying) {
              if (_start < 1) {
                setState(() {
                  show = false;
                  _start = 7;
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
  }

  List<Widget> bottobar() {
    return [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  getDuration(Provider.of<Video_player>(context, listen: true)
                      .get_position()
                      .toDouble()),
                  style: const TextStyle(
                      //color: Theme.of(context).sliderTheme.activeTrackColor,
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500)),
              Expanded(
                child: Slider(
                  // inactiveColor: Colors.blue,
                  // activeColor: Colors.red,
                  min: 0.0,
                  max: Provider.of<Video_player>(context, listen: true)
                      .get_duration()
                      .toDouble(),
                  value: Provider.of<Video_player>(context, listen: true)
                      .get_position()
                      .toDouble(),
                  // label: getDuration(
                  //     Provider.of<Video_player>(context, listen: true)
                  //         .get_position()
                  //         .toDouble()),
                  onChanged: (value) {
                    Provider.of<Video_player>(context, listen: false)
                        .seek_to_position(value.round());
                  },
                ),
              ),
              Text(
                  getDuration(Provider.of<Video_player>(context, listen: true)
                          .get_duration()
                          .toDouble() -
                      Provider.of<Video_player>(context, listen: true)
                          .get_position()
                          .toDouble()),
                  style: const TextStyle(
                      //color: Theme.of(context).sliderTheme.inactiveTrackColor,
                      color: Colors.white,
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
    Duration targetPosition = currentPosition +
        Duration(
            seconds: Provider.of<Setting_data>(context, listen: false)
                .get_skip_time());
    Provider.of<Video_player>(context, listen: false).seek_to(targetPosition);
  }

  void backward() {
    Duration currentPosition = _controller!.value.position;
    Duration targetPosition = currentPosition -
        Duration(
            seconds: Provider.of<Setting_data>(context, listen: false)
                .get_skip_time());
    Provider.of<Video_player>(context, listen: false).seek_to(targetPosition);
  }

  void show_content() {
    if (show) {
      setState(() {
        show = false;
      });
    } else {
      setState(() {
        show = true;
      });
      startTimer();
    }
  }

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());
    String time=   [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
    if(duration.inHours==0){
      return time;
    }
    return [duration.inHours, time].join(':');
  }

  Widget caption_play() {
    return ClosedCaption(
      text: "Helo",
      textStyle: TextStyle(color: Colors.red),
    );
  }

  bool horizontal_dragging = false;
  Widget build(BuildContext context) {
    _controller = Provider.of<Video_player>(context, listen: true)
        .get_video_player_controller();
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                onTap: show_content,
                onDoubleTapDown: (TapDownDetails details) {
                  if (details.globalPosition.dx <
                      MediaQuery.of(context).size.width / 2) {
                    backward();
                  } else {
                    fastforward();
                  }
                },

                onVerticalDragStart: (details) {
                  if (details.globalPosition.dx <
                      MediaQuery.of(context).size.width / 2) {
                    setState(() {
                      _closeBright_nessStatus?.cancel();
                      _showBright_nessStatus = true;
                    });
                  } else {
                    _closeVolumeStatus?.cancel();
                    _showVolumeStatus = true;
                  }
                },

                onVerticalDragEnd: (details) {
                  if (_showVolumeStatus) {
                    _closeVolumeStatus = Timer(Duration(seconds: 1), () {
                      setState(() {
                        _closeVolumeStatus?.cancel();
                        _closeVolumeStatus = null;
                        _showVolumeStatus = false;
                      });
                    });
                  } else if (_showBright_nessStatus) {
                    _closeBright_nessStatus = Timer(Duration(seconds: 1), () {
                      setState(() {
                        _closeBright_nessStatus?.cancel();
                        _closeBright_nessStatus = null;
                        _showBright_nessStatus = false;
                      });
                    });
                  }
                },

                onVerticalDragUpdate: (details) {
                  int sensitivity = 2;

                  if (details.globalPosition.dx <
                      MediaQuery.of(context).size.width / 2) {
                    print("Bright_nesss swipe up + " +
                        _showBright_nessStatus.toString());
                  } else {
                    if (details.delta.dy > sensitivity) {
                      if (currentvol < 0.0) {
                        _setVolume(0.0);
                      } else if (currentvol > 1.0) {
                        _setVolume(1.0);
                      } else {
                        _setVolume(currentvol - details.delta.dy / 100);
                      }
                    } else if (details.delta.dy < -sensitivity) {
                      if (currentvol < 0.0) {
                        _setVolume(0.0);
                      } else if (currentvol > 1.0) {
                        _setVolume(1.0);
                      } else {
                        _setVolume(currentvol - details.delta.dy / 100);
                      }
                    }
                  }
                },

                onHorizontalDragUpdate: (details) {
                  int sensitivity = 1;
                  if (details.delta.dx > sensitivity) {
                    print("swipe right + " + details.delta.dx.toString());
                  } else if (details.delta.dx < -sensitivity) {
                    print("swipe left + " + details.delta.dx.toString());
                  }
                },

                onLongPress: () {},

                onLongPressMoveUpdate: (details) {
                  _seekToRelativePosition(details.localPosition, true);
                },

                onDoubleTap: () {},
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.transparent,
                  child: _showVolumeStatus || _showBright_nessStatus
                      ? Align(
                          alignment: _showVolumeStatus
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Padding(
                            padding: _showVolumeStatus
                                ? EdgeInsets.only(left: 10.0)
                                : EdgeInsets.only(right: 10.0),
                            child: SizedBox(
                              height: 200,
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: LinearProgressIndicator(
                                  minHeight: 20,
                                  value: _showVolumeStatus
                                      ? currentvol
                                      : current_brightness,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.purple),
                                  backgroundColor: Colors.lime,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ),

                // onHorizontalDragUpdate: (details) {
                //   if (details.delta.dx > 0) {
                //     // swiped right
                //     setState(() {
                //       backward();
                //     });
                //   } else if (details.delta.dx < 0) {
                //     // swiped left
                //     setState(() {
                //       fastforward();
                //     });
                //   }
                // },
              ),

              //       GestureDetector(
              //         onHorizontalDragEnd: (details) => fastforward(),
              //         onTap: show_content,
              //         onDoubleTap: Provider.of<Setting_data>(context,listen: false).get_setting_double_tap_fast_forward()? () {
              //           fastforward();
              //         }:null,
              // onVerticalDragUpdate: (details) {
              //   int sensitivity = 1;
              //   if (details.delta.dy > sensitivity) {
              //      print("swipe down + "+details.delta.dy .toString() );
              //   } else if (details.delta.dy < -sensitivity) {
              //       print("swipe up + "+details.delta.dy .toString() );
              //   }
              // },
              //         child: ClipPath(
              //           clipper: OvalLeftBorderClipper(
              //               curveHeight: MediaQuery.of(context).size.width),
              //           child: Container(
              //               color: Colors.transparent,
              //               height: double.infinity,
              //               width: double.infinity,

              // //               child: RotatedBox(quarterTurns: -1,
              // // child: LinearProgressIndicator(
              // //   value: 0.12,
              // // ),),

              //               ),
              //         ),
              //       ),
              //      GestureDetector(
              //        onTap: show_content,
              //        onDoubleTap:Provider.of<Setting_data>(context,listen: false).get_setting_double_tap_fast_forward()? () {
              //          print("left");
              //          backward();
              //        }:null,
              //        onVerticalDragUpdate: (details) {
              //          int sensitivity = 0;
              //          if (details.delta.dy > sensitivity) {
              //          print("swipe down");
              //          } else if (details.delta.dy < -sensitivity) {
              //          print("swipe up");
              //          }
              //        },
              //        child: ClipPath(
              //          clipper: OvalRightBorderClipper(
              //              curveHeight: MediaQuery.of(context).size.height),
              //          child: Container(
              //              color: Colors.transparent,
              //              height: double.infinity,
              //              width: double.infinity,

              //             // child: LinearProgressIndicator(value: 0.3),
              //              ),
              //        ),
              //      ),
              show && !lock
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: topbaar(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Transform.scale(
                                  scale: 2,
                                  child: Icon(Icons.fast_rewind,
                                      color: Colors.white)),
                              Transform.scale(
                                  scale: 2,
                                  child: Icon(Icons.fast_forward,
                                      color: Colors.white)),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: bottobar(),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      child: Center(
                          child: show || _controller!.value.isPlaying
                              ? Container()
                              : Transform.scale(
                                  scale: 4,
                                  child: iconbutton(
                                      _controller!.value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow, () {
                                    setState(() {
                                      update_curent_watch_time();
                                      if (_controller!.value.isPlaying) {
                                        _controller!.pause();
                                      } else {
                                        _controller!.play();
                                      }
                                    });
                                  }),
                                )))
            ],
          ),
        ));
  }

  void _seekToRelativePosition(Offset localPosition, bool bool) {
    if (_controller!.value.duration == null) {
      return;
    }
    final RenderBox box = context.findRenderObject() as RenderBox;

    final Offset tapPos = box.globalToLocal(localPosition);
    final double relativePosition = tapPos.dx / box.size.width;
    final Duration position = _controller!.value.duration * relativePosition;
    if (position >= Duration.zero && position <= _controller!.value.duration) {
      Provider.of<Video_player>(context, listen: false)
          .seek_to_position(position.inMilliseconds);
    }
  }

  void _setVolume(double d) {
    PerfectVolumeControl.setVolume(d);
  }
}
