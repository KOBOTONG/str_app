import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:srt_app/str/constants/color_constants.dart';
import 'package:srt_app/str/widgets/loading.dart';
import 'package:image_picker/image_picker.dart';

class SRTController extends GetxController {
  var pageSelected = 0.obs;
  var technicianJobSelected = 0.obs;
  var userJobSelected = 0.obs;
  var userProfilePicture = Rx<Widget>(const SizedBox.shrink());

  XFile? selectedImage;

  final ImagePicker _imagePicker = ImagePicker();

  Future<XFile?> getImageFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.rear,
    );
    selectedImage = image;
    return image;
  }
  // Loading
  void showDialogLoading() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: SMELoading(
              dotOneColor: primaryColor.shade400,
              dotTwoColor: primaryColor,
              dotThreeColor: primaryColor.shade600,
            ),
          ),
        );
      },
    );
  }

  
}
