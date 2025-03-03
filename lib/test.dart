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
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          )
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
