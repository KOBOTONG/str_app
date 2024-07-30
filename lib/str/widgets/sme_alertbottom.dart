import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:srt_app/str/constants/color_constants.dart';
import 'package:srt_app/str/page/camera_page.dart';

void SMEAlertBottom({
  required BuildContext context,
  required String? message,
  double size = 22,
  required void Function() onTap,
}) {
  showModalBottomSheet<void>(
    
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 34),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Wrap(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 400,
              // height:200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('$message',
                      style: const TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: onTap,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 5, 10),
                        child: GestureDetector(
                          child: Container(
                            height: 60,
                            width: Get.width * 1,
                            // constraints: BoxConstraints(maxWidth: 80),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  // icon pin location
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, bottom: 15),
                                    child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(16),
                                          ),
                                        ),
                                        child: Icon(
                                          FontAwesomeIcons.train,
                                          color: Colors.red[700],
                                          size: 19,
                                        )),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                    top: 8,
                                    right: 8,
                                    bottom: 8,
                                    left: 70,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      // "Location",
                                              
                                      "สถานีรถไฟตลิ่งชัน",
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
        
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
