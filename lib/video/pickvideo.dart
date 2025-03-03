import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_image/image/pick.dart';
import 'package:test_image/provider_storage.dart';
import 'package:test_image/video/recovervideo.dart';
import 'package:test_image/video/reels.dart';




class PickVideo extends StatefulWidget {
  const PickVideo({super.key});

  @override
  State<PickVideo> createState() => _PickVideoState();
}

class _PickVideoState extends State<PickVideo> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  int _selectedCameraIndex = 0; //control camera
  bool _isRecording = false;
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
  Future<void> _startRecording() async {
    if (_cameraController == null || _isRecording) return;
    try {
      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      print("Error starting video recording: $e");
    }
  }

  Future<void> _stopRecording(StorageProvider storage) async {
    if (_cameraController == null || !_isRecording) return;
    try {
      final videoFile = await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });

      storage.videoFile = File(videoFile.path);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RecoverVideo()),
        );
      }
    } catch (e) {
      print("Error stopping video recording: $e");
    }
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
                      ..rotateZ(_selectedCameraIndex == 1 ? 0 : 90 * (3.1415927 / 180)),
                    child: Transform.scale(
                      scale: 2,
                      child: AspectRatio(
                        aspectRatio: _cameraController!.value.aspectRatio,
                        child: CameraPreview(_cameraController!),
                      ),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.only(top: 600, left: 8.0, right: 8.0, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await storage.pickVideo();
                        if (mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => RecoverVideo()),
                          );
                        }
                      },
                      icon: Icon(Icons.video_library, size: 30),
                    ),


                    InkWell(
                      onTap: _isRecording ? () => _stopRecording(storage) : _startRecording,
                      child: Icon(
                        _isRecording ? Icons.stop : Icons.videocam,
                        size: 30,
                        color: _isRecording ? Colors.red : Colors.black,
                      ),
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
                    Navigator.push(
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