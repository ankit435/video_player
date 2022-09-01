

import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

enum VideoSection {
  noStoragePermission, // Permission denied, but not forever
  noStoragePermissionPermanent, // Permission denied forever
  browseFiles, // The UI shows the button to pick files
}

class permissions_handler with ChangeNotifier{

  VideoSection _videoSection = VideoSection.browseFiles;
  
  VideoSection get videoSection => _videoSection;
  late PermissionStatus result;

  set videoSection(VideoSection value) {
    if (value != _videoSection) {
       _videoSection = value;
      notifyListeners();
    }
  }



  Future<void> check_permission() async{
    result= await Permission.manageExternalStorage.request();
    if (result.isPermanentlyDenied) {
      videoSection = VideoSection.noStoragePermissionPermanent;
    } else if(result.isDenied) {
      videoSection = VideoSection.noStoragePermission;
    }
  }



  Future<void> requestFilePermission() async {
    result= await Permission.manageExternalStorage.request();
    if (result.isGranted) {
      videoSection = VideoSection.browseFiles;
    } else if (result.isPermanentlyDenied) {
      videoSection = VideoSection.noStoragePermissionPermanent;
    } else {
      videoSection = VideoSection.noStoragePermission;
    }
  
}




}