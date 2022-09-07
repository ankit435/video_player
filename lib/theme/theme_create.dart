import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/files.dart';
import 'package:video/theme/theme_constants.dart';

import '../home/home.dart';
import '../properties/color_picker_bottomsheett.dart';
import '../showdialogbox/file_delete.dart';

class Create_theme extends StatefulWidget {
  const Create_theme({Key? key}) : super(key: key);
  static const routeName = '/theme_create';
  @override
  State<Create_theme> createState() => _Create_themeState();
}

class _Create_themeState extends State<Create_theme> {
  @override

  int value = 0;
   

  List<Color> colors = [

    Colors.red, // App barr background 0
    Colors.pink,// body background 1
    Colors.purple,// icons colour 2
    Colors.deepPurple,// title text colour 3
    Colors.indigo,// subtitle text colour 4
    Colors.blue,// listtiles colour 5
    Colors.lightBlue,// primary swatch 6
    Colors.cyan,// inactive_slider 7
    Colors.teal,//active slider 8
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  Future<void> create_new_theme() async {

  ThemeData themeData = ThemeData(
    
    primaryColor: colors[0],
    scaffoldBackgroundColor: colors[0],
    backgroundColor: colors[1],
    iconTheme: IconThemeData(color: colors[2]),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: colors[3]),
      subtitle2: TextStyle(color: colors[4]),
     
    ),
    secondaryHeaderColor: colors[2],

    sliderTheme: SliderThemeData(
            activeTrackColor: colors[8],
            inactiveTrackColor: colors[7],
                   
            thumbColor: Colors.white,
            overlayColor: Colors.black.withAlpha(120),
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
          ),
  );

    Provider.of<themes>(context, listen: false)
        .addTheme(Brightness.dark, themeData);
    Navigator.of(context).pop();

    
   
  }

  void setwidgetcolur(int value) {
    setState(() {
      this.value = value;
    });
  }

  Color getwidgetcolur() {
    return colors[value];
  }

  Widget IconsButton(IconData icon, Function function) {
    return IconButton(
      icon: Icon(
        icon,
        color: colors[2],
      ),
      onPressed: () {
        function();
      },
    );
  }

  void _color_picker_bottomsheet(BuildContext context, String text) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Colour_picker_bottomsheet(
          text: text,
        );
      },
    );
  }

  Widget text(String texts, int index) {
    return GestureDetector(
      onTap: () {
        setwidgetcolur(index);
      },
      onDoubleTap: () {
        setwidgetcolur(index);
      },
      child: Text(
        texts,
        style: TextStyle(
          color: colors[index],
        ),
      ),
    );
  }

double count=0.0;
  

  

  Widget build(BuildContext context) {
    return Scaffold(
      
        appBar: AppBar( 
      
          backgroundColor: colors[0],
          title: const Text('Create Theme'),
          actions: [
             IconsButton(Icons.color_lens, () {
              _color_picker_bottomsheet(context, "Appbar colour");
            }),
            IconsButton(Icons.save, () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Show_dialog(
                      onPressedtext: "Create",
                      title: "Theme Creation",
                      text: "Are you sure you create this theme ?",
                      onPressed: create_new_theme,
                    );
                  });
            }),
           
          ],
        ),
        body: GestureDetector(
          onLongPress: () {
            setwidgetcolur(1);
          },
          child: Container(
            color: colors[1],
            child: Column(
              children: [
                Flexible(
                  
                  child: Column(
                    children: [
                      ListTile(
                        leading: IconsButton(Icons.nature_outlined, () {
                          setwidgetcolur(2);
                        }),
                        tileColor: colors[6],
                        title: text("This is New Title", 4),
                        subtitle: text("This is New Subtitle", 5),
                        trailing: IconsButton(Icons.nature_outlined, () {
                          setwidgetcolur(2);
                        }),
                        onTap: () {},
                        onLongPress: () {setwidgetcolur(6);},
                      ),
                      ListTile(
                       tileColor: colors[6],
                        leading: IconsButton(Icons.nature_outlined, () {
                          setwidgetcolur(2);
                        }),
                        
                        title: text("This is New Title", 4),
                        subtitle: text("This is New Subtitle", 5),
                        trailing: IconsButton(Icons.nature_outlined, () {
                          setwidgetcolur(2);
                        }),
                        
                        onTap: () {},
                        onLongPress: () {setwidgetcolur(6);},
                      ),
                      ListTile(
                        tileColor: colors[6],
                        leading: IconsButton(Icons.nature_outlined, () {
                          setwidgetcolur(2);
                        }),
                        title: text("This is New Title", 4),
                        subtitle: text("This is New Subtitle", 5),
                        trailing: IconsButton(Icons.nature_outlined, () {
                          setwidgetcolur(2);
                        }),
                        onTap: () {},
                        onLongPress: () {setwidgetcolur(6);},
                      ),
                      ListTile(
                        tileColor: colors[6],
                        leading: IconsButton(Icons.nature_outlined, () {
                          setwidgetcolur(2);
                          ;
                        }),
                        title: text("This is New Title", 4),
                        subtitle: text("This is New Subtitle", 5),
                        trailing: IconsButton(Icons.nature_outlined, () {
                          setwidgetcolur(2);
                          
                        }),
                        onTap: () {},
                        onLongPress: () {setwidgetcolur(6);},
                      ),


                      Expanded(
                child: GestureDetector (
                  onDoubleTap: (){setwidgetcolur(8);},
                  onLongPress: (){setwidgetcolur(9);},
                  child: Slider(
                    inactiveColor: colors[7],
                    activeColor:  colors[8],
                    min: 0.0,
                    max: 1.0,
                    value: count,
                    onChanged: (value) {
                      setState(() {
                        count = value;
                      });
                    },
                  ),
                )
                      )
                   
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5 -
                      AppBar( 
       backgroundColor: Theme.of(context).scaffoldBackgroundColor,).preferredSize.height,
                  child: FittedBox(
                    child: Center(
                      child: CircleColorPicker(
                        controller: CircleColorPickerController(
                            initialColor: getwidgetcolur()),
                        strokeWidth: 4,
                        thumbSize: 36,
                        onChanged: (color) {
                          setState(() {
                            colors[value] = color;
                          });
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
