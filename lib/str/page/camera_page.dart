import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:srt_app/str/constants/color_constants.dart';
import 'package:srt_app/str/controller/srt_controller.dart';
import 'package:srt_app/str/page/home_user_page.dart';
import 'package:srt_app/str/widgets/loading.dart';
import 'package:srt_app/str/widgets/sme_alertbottom.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  var srtController = Get.put(SRTController());

  late CameraController _cameraController;
  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras[0]);
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }

    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();
      if (picture != true) {
        SMEAlertBottom(
            context: context,
            message: '$picture',
            onTap: () async {
              Get.to(HomeUserPage());
            });
      }
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
    );

    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
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
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          (_cameraController.value.isInitialized)
              ? CameraPreview(
                  _cameraController,
                )
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

          // Padding(
          //   padding: const EdgeInsets.fromLTRB(20, 250, 20, 0),
          //   child: Container(
          //     height: Get.height * 0.3,
          //     decoration: BoxDecoration(
          //       border: Border.all(color: Colors.black, width: 2),
          //       borderRadius: BorderRadius.all(Radius.circular(20.0)),
          //     ),
          //   ),
          // ),
          // ),
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
                    child: Icon(
                      Icons.image,
                      color: Colors.black,
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
