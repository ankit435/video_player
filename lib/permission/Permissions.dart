// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:video/permission/permission_model.dart';

// class Persmissions extends StatefulWidget {
//   const Persmissions({Key? key}) : super(key: key);

//   @override
//   State<Persmissions> createState() => _PersmissionsState();
// }





// class _PersmissionsState extends State<Persmissions> with WidgetsBindingObserver {
//   @override
// bool isPermanent=false;
// bool _detectPermission = false;
// late final permissions_handler _model;


//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     Provider.of<permissions_handler>(context,listen: false).check_permission();
//     super.initState();
//   }


//     void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed &&
//         _detectPermission &&
//         (_model.videoSection == VideoSection.noStoragePermissionPermanent)) {
//       _detectPermission = false;
//       _model.requestFilePermission();
//     } else if (state == AppLifecycleState.paused &&
//         _model.videoSection == VideoSection.noStoragePermissionPermanent) {
//       _detectPermission = true;
//     }
//    }


//    Widget build(BuildContext context) {

    
//    }
// }


// class ImagePermissions extends StatelessWidget {
//   final bool isPermanent;
//   final VoidCallback onPressed;

//   const ImagePermissions({
//     Key? key,
//     required this.isPermanent,
//     required this.onPressed,
//   }) : super(key: key);

  

//   Widget build(BuildContext context) {
//       return Scaffold(
 // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: AppBar(
//         title: Text('VIdeo'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.only(
//                 left: 16.0,
//                 top: 24.0,
//                 right: 16.0,
//               ),
//               child: Text(
//                 'Read files permission',
//                 style: Theme.of(context).textTheme.headline6,
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.only(
//                 left: 16.0,
//                 top: 24.0,
//                 right: 16.0,
//               ),
//               child: const Text(
//                 'We need to request your permission to read '
//                 'local files in order to load it in the app.',
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             if (isPermanent)
//               Container(
//                 padding: const EdgeInsets.only(
//                   left: 16.0,
//                   top: 24.0,
//                   right: 16.0,
//                 ),
//                 child: const Text(
//                   'You need to give this permission from the system settings.',
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             Container(
//               padding: const EdgeInsets.only(
//                   left: 16.0, top: 24.0, right: 16.0, bottom: 24.0),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   shape: new RoundedRectangleBorder(
//                     borderRadius: new BorderRadius.circular(30.0),
//                   ),
//                 ),
//                 child: Text(isPermanent ? 'Open settings' : 'Allow access'),
//                 onPressed:null
               
                
//                 // () => isPermanent ? openAppSettings() : onPressed(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }