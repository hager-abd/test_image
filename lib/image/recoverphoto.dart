import 'dart:io';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:test_image/provider_storage.dart';
import 'package:test_image/test.dart';

class RecoverScreen extends StatefulWidget {
  const RecoverScreen({super.key});

  @override
  State<RecoverScreen> createState() => _RecoverScreenState();
}

class _RecoverScreenState extends State<RecoverScreen> {
  TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<StorageProvider>(builder: (context, storage, _) {
      return Scaffold(
        body: Stack(
          fit: StackFit.expand,
            children: [
              storage.imageFile != null ? Container(
                height: 900,
                width: 550,
                child: Image.file(storage.imageFile!),
              ) : SizedBox(),


          ],
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () {
                storage.pickImage();
              }, icon: Icon(Icons.image)),
              InkWell(
                  onTap: () {
                    storage.uploadImage(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TestScreen(),
                      ),
                    );
                  },
                  child: Icon(Icons.arrow_circle_right_outlined,size: 30,)),


            ],),
        ),
      );
    });
  }
}