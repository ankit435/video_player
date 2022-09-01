
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/files.dart';



class theme_screen extends StatefulWidget {
  const theme_screen({Key? key}) : super(key: key);
  static const routeName = '/theme_screen';
  @override
  State<theme_screen> createState() => _theme_screenState();
}

class _theme_screenState extends State<theme_screen> {
  @override
  var height;
  var width;
  var themes_data;

  Widget Containers(int index) {
    return GestureDetector (
     
      onTap: (){
        Provider.of<themes>(context,listen: false).update_curr_theme_id(themes_data[index].theme_id);
      },
      child: Container(
          key: ValueKey(index),
          height: math.max(height, 200),
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), // radius of 10
            color: themes_data[index].themeData.backgroundColor,
            border: Border.all(
              color: themes_data[index].theme_id==themes_data[0].curr_thenme_id? Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0):themes_data[index].themeData.primaryColor
            ), // green as background color
          )),
    );
  }

  // Widget rows() {
  //   return FittedBox(
  //       child: Row(
  //     children: [
  //       Containers(),
  //       SizedBox(
  //         width: 10,
  //       ),
  //       Containers()
  //     ],
  //   ));
  // }

  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height / 4;
    width = MediaQuery.of(context).size.width / 2;
    themes_data=Provider.of<themes>(context,listen: true).themes_data;

    return Scaffold(
      
        appBar: AppBar( 
backgroundColor: Theme.of(context).primaryColor,
          title: const Text("Theme"),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/theme_create');
              },
            ),
          ],
        ),
        body: Container(
             color: Theme.of(context).backgroundColor,
          child: Center(
              child: GridView.builder(
                 
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Containers(index),
                    );
                  },
                  itemCount: themes_data.length, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),)),
            )
        );
  }
}
