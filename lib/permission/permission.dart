import 'dart:io';

import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';


import '../properties/bottom_navigation.dart';
import 'imge.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> with WidgetsBindingObserver {
  late final ImageModel _model;
  bool _detectPermission = false;
  bool hasFilePermission=false;
 
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _model = ImageModel();
    


  }


Future<void> didChangeDependencies() async {
  // print("hi");
   hasFilePermission=await _model.requestFilePermission();
  // print(hasFilePermission);
  super.didChangeDependencies();
}

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _detectPermission &&
        (_model.videoSection == VideoSection.noStoragePermissionPermanent)) {
      _detectPermission = false;
      _model.requestFilePermission();
    } else if (state == AppLifecycleState.paused &&
        _model.videoSection == VideoSection.noStoragePermissionPermanent) {
      _detectPermission = true;
    }
    
  }

  

  @override
  Widget build(BuildContext context) {
  
     
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<ImageModel>(
        builder: (context, model, child)  {
          Widget widget;

          switch (model.videoSection) {
            case VideoSection.noStoragePermission:
              widget = ImagePermissions(
                  isPermanent: false, onPressed: _checkPermissionsAndPick);
              break;
            case VideoSection.noStoragePermissionPermanent:
              widget = ImagePermissions(
                  isPermanent: true, onPressed: _checkPermissionsAndPick);
              break;
            case VideoSection.browseFiles:
              widget =  !hasFilePermission?Bottomnavigation(): ImagePermissions(
                  isPermanent: true, onPressed: _checkPermissionsAndPick);
              break;
          }
          return widget;
        },
      ),
    );
  }

  Future<void> _checkPermissionsAndPick()  async{
     final hasFilePermission = await _model.requestFilePermission();
     print(hasFilePermission);
    // if (hasFilePermission) FlutterDemo(title: "Lol", storage: Storage());
    // print("ready to player");
    // return hasFilePermission;
  }
}

class ImagePermissions extends StatelessWidget {
  final bool isPermanent;
  final VoidCallback onPressed;

  const ImagePermissions({
    Key? key,
    required this.isPermanent,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VIdeo'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 16.0,
                top: 24.0,
                right: 16.0,
              ),
              child: Text(
                'Read files permission',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 16.0,
                top: 24.0,
                right: 16.0,
              ),
              child: const Text(
                'We need to request your permission to read '
                'local files in order to load it in the app.',
                textAlign: TextAlign.center,
              ),
            ),
            if (isPermanent)
              Container(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  top: 24.0,
                  right: 16.0,
                ),
                child: const Text(
                  'You need to give this permission from the system settings.',
                  textAlign: TextAlign.center,
                ),
              ),
            Container(
              padding: const EdgeInsets.only(
                  left: 16.0, top: 24.0, right: 16.0, bottom: 24.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(isPermanent ? 'Open settings' : 'Allow access'),
                onPressed: () => isPermanent ? openAppSettings() : onPressed(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





















class PickFile extends StatelessWidget {
  final VoidCallback onPressed;

  const PickFile({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: ElevatedButton(
          child: const Text('Allow access'),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
                
                shape: new RoundedRectangleBorder(

                  borderRadius: new BorderRadius.circular(30.0),
                ),
              ),
        ),
      );
}

/// This widget is used once permission has
/// been granted and a file has been selected.
/// Load the image and display it in the center.
class ImageLoaded extends StatelessWidget {
  final File file;

  const ImageLoaded({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 196.0,
        height: 196.0,
        child: ClipOval(
          child: Image.file(
            file,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
