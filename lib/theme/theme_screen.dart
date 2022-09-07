
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video/helper/files.dart';

import '../home/home.dart';



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
  var loading=false;
 Future<void> getloaddata() async {
    print("load data");
    var pref=await SharedPreferences.getInstance();
    await pref.setBool('init_data', true);
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      loading=false;
  
    });
}
  Widget Containers(int index) {
    return GestureDetector (
      onTap: (){
        Provider.of<themes>(context,listen: false).update_curr_theme_id(themes_data[index].theme_id);
        loading=true;
        getloaddata();
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
 Widget text(String text){
     return Text(text , style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
              fontWeight: FontWeight.bold,
              fontSize: 30
           ));
}

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
        body: Stack(
          children: [
            Container(
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
                ),
            loading? Container(height: double.infinity,width: double.infinity, color: Colors.transparent.withOpacity(0.4), child: Center(child: text("Setting theme...?"))):Container()
          ],
        )
        );
  }
}
