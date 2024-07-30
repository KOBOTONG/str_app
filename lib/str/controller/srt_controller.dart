import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:srt_app/str/constants/color_constants.dart';
import 'package:srt_app/str/widgets/loading.dart';
import 'package:image_picker/image_picker.dart';

class SRTController extends GetxController {
  // Bottom Navigation
  var pageSelected = 0.obs;

  // Technician Job Page
  var technicianJobSelected = 0.obs;

  // User Job Page
  var userJobSelected = 0.obs;

  var userProfilePicture = Rx<Widget>(const SizedBox.shrink());

  // Localstorage




 
  // Upload Image - Technician Create Profile


  // Image Picker
  final ImagePicker _imagePicker = ImagePicker();

  Future<XFile?> getImageFromGallery() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<XFile?> getImageFromCamera() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.camera);
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
