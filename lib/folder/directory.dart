// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:video/folder/showfile.dart';
// import 'package:video/helper/file.dart';
// import 'package:video/helper/files.dart';

// import '../properties/bottomsheet_playlist.dart';
// import '../properties/folder_bottom_sheet.dart';

// class Directorys extends StatefulWidget {
//   final VoidCallback onPressed;
//   final VoidCallback? toggleselction;
//   final bool selection;
//  Set<int> selction_list;
//   void Function(int,int) toggleselctionlist;
//   Directorys({
//     Key? key,
//     required this.onPressed,
//     required this.toggleselction,
//     required this.selection,
//     required this.selction_list,
//     required this.toggleselctionlist,
//   }) : super(key: key);

//   @override
//   State<Directorys> createState() => _DirectorysState();
// }

// class _DirectorysState extends State<Directorys> {
//   bool detect = false;

//   @override
//   Future<void> _pullRefresh() async {
//     widget.onPressed();
//     return Future.delayed(Duration(seconds: 1));
//   }

//   void _videoproprties(BuildContext context, int f_Id) {
//     // print(f_Id);
//     showModalBottomSheet(
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
//       isScrollControlled: true,
//       context: context,
//       builder: (context) {
//         return GestureDetector(
//           onTap: () {},
//           behavior: HitTestBehavior.opaque,
//           child: Floder_bottomsheet(
//               bottoplaylist: _bottoplaylist, f_Id: f_Id, v_id: -1),
//         );
//       },
//     );
//   }

//   void _bottoplaylist(BuildContext context, List<video> f_videos) {
//     showModalBottomSheet(
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
//       isScrollControlled: true,
//       context: context,
//       builder: (context) {
//         return GestureDetector(
//           onTap: () {},
//           behavior: HitTestBehavior.opaque,
//           // folder directory plylist and pass folder video

//           child: BottomPlayList(
//               v_index: -1, f_index: -1, condition: false, passvideo: f_videos),
//         );
//       },
//     );
//   }

//   Widget build(BuildContext context) {
//     return 
//     Center(
//         child: FutureBuilder(
//             future: _inFutureList(),
//             builder: (BuildContext context, AsyncSnapshot snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting &&
//                   snapshot.connectionState != ConnectionState.done) {
//                 return CircularProgressIndicator(
//                   color: Colors.red,
//                 );
//               } else {
//                 return RefreshIndicator(
//                   onRefresh: _pullRefresh,
//                   child: customBuild(context, snapshot),
//                 );
//               }
//             })
//           );
//   }

//   Widget customBuild(BuildContext context, AsyncSnapshot snapshot) {
//     List<folder> values = snapshot.data;
//     return values.isNotEmpty && snapshot.connectionState == ConnectionState.done
//         ? Row(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: values.length,
//                   itemBuilder: (context, index) {
//                     return CharacteristListItem(
//                       bottomsheet: _videoproprties,
//                       folder_detail: values[index],
//                       toggleselction: widget.toggleselction,
//                       selection: widget.selection,
//                       selction_list: widget.selction_list,
//                       toggleselctionlist: widget.toggleselctionlist,
//                     );
//                   },
//                 ),
//               ),
//             ],
//           )
//         : ElevatedButton(onPressed: widget.onPressed, child: Text("Reload"));
//   }

//   Future<List<folder>?> _inFutureList() async {
//     List<folder>? filesList = [];
//     filesList =
//     await Provider.of<folder_details>(context, listen: true).items();
//     await Future.delayed(const Duration(milliseconds: 500));
//     return filesList;
//   }
// }
