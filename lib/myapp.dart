import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_image/image/pick.dart';
import 'package:test_image/provider_storage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create:(context)=>StorageProvider()..getAllImages() ,
      child:  MaterialApp(
        title: 'Flutter Demo',
        home: PickScreen(),
      ),
    );
  }
}