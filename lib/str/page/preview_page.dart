import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:srt_app/str/constants/color_constants.dart';
import 'package:srt_app/str/controller/user_controller.dart';
import 'package:srt_app/str/page/home_user_page.dart';
import 'package:srt_app/str/widgets/sme_alertdialog.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({
    Key? key,
    required this.image,
    required this.branchLatitude,
    required this.branchLongtitude,
    required this.branchId,
  }) : super(key: key);

//     Key? key, required this.image}) : super(key: key);
  final XFile? image;
  final double branchLatitude;
  final double branchLongtitude;
  final String branchId;
  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  var userController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'รูปภาพ',
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
            icon: const Icon(Icons.save),
            color: Colors.white,
            onPressed: () {
              int sizeInBytes = File(widget.image!.path).lengthSync();
              // re
              print(sizeInBytes);
              if (sizeInBytes > 2097152) {
                Get.dialog(
                  SMEAlertDialog(
                    titleMessage: "แจ้งเตือน",
                    contentMessage: "ไฟล์ภาพมีขนาดใหญ่กว่าที่กำหนด",
                    submitButton: true,
                    submitText: "ตกลง",
                    onSubmit: () {
                      Get.back();
                    },
                  ),
                );
              } else {
                Get.dialog(
                  SMEAlertDialog(
                    titleMessage: "บันทึกข้อมูล! โปรดยืนยันอีกครั้ง",
                    cancelButton: true,
                    cancelText: "ยกเลิก",
                    onCancel: () {
                      Get.back();
                      Get.back();
                    },
                    submitButton: true,
                    submitText: "บันทึกข้อมูล",
                    onSubmit: () {
                      userController
                          .saveTimeStamp(
                              latitude: widget.branchLatitude,
                              longitude: widget.branchLongtitude,
                              branchId: widget.branchId,
                              imgTimeStamp: File(widget.image!.path))
                          .then((value) {
                        if (value['success'].toString() == "true") {
                          Get.dialog(
                            SMEAlertDialog(
                              titleMessage: "แจ้งเตือน",
                              contentMessage: "บันทึกข้อมูล",
                              submitButton: true,
                              submitText: "ตกลง",
                              onSubmit: () {
                                Get.offAll(HomeUserPage());
                              },
                            ),
                          );
                        } else {
                          Get.dialog(
                            SMEAlertDialog(
                              titleMessage: "แจ้งเตือน",
                              contentMessage: "${value['message'].toString()}",
                              submitButton: true,
                              submitText: "ตกลง",
                              onSubmit: () {
                                Get.back();
                              },
                            ),
                          );
                        }
                      });
                    },
                  ),
                  barrierDismissible: false,
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Image.file(File(widget.image!.path)),
      ),
    );
  }
}
