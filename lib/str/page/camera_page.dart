import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:srt_app/str/constants/color_constants.dart';
import 'package:srt_app/str/controller/srt_controller.dart';
import 'package:srt_app/str/controller/user_controller.dart';
import 'package:srt_app/str/widgets/loading.dart';

import 'preview_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    Key? key,
    required this.cameras,
    required this.branchLatitude,
    required this.branchLongtitude,
    required this.branchId,
  }) : super(key: key);

  final List<CameraDescription> cameras;
  final double branchLatitude;
  final double branchLongtitude;
  final String branchId;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  var srtController = Get.put(SRTController());
  var userController = Get.put(UserController());
  late CameraController _cameraController;
  late CameraDescription _currentCamera;
  XFile? _capturedImage;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _currentCamera = widget.cameras[0];
    initCamera(_currentCamera);
  }

  Future<void> switchCamera() async {
    final lensDirection = _currentCamera.lensDirection;
    CameraDescription newCamera;

    if (lensDirection == CameraLensDirection.front) {
      newCamera = widget.cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back);
    } else {
      newCamera = widget.cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front);
    }

    setState(() {
      _currentCamera = newCamera;
    });

    await initCamera(newCamera);
  }

  Future<void> takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return;
    }
    if (_cameraController.value.isTakingPicture) {
      return;
    }

    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();
      srtController.selectedImage = picture;
      setState(() {
        _capturedImage = picture;
      });
      Get.to(() => PreviewPage(
            image: _capturedImage!,
            branchLatitude: widget.branchLatitude,
            branchLongtitude: widget.branchLongtitude,
            branchId: '${widget.branchId}',
          ));
    } on CameraException catch (e) {
      debugPrint('Error occurred while taking picture: $e');
    }
  }

  Future<void> initCamera(CameraDescription cameraDescription) async {
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _cameraController.initialize();
      if (!mounted) return;
      setState(() {});
    } on CameraException catch (e) {
      debugPrint("Camera error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "ถ่ายภาพ",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            color: Colors.white,
            onPressed: switchCamera,
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          (_cameraController.value.isInitialized)
              ? CameraPreview(_cameraController)
              : Container(
                  color: Colors.black,
                  child: Center(
                    child: SMELoading(
                      dotOneColor: primaryColor.shade400,
                      dotTwoColor: primaryColor,
                      dotThreeColor: primaryColor.shade600,
                    ),
                  ),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Get.height * 0.2,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                color: Colors.black,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.image, color: Colors.black),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: takePicture,
                      child: const Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Icon(
                            Icons.circle,
                            color: Colors.white,
                            size: 60,
                          ),
                          Icon(
                            Icons.circle,
                            color: Colors.black,
                            size: 58,
                          ),
                          Icon(
                            Icons.circle,
                            color: Colors.white,
                            size: 52,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class ImagePreview extends StatelessWidget {
//   final XFile image;

//   const ImagePreview({Key? key, required this.image}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: const Text(
//           'Preview Image',
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         leading: GestureDetector(
//           onTap: () {
//             Get.back();
//           },
//           child: const Icon(
//             Icons.arrow_back_ios_new,
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             color: Colors.white,
//             onPressed: () {
//               userController
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: Image.file(File(image.path)),
//       ),
//     );
//   }
// }
