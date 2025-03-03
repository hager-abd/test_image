import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_image/provider_storage.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StorageProvider>(builder: (context, storage, _) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Images'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 580,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: storage.media.length,
                  itemBuilder: (context, index) {
                    final mediaItem = storage.media.reversed.toList()[index];

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(mediaItem.toString()),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          Row(
                            children: [

                              InkWell(
                                onTap: () {

                                },
                                child: CircleAvatar(
                                  radius: 20,
                                  child: Container(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[50],
                                    ),
                                    child: Image.asset(
                                      Theme.of(context).brightness == Brightness.dark
                                          ? "assets/images/icon_comment_dark.jpg"
                                          : "assets/images/comment.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),

                              InkWell(
                                onTap: () {

                                },
                                child: CircleAvatar(
                                  radius: 15,
                                  child: Container(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: BoxDecoration(color: Colors.grey[50]),
                                    child: Image.asset(
                                      Theme.of(context).brightness == Brightness.dark
                                          ? "assets/images/share_dark.jpg"
                                          : "assets/images/instagram-share-icon.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),


                              InkWell(
                                onTap: () {

                                },
                                child: CircleAvatar(
                                  radius: 15,
                                  child: Container(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: BoxDecoration(color: Colors.grey[50]),
                                    child: Image.asset(
                                      Theme.of(context).brightness == Brightness.dark
                                          ? "assets/images/save_dark.jpg"
                                          : "assets/images/instagram-save-icon.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 8),

                          Text(
                            "100 Likes",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),



                          Divider(color: Colors.grey.shade300, thickness: 1),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
