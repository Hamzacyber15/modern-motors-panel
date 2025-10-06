import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

List<CameraDescription> cameras = <CameraDescription>[];

class CameraView extends StatefulWidget {
  final bool cameraAllowed;
  final bool videoAllowed;
  const CameraView({
    required this.cameraAllowed,
    required this.videoAllowed,
    super.key,
  });
  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraController controller;
  bool enableAudio = true;
  XFile? imageFile;
  XFile? videoFile;
  String recordingStatus = '';
  bool cameraReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        cameras = await availableCameras();
        if (cameras.isEmpty) {
          if (mounted) {}
        }
        controller = CameraController(cameras[1], ResolutionPreset.max);
        controller
            .initialize()
            .then((_) {
              if (!mounted) {
                return;
              }
              setState(() {
                cameraReady = true;
              });
            })
            .catchError((Object e) {
              if (e is CameraException) {
                switch (e.code) {
                  case 'CameraAccessDenied':
                    // Handle access errors here.
                    break;
                  default:
                    // Handle other errors here.
                    break;
                }
              }
            });
      } on CameraException catch (_) {
        cameras = [];
      } catch (e) {
        cameras = [];
      }
    });
    if (cameras.isEmpty) {
      return;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void switchCamera() {
    final CameraDescription newDescription =
        controller.description == cameras[0] ? cameras[1] : cameras[0];
    final CameraController newController = CameraController(
      newDescription,
      ResolutionPreset.max,
    );
    newController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        controller = newController;
      });
    });
  }

  Future<XFile?> takePicture() async {
    final CameraController cameraController = controller;
    if (!cameraController.value.isInitialized) {
      log('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      log(e.toString());
      return null;
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          imageFile = file;
        });
        if (file != null) {
          log('Picture saved to ${file.path}');
          Navigator.of(context).pop(file);
        }
      }
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((_) {
      if (mounted) {
        setState(() {
          recordingStatus = 'Recording';
        });
      }
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((XFile? file) {
      if (mounted) {
        setState(() {
          recordingStatus = '';
        });
      }
      if (file != null) {
        log('Video recorded to ${file.path}');
        videoFile = file;
        if (mounted) {
          Navigator.of(context).pop(file);
        }
      }
    });
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) {
        setState(() {
          recordingStatus = 'Paused';
        });
      }
      log('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) {
        setState(() {
          recordingStatus = 'Recording';
        });
      }
      log('Video recording resumed');
    });
  }

  Future<void> startVideoRecording() async {
    final CameraController cameraController = controller;

    if (!cameraController.value.isInitialized) {
      log('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      log(e.toString());
      return;
    }
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController cameraController = controller;

    if (!cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    final CameraController cameraController = controller;

    if (!cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.pauseVideoRecording();
    } on CameraException catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    final CameraController cameraController = controller;

    if (!cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.resumeVideoRecording();
    } on CameraException catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: !cameraReady
          ? const Center(
              child: Text(
                "Loading Camera ...",
                style: TextStyle(color: Colors.white),
              ),
            )
          : Stack(
              children: [
                Center(child: CameraPreview(controller)),
                if (cameras.isNotEmpty)
                  Positioned(
                    bottom: 10,
                    child: SizedBox(
                      width: size.width,
                      child: recordingStatus.isEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: onVideoRecordButtonPressed,
                                  icon: const Icon(
                                    Icons.videocam_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                IconButton(
                                  onPressed: onTakePictureButtonPressed,
                                  icon: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                if (cameras.length > 1)
                                  IconButton(
                                    onPressed: switchCamera,
                                    icon: const Icon(
                                      Icons.switch_camera_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (recordingStatus == 'Recording')
                                  IconButton(
                                    onPressed: onPauseButtonPressed,
                                    icon: const Icon(
                                      Icons.pause_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                if (recordingStatus == 'Recording')
                                  IconButton(
                                    onPressed: onStopButtonPressed,
                                    icon: const Icon(
                                      Icons.stop_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                if (recordingStatus == 'Paused')
                                  IconButton(
                                    onPressed: onResumeButtonPressed,
                                    icon: const Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                              ],
                            ),
                    ),
                  ),
              ],
            ),
    );
  }
}
