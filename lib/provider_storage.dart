import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageProvider extends ChangeNotifier{

  File? imageFile;
  File? videoFile;
  List<String>? videoUrls;
  final ImagePicker imagePicker = ImagePicker();
  List<String> videos = [];
  List<String>media = [];


  Future<void>pickImage()async{
    final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    print("successful pick image");
    if(image !=null){
      imageFile = File(image.path);
      notifyListeners();
    }
    notifyListeners();
  }


  Future<void> uploadImage(BuildContext context, {String? caption}) async {
    try {
      if (imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No image to upload')),
        );
        return;
      }

      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final path = 'uploads/$fileName';

      await Supabase.instance.client.storage.from('network').upload(path, imageFile!);

      final imageUrl = Supabase.instance.client.storage.from('network').getPublicUrl(path);

      media.add(imageUrl);


      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image uploaded successfully')),
      );

      print("Upload image successfully: $imageUrl");

    } catch (e) {
      print("Upload error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image')),
      );
    }
  }

  Future<List<String>> getAllImages() async {
    try {
      final response = await Supabase.instance.client.storage.from('network').list(path: 'uploads');
      if (response != null) {
        media = response.map((file) {
          return Supabase.instance.client.storage.from('network').getPublicUrl('uploads/${file.name}');
        }).toList();


        print('Media: $media');

        notifyListeners();
        return media;
      }
    } catch (e) {
      print(e);
      notifyListeners();
      return [];
    }
    notifyListeners();
    return [];
  }
  Future<void> pickVideo() async {
    final XFile? video = await imagePicker.pickVideo(source: ImageSource.gallery);
    print("Video picked successfully");
    if (video != null) {
      videoFile = File(video.path);
      notifyListeners();
    }
    notifyListeners();
  }
  Future<void> uploadVideo(BuildContext context) async {
    try {
      if (videoFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No video to Upload')),
        );
        return;
      }

      final fileName = "${DateTime.now().millisecondsSinceEpoch}.mp4";
      final path = 'uploads/videos/$fileName';

      await Supabase.instance.client.storage.from('network').upload(path, videoFile!);

      final videoUrl = Supabase.instance.client.storage.from('network').getPublicUrl(path);

      videos.add(videoUrl);
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video Uploaded Successfully')),
      );
    } catch (e) {
      print(" Error uploading video: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload video')),
      );
    }
  }

  Future<void> getAllVideos() async {
    try {
      final response = await Supabase.instance.client.storage.from('network').list(path: 'uploads/videos');

      if (response.isNotEmpty) {
        videos = response
            .where((file) => file.name.endsWith('.mp4'))
            .map((file) => Supabase.instance.client.storage.from('network').getPublicUrl('uploads/videos/${file.name}'))
            .toList();

        videoUrls = List.from(videos);
        notifyListeners();
      } else {
        print('Error: No videos found.');
      }
    } catch (e) {
      print("Error fetching videos: $e");
    }
  }


}