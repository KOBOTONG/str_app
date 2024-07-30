import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:srt_app/str/constants/color_constants.dart';
import 'package:intl/intl.dart';
import 'package:srt_app/str/controller/authen_controller.dart';
import 'package:srt_app/str/controller/server_controller.dart';
import 'package:srt_app/str/page/camera_page.dart';
import 'package:srt_app/str/page/login_page.dart';
import 'package:srt_app/str/widgets/loading.dart';
import 'package:srt_app/str/widgets/sme_alertbottom.dart';
import 'package:srt_app/str/widgets/sme_horizontal_calendar.dart';
import 'package:camera/camera.dart';

class HomeUserPage extends StatefulWidget {
  const HomeUserPage({super.key});

  @override
  State<HomeUserPage> createState() => _HomeUserPageState();
}

// late double _scrollAlignment;

class _HomeUserPageState extends State<HomeUserPage> {
  _HomeUserPageState() {
    serverController.checkPermission();
    serverController
        .fetchServerTime()
        .then((value) => {_loading.value = false});
  }
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  StreamSubscription<Position>? positionStreamSubscription;
  late double lng;
  late double log;
  late double tarketPosition;
  final _loading = true.obs;
  var authenController = Get.put(AuthenController());
  var serverController = Get.put(ServerController());
  Position? currentPosition;
  @override
  void dispose() {
    positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _scrollAlignment = 10 / MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:  const BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomLeft,
                        // stops: [0.3,0.6],
                        colors: [primaryColor, primaryColor],
                      ),
                    ),
                    margin: const EdgeInsets.only(bottom: 25),
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppBar(
                          automaticallyImplyLeading: false,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          actions: [
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const LoginPage());
                              },
                              child: Stack(
                                children: <Widget>[
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 13, 10),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          // color: primaryColor.shade400,
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.logout_sharp,
                                            color: Colors.white,
                                            size: 26,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child: Row(
                            children: [
                              Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50.0)),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                                child: ClipOval(
                                    child:
                                        Image.asset('assets/logo/logo_srt.png')
                                    //  Ima(
                                    //   height: Get.width / 4,
                                    // ),
                                    ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ยินดีต้อนรับ,",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "นายพัฒธรวี ศรีสิริวัฒน์",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        _loading.value
                            ? const SizedBox(height: 100)
                            : Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: SizedBox(
                                  height: 100,
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: RichText(
                                      text: TextSpan(
                                        text:
                                            "วันที่ ${DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(serverController
                                                  .serverTimeModel.value.data ??
                                              ""),
                                        )}",
                                        style: const TextStyle(
                                            fontFamily: 'Prompt-SemiBold',
                                            color: Colors.white),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  " ${DateFormat('HH:mm').format(
                                                DateTime.parse(serverController
                                                    .serverTimeModel
                                                    .value
                                                    .data!),
                                              )}",
                                              style: const TextStyle(
                                                  fontSize: 28,
                                                  fontFamily: 'Prompt-SemiBold',
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 120,
                        // height: 210,
                        child: Card(
                          shape: setRoundedBorder(Colors.white, 10),
                          color: Colors.white,
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 70,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  // serverController
                                                  //     .checkPermission()
                                                  //     .then((value) {
                                                  //   if (value) {
                                                  //     Geolocator.getPositionStream(
                                                  //             locationSettings:
                                                  //                 locationSettings)
                                                  //         .listen((Position?
                                                  //             position) {
                                                  //       currentPosition =
                                                  //           position;
                                                  //       print(currentPosition);
                                                  // SMEAlertBottom(
                                                  //     context: context,
                                                  //     message:
                                                  //         'เลือกสาขาเข้างาน',
                                                  //     onTap: () async {
                                                  //       final cameras =
                                                  //           await availableCameras();
                                                  //       Get.offAll(() =>
                                                  //           CameraPage(
                                                  //             cameras:
                                                  //                 cameras,
                                                  //           ));
                                                  //     });
                                                  //     });
                                                  //   } else if (value == false) {
                                                  //     AppSettings
                                                  //         .openAppSettings();
                                                  //   }
                                                  // });
                                                  positionStreamSubscription
                                                      ?.cancel();

                                                  // ตรวจสอบสิทธิ์
                                                  bool permissionGranted =
                                                      await serverController
                                                          .checkPermission();
                                                  if (permissionGranted) {
                                                    // เริ่มฟังตำแหน่งจาก Stream
                                                    positionStreamSubscription =
                                                        Geolocator.getPositionStream(
                                                                locationSettings:
                                                                    locationSettings)
                                                            .listen((Position?
                                                                position) {
                                                      currentPosition =
                                                          position;
                                                      print(currentPosition);

                                                      // แสดง dialog
                                                      SMEAlertBottom(
                                                          context: context,
                                                          message:
                                                              'เลือกสาขาเข้างาน',
                                                          onTap: () async {
                                                            final cameras =
                                                                await availableCameras();
                                                            Get.offAll(() =>
                                                                CameraPage(
                                                                  cameras:
                                                                      cameras,
                                                                ));
                                                          });
                                                    });
                                                  } else {
                                                    AppSettings
                                                        .openAppSettings();
                                                  }
                                                },
                                                child: Container(
                                                  height: 60,
                                                  width: Get.width * 0.75,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFFFC452),
                                                    border: Border.all(
                                                        color: Colors.white),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(16),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                          FluentIcons
                                                              .clock_24_filled,
                                                          color: primaryColor),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text(
                                                        "เข้างาน",
                                                        overflow:
                                                            TextOverflow.fade,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          color: primaryColor,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: SMEHorizontalCalendar(selectedColor: primaryColor),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "เข้า",
                            style: TextStyle(fontSize: 18),
                          ),
                          Container(
                            height: 45,
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              color: Colors.grey.shade100,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "-",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.schedule,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "ออก",
                            style: TextStyle(fontSize: 18),
                          ),
                          Container(
                            height: 45,
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              color: Colors.grey.shade100,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "-",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.schedule,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: ImageSlideshow(
                  width: Get.width,
                  height: 150,
                  indicatorColor: primaryColor,
                  autoPlayInterval: 5000,
                  isLoop: true,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/logo/รฟท.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/logo/125272223_4064613270220180_8292867010662783841_n.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
