

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// This enum will manage the overall state of the app
enum VideoSection {
  noStoragePermission, // Permission denied, but not forever
  noStoragePermissionPermanent, // Permission denied forever
  browseFiles,
  loadeVideo, // The UI shows the button to pick files
}

class ImageModel extends ChangeNotifier {

  VideoSection _videoSection = VideoSection.browseFiles; // Permission denied, but not forever

  
  VideoSection get videoSection => _videoSection;

  late PermissionStatus result;


  set videoSection(VideoSection value) {
    if (value != _videoSection) {
      _videoSection = value;
      notifyListeners();
    }
  }


  Future<bool> check_permission() async{
  result= await Permission.storage.status;
  
   if(result.isDenied){
      videoSection = VideoSection.noStoragePermission; 
      return false;
    }
    else if(result.isPermanentlyDenied){
       videoSection = VideoSection.noStoragePermissionPermanent;
      return false;
    }

    return true;
  }

  Future<bool> requestFilePermission() async {
    //print(videoSection);
    result= await Permission.manageExternalStorage.request();
    
    if (result.isGranted) {
      videoSection = VideoSection.browseFiles;
      return true;
    } else if (result.isPermanentlyDenied) {
      videoSection = VideoSection.noStoragePermissionPermanent;
    } else {
      videoSection = VideoSection.noStoragePermission;
    }
    return false;
  
}


}