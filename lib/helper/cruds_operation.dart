

import 'files.dart';
import 'file.dart';
class cruds_operation {

 bool rename_play_list_video(int p_id, video rename_video,String new_title){
      try {
        if(p_id==-1){
            // find p_id 
        }
        else{
          if(PlayList_detail().rename_playlist_video(rename_video.v_id, p_id, new_title)){
            folder_details().rename_file(rename_video.v_id, rename_video.parent_folder_id, new_title);
            return true;
          }
        }
        return true;
      } catch (e) {
        print(e);
      }
    
    return false;
  }

  bool rename_play_list_Folder(int p_id,String new_title){
    
      try {
        return PlayList_detail().rename_playlist_folder(p_id, new_title);
        
      } catch (e) {
        print(e);
      }
    
    return false;
  }

  bool rename_list_video(video videos,String new_title){


    // split the path and video
      try {
        if(true){ ///databse rename file
        if(folder_details().rename_file(videos.v_id, videos.parent_folder_id, new_title)){
            rename_play_list_video(-1,videos,new_title);
          return true;
          }
        }
        return false;
        
      } catch (e) {
        print(e);
      }
    
    return false;
  }

  bool rename_list_folder(int f_id,String new_title){
    
      try {
        if(true){ //databse rename 
          return folder_details().rename_folder(f_id, new_title);
        }
        
        return true;
      } catch (e) {
        print(e);
      }
    
    return false;
  }

  bool delete_play_list_video(int p_id,video videos){
    
    try {
      if(p_id==-1){
        PlayList_detail().Remove_by_v_id(videos.v_id);
      }
      else{
        PlayList_detail().remove_playlist_video(p_id, videos.v_id);
      }
        return true;
      } catch (e) {
        print(e);
      }
    
    return false;
  }

  bool delete_play_list_folder(int p_id){
    
      try {
        return PlayList_detail().remove_playlist_folder(p_id);
        
      } catch (e) {
        print(e);
      }
    
    return false;
  }

  bool delete_list_video(video videos){
    print("delete");
      try {
        folder_details().delete_one_file(videos);
        if(true){ /// main database delete
        // if(folder_details().delete_one_file(videos)){
        //  // delete_play_list_video(-1,videos);
        //    return true;
        // }
        }
        return false;
       
      } catch (e) {
        print(e);
      }
    
    return false;
  }

  bool delete_list_Folder(int f_id){
    
      try {
      List< video> videos= folder_details().getfolderIdvideo(f_id);
      if(true) {// main data
        if(folder_details().deleteFolder(f_id)){
            videos.forEach((element) { delete_play_list_video(-1,element); });
             return true;
        }
      }
        return false;
      } catch (e) {
        print(e);
      }
    
    return false;
  }


}

