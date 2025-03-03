import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_image/video/pickvideo.dart';
import 'package:test_image/provider_storage.dart';
import 'package:test_image/image/recoverphoto.dart';
import 'package:test_image/video/reels.dart';




class PickScreen extends StatefulWidget {
  const PickScreen({super.key});

  @override
  State<PickScreen> createState() => _PickScreenState();
}

class _PickScreenState extends State<PickScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  int _selectedCameraIndex = 0; //control camera

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![_selectedCameraIndex],
          ResolutionPreset.high,
        );
        await _cameraController!.initialize();
        if (!mounted) return;
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  Future<void> _transferCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    _selectedCameraIndex = _selectedCameraIndex == 0 ? 1 : 0;

    await _cameraController?.dispose();
    await _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageProvider>(
      builder: (context, storage, _) {
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              if (_isCameraInitialized && _cameraController != null)
                Center(
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateZ(_selectedCameraIndex == 1 ? 0 : 90 * (3.1415927 / 180)), // تدوير إذا لزم الأمر
                    child: Transform.scale(
                      scale: 2,
                      child: AspectRatio(
                        aspectRatio: _cameraController!.value.aspectRatio,
                        child: CameraPreview(_cameraController!),
                      ),
                    ),
                  ),
                ),
              // CameraPreview(_cameraController!),
              Padding(
                padding: const EdgeInsets.only(top: 600, left: 8.0, right: 8.0, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await storage.pickImage();
                        if (mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => RecoverScreen()),
                          );
                        }
                      },
                      icon: Icon(Icons.image, size: 30),
                    ),


                    InkWell(
                      onTap: () async {
                        try {
                          final image = await _cameraController!.takePicture();
                          storage.imageFile = File(image.path);
                          if (mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => RecoverScreen()),
                            );
                          }
                        } catch (e) {
                          print("Error capturing image: $e");
                        }
                      },
                      child: Icon(Icons.camera_alt, size: 30, color: Colors.black),
                    ),
                    InkWell(
                      onTap: _transferCamera,
                      child: Icon(Icons.cameraswitch_rounded, size: 30, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            color: Colors.transparent,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => PickVideo()),
                    );
                  },
                  child: Text(
                    "Video",
                    style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 40),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => PickScreen()),
                    );
                  },
                  child: Text(
                    "Photo",
                    style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 40),
          InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReelsScreen()),
            );
          },
          child: Text(
            "Reels",
            style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
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