import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/file.dart';

import '../file/files_detail.dart';
import '../helper/files.dart';
import '../properties/bottomsheet_playlist.dart';
import '../properties/file_bootom_sheet.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);
  static const routeName = '/search_video';
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
 List<video> values = [];
  String? filter;
  String? oldtext;
  TextEditingController searchController = new TextEditingController();

  void initState() {
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
    super.initState();
  }

  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  
void _videoproprties(BuildContext context, int id,int f_id) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,

          child:Bottom_model(v_id:id,file_detail: values,f_id:f_id,onPressed:_bottoplaylist),
        );
      },
    );
  }


void _bottoplaylist(BuildContext context, int v_index,int f_index) {
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
          child:BottomPlayList(v_index:v_index,passvideo: const [],f_index: f_index,condition: true),
        );
      },
    );
  }


Widget listvaluebuilder(){
    return Row(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: values.length,
                  itemBuilder: (context, index) {
                    // return ListTile(
                    //   title: Text(values[index].v_title),
                    // );
            return Files_path(
            file_path: values,
            index: index,
            value: 0,
            onPressed: null,
            selection: false,
            selction_list: {},
            onPressed1: null,
            bottommodel:_videoproprties,
          );
                  },
                ),
              ),
            ],
        );
  }

Widget fututurebuilder(){
  return FutureBuilder(
          future: _inFutureList(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator(
                color: Colors.red,
              );
            } else {
              return customBuild(context, snapshot);
            }
          },
        );
}

Future<List<video>?> _inFutureList() async {
    List<video>? filesList = [];
    filesList = await Provider.of<folder_details>(context, listen: true)
        .getsearchvideo(filter);
    await Future.delayed(const Duration(milliseconds: 200));
    oldtext=filter;
    return filesList;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
            controller: searchController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Search')),
      ),
      body: filter==null||filter==''?Container() :  Center(
        child: 
        //oldtext==filter&&filter!=Null?listvaluebuilder():
        fututurebuilder(),
      ),
    );
  }

  Widget customBuild(BuildContext context, AsyncSnapshot snapshot) {
    values = snapshot.data;
    return values.isNotEmpty && snapshot.connectionState == ConnectionState.done
        ? listvaluebuilder():Container();
  }

 
}
