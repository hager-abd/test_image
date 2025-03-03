import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_image/provider_storage.dart';
import 'package:test_image/video/pickvideo.dart';
import 'package:test_image/video/reels.dart' ;
import 'package:test_image/video/video_player.dart';



class RecoverVideo extends StatefulWidget {
  const RecoverVideo({super.key});

  @override
  State<RecoverVideo> createState() => _RecoverVideoState();
}

class _RecoverVideoState extends State<RecoverVideo> {
  final TextEditingController _textController = TextEditingController();
  bool isUploading = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<StorageProvider>(
      builder: (context, storage, _) {
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              if (storage.videoFile != null)
                SizedBox(
                  height: 900,
                  width: 550,
                  child: VideoPlayerScreen(videoUrl: storage.videoFile!.path),
                ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            color: Colors.transparent,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () async {
                    await storage.pickVideo();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecoverVideo(),
                      ),
                    );
                  },
                  icon: Icon(Icons.video_library),
                ),


                InkWell(
                  onTap: isUploading
                      ? null
                      : () {
                    setState(() {
                      isUploading = true;
                    });

                    storage.uploadVideo(context).then((_) {
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReelsScreen(),
                          ),
                        );
                      }
                    }).whenComplete(() {
                      if (mounted) {
                        setState(() {
                          isUploading = false;
                        });
                      }
                    });
                  },
                  child: isUploading
                      ? CircularProgressIndicator()
                      : Icon(
                    Icons.arrow_circle_right_outlined,
                    size: 30,
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
