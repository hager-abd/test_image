import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_image/image/pick.dart';
import 'package:test_image/provider_storage.dart';
import 'package:test_image/video/video_player.dart';



class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<StorageProvider>(context, listen: false).getAllVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<StorageProvider>(
        builder: (context, storage, _) {
          if (storage.videoUrls == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return storage.videoUrls!.isNotEmpty
              ? PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: storage.videoUrls!.length,

            itemBuilder: (context, index) {
              int reversedIndex = storage.videoUrls!.length - 1 - index;
              return Stack(
                fit: StackFit.expand,
                children: [
                  VideoPlayerScreen(videoUrl: storage.videoUrls![reversedIndex]),
                  Positioned(
                    top:10,
                    left: 5,
                    child: InkWell(onTap: () {   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PickScreen()),
                  );},child: Icon(Icons.arrow_back_ios_sharp,size: 30,color: Colors.white,),)),
                  Positioned(
                    bottom: 45,
                    child:Row(children: [
                      IconButton(
                        icon: Icon( Icons.favorite ,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon( Icons.comment_bank_outlined,size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                          });
                        },
                      ),
                      SizedBox(width: 5,),
                      IconButton(
                        icon: Icon( Icons.arrow_circle_right_sharp,size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                          });
                        },
                      ),
                      SizedBox(
                        width: 170,
                      ),
                      IconButton(
                        icon: Icon( Icons.more_horiz,size: 30,
                        ),
                        onPressed: () {

                        },
                      ),

                    ]),)
                ],
              );
            },
          )
              : const Center(child: Text("NO videos"));
        },
      ),

    );
  }
}


