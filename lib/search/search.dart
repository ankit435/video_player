import 'dart:async';

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
   late Timer _timer;
  int _start = 3;
  bool loading = true;
  bool mounted=true;

  void initState() {

   if(mounted){ 
    startTimer();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
   }
    super.initState();
  }

  void dispose() {
   
    searchController.dispose();
    _timer.cancel();;
    mounted=false;
    
    super.dispose();
  }

  Future<void> onsinglefiledelete(Map<String, String> single_video_list) async {
    if (single_video_list.isNotEmpty) {
      await Provider.of<folder_details>(context, listen: false)
          .delete_file(single_video_list);
    }
  }

  void _videoproprties(BuildContext context, String v_id, String f_id) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: Bottom_model(
              v_id: v_id,
              file_detail: values,
              f_id: f_id,
              onPressed: _bottoplaylist,
              onsinglefiledelete: onsinglefiledelete),
        );
      },
    );
  }

  void _bottoplaylist(BuildContext context, String v_id, String f_id) {
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
          child: BottomPlayList(
              v_id: v_id, passvideo: const [], f_id: f_id, condition: true),
        );
      },
    );
  }

  Widget listvaluebuilder() {
    return ListView.builder(
      
      itemCount: values.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Files_path(
            file_path: values,
            index: index,
            value: 0,
            onPressed: null,
            selection: false,
            selction_list: {},
            onPressed1: null,
            bottommodel: _videoproprties,
          ),
        );
      },
    );
  }

 

  void startTimer() {
    if(mounted){
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (loading) {
            if (_start < 1) {
              setState(() {
                loading = false;
                _start = 3;
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

// Widget fututurebuilder(){
//   return FutureBuilder(
//           future: _inFutureList(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting &&
//                 snapshot.connectionState != ConnectionState.done) {
//               return CircularProgressIndicator(
//                 color: Colors.red,
//               );
//             } else {
//               return customBuild(context, snapshot);
//             }
//           },
//         );
// }

// Future<List<video>?> _inFutureList() async {
//     List<video>? filesList = [];
//     filesList = await Provider.of<folder_details>(context, listen: true)
//         .getsearchvideo(filter);
//     await Future.delayed(const Duration(milliseconds: 200));
//     oldtext=filter;
//     return filesList;
//   }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
  
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    values = Provider.of<folder_details>(context, listen: true)
        .getsearchvideo(filter);
//         .getsearchvideo(filter);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        title: TextFormField(
            controller: searchController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Search')),
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: filter == null || filter == ''
            ? Container()
            : Center(
                child:
                    //oldtext==filter&&filter!=Null?listvaluebuilder():
                    //fututurebuilder(),
                    filter != null && filter!.isNotEmpty && values.length <= 0
                        ? loading
                            ? Container(
                                child: Center(
                                child: CircularProgressIndicator(),
                              ))
                            : Container()
                        : listvaluebuilder()),
      ),
    );
  }

  // Widget customBuild(BuildContext context, AsyncSnapshot snapshot) {
  //   values = snapshot.data;
  //   return values.isNotEmpty && snapshot.connectionState == ConnectionState.done
  //       ? listvaluebuilder():Container();
  // }

}
