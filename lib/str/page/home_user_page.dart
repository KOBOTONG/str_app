import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartrefresh/smartrefresh.dart';
import 'package:srt_app/str/constants/color_constants.dart';
import 'package:intl/intl.dart';
import 'package:srt_app/str/controller/authen_controller.dart';
import 'package:srt_app/str/controller/server_controller.dart';
import 'package:srt_app/str/controller/srt_controller.dart';
import 'package:srt_app/str/controller/user_controller.dart';
import 'package:srt_app/str/page/camera_page.dart';
import 'package:srt_app/str/page/login_page.dart';
import 'package:srt_app/str/widgets/sme_horizontal_calendar.dart';
import 'package:camera/camera.dart';

class HomeUserPage extends StatefulWidget {
  const HomeUserPage({super.key});

  @override
  State<HomeUserPage> createState() => _HomeUserPageState();
}

late double _scrollAlignment;

class _HomeUserPageState extends State<HomeUserPage>
    with SingleTickerProviderStateMixin {
  _HomeUserPageState() {
    userController.fetchBranch();
    userController.fetchTimeStamp().then((value) {
      _loading.value = false;
      isIn1AtNull =
          userController.userTimeStampModel.value.data?.in_1At == null;
      isOut1AtNull =
          userController.userTimeStampModel.value.data?.out_1At == "-";
      if (!isIn1AtNull && !isOut1AtNull) {
        containerColor = Colors.grey;
        textColor = Colors.white;
        displayText = "ครบเวลา";
        isTap = false;
      } else if (isIn1AtNull) {
        containerColor = Color(0xFFFFC452);
        textColor = primaryColor;
        displayText = "เข้างาน";
      } else {
        containerColor = primaryColor;
        textColor = Color(0xFFFFC452);
        displayText = "ออกงาน";
      }
    });
    serverController.checkPermission();
    serverController
        .fetchServerTime()
        .then((value) => {_loading.value = false});
  }
  bool _isBottomSheetVisible = false;

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  StreamSubscription<Position>? positionStreamSubscription;
  final RefreshController _refreshController = RefreshController();
  void onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    userController
        .fetchTimeStamp()
        .then((value) => _refreshController.refreshCompleted());
  }

  // late double lng;
  // late double log;
  late double targetLat;
  late double targetLong;
  late String targetBranceId;
  late double tarketPosition;
  final _loading = true.obs;
  bool isIn1AtNull = true;
  bool isOut1AtNull = true;
  bool isTap = true;

  Color? containerColor;
  Color? textColor;
  String? displayText;

  var authenController = Get.put(AuthenController());
  var userController = Get.put(UserController());
  var srtController = Get.put(SRTController());
  var serverController = Get.put(ServerController());
  Position? currentPosition;
  @override
  void dispose() {
    positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scrollAlignment = 10 / MediaQuery.of(context).size.width;
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
                      borderRadius: const BorderRadius.only(
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
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                prefs.setString("remember_username", "");
                                prefs.setString("remember_password", "");

                                Get.offAll(() => const LoginPage());
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "ยินดีต้อนรับ,",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      authenController.loginModel.value.data
                                              ?.userInfo?.name ??
                                          "",
                                      style: const TextStyle(
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
                              SizedBox(
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
                                            child: SizedBox(
                                              height: 70,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 10),
                                                            child:
                                                                GestureDetector(
                                                              onTap: isTap
                                                                  ? () async {
                                                                      await positionStreamSubscription
                                                                          ?.cancel();

                                                                      bool
                                                                          permissionGranted =
                                                                          await serverController
                                                                              .checkPermission();
                                                                      if (permissionGranted) {
                                                                        positionStreamSubscription = Geolocator
                                                                            .getPositionStream(
                                                                          locationSettings:
                                                                              locationSettings,
                                                                        ).listen((Position?
                                                                            position) async {
                                                                          currentPosition =
                                                                              position;

                                                                          double
                                                                              userLatitude =
                                                                              13.802555;
                                                                          double
                                                                              userLongitude =
                                                                              100.324303;

                                                                          List<String>
                                                                              nearbyStations =
                                                                              [];
                                                                          List<dynamic> stations = userController
                                                                              .stationsModel
                                                                              .value
                                                                              .data!
                                                                              .map((e) {
                                                                            return {
                                                                              'latitude': e!.stationLatitude != null ? double.parse(e.stationLatitude!) : 0.0,
                                                                              'longitude': e.stationLongitude != null ? double.parse(e.stationLongitude!) : 0.0,
                                                                              'radius': e.stationLocationRadius != null ? double.parse(e.stationLocationRadius!) : 0.0,
                                                                              'name': e.stationThName ?? '',
                                                                              'branchId': e.stationId ?? '',
                                                                            };
                                                                          }).toList();

                                                                          // ตรวจสอบสถานีที่อยู่ใกล้
                                                                          for (var station
                                                                              in stations) {
                                                                            double
                                                                                stationLatitude =
                                                                                station['latitude'];
                                                                            double
                                                                                stationLongitude =
                                                                                station['longitude'];
                                                                            double
                                                                                radius =
                                                                                station['radius'];

                                                                            double
                                                                                distance =
                                                                                Geolocator.distanceBetween(
                                                                              userLatitude,
                                                                              userLongitude,
                                                                              stationLatitude,
                                                                              stationLongitude,
                                                                            );

                                                                            if (distance <=
                                                                                radius) {
                                                                              setState(() {
                                                                                targetBranceId = station['branchId'];
                                                                                targetLat = station['latitude'];
                                                                                targetLong = station['longitude'];
                                                                                print(targetBranceId);
                                                                              });

                                                                              print("Distance to ${station['branchId']}: ${distance} meters");
                                                                              nearbyStations.add(station['name']);
                                                                            }
                                                                          }

                                                                          // แสดง Modal Bottom Sheet หากยังไม่มีการแสดง
                                                                          if (nearbyStations
                                                                              .isNotEmpty) {
                                                                            if (!_isBottomSheetVisible) {
                                                                              _isBottomSheetVisible = true; // ตั้งค่าสถานะว่า Bottom Sheet กำลังแสดงอยู่
                                                                              showModalBottomSheet(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return Container(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 34),
                                                                                    decoration: const BoxDecoration(
                                                                                      color: Colors.white,
                                                                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                                    ),
                                                                                    child: Wrap(
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          width: MediaQuery.of(context).size.width,
                                                                                          child: Column(
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            children: <Widget>[
                                                                                              const Text(
                                                                                                'เลือกสถานีรถไฟใกล้คุณ',
                                                                                                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                              ...nearbyStations
                                                                                                  .map((stationName) => Padding(
                                                                                                        padding: const EdgeInsets.fromLTRB(16, 20, 5, 10),
                                                                                                        child: GestureDetector(
                                                                                                          onTap: () async {
                                                                                                            final cameras = await availableCameras();
                                                                                                            Get.to(CameraPage(
                                                                                                              cameras: cameras,
                                                                                                              branchId: targetBranceId,
                                                                                                              branchLatitude: targetLat,
                                                                                                              branchLongtitude: targetLong,
                                                                                                            ));
                                                                                                          },
                                                                                                          child: Container(
                                                                                                            height: 60,
                                                                                                            width: Get.width * 1,
                                                                                                            decoration: BoxDecoration(
                                                                                                              color: primaryColor,
                                                                                                              borderRadius: const BorderRadius.all(
                                                                                                                Radius.circular(16),
                                                                                                              ),
                                                                                                            ),
                                                                                                            child: Stack(
                                                                                                              children: [
                                                                                                                Align(
                                                                                                                  alignment: Alignment.bottomLeft,
                                                                                                                  child: Padding(
                                                                                                                    padding: const EdgeInsets.only(left: 15.0, bottom: 15),
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
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                Padding(
                                                                                                                  padding: const EdgeInsets.only(
                                                                                                                    top: 8,
                                                                                                                    right: 8,
                                                                                                                    bottom: 8,
                                                                                                                    left: 70,
                                                                                                                  ),
                                                                                                                  child: Align(
                                                                                                                    alignment: Alignment.centerLeft,
                                                                                                                    child: Text(
                                                                                                                      stationName,
                                                                                                                      overflow: TextOverflow.fade,
                                                                                                                      maxLines: 1,
                                                                                                                      style: const TextStyle(
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
                                                                                                        ),
                                                                                                      ))
                                                                                                  .toList()
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              ).whenComplete(() {
                                                                                _isBottomSheetVisible = false; // รีเซ็ตสถานะเมื่อ Bottom Sheet ปิด
                                                                              });
                                                                            }
                                                                          } else {
                                                                            if (!_isBottomSheetVisible) {
                                                                              _isBottomSheetVisible = true; // ตั้งค่าสถานะว่า Bottom Sheet กำลังแสดงอยู่
                                                                              showModalBottomSheet(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return Container(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 34),
                                                                                    decoration: const BoxDecoration(
                                                                                      color: Colors.white,
                                                                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                                    ),
                                                                                    child: Wrap(
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          width: MediaQuery.of(context).size.width,
                                                                                          child: const Column(
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            children: <Widget>[
                                                                                              Text(
                                                                                                'เลือกสถานีใกล้คุณ',
                                                                                                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                              SizedBox(height: 20),
                                                                                              Text(
                                                                                                'ไม่พบสถานีใกล้คุณ',
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              ).whenComplete(() {
                                                                                _isBottomSheetVisible = false; // รีเซ็ตสถานะเมื่อ Bottom Sheet ปิด
                                                                              });
                                                                            }
                                                                          }
                                                                        });
                                                                      } else {
                                                                        AppSettings
                                                                            .openAppSettings();
                                                                      }
                                                                    }
                                                                  : null,
                                                              child: Container(
                                                                height: 60,
                                                                width:
                                                                    Get.width *
                                                                        0.75,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: containerColor ??
                                                                      const Color(
                                                                          0xFFFFC452),
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .white),
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            16),
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
                                                                      color: textColor ??
                                                                          const Color(
                                                                              0xFFFFC452),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            20),
                                                                    Text(
                                                                      displayText ??
                                                                          "เข้างาน",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .fade,
                                                                      maxLines:
                                                                          1,
                                                                      style:
                                                                          TextStyle(
                                                                        color: textColor ??
                                                                            Color(0xFFFFC452),
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
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
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    SMEHorizontalCalendar(
                      selectedColor: primaryColor.shade800,
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          userController.userTimeStampModel
                                                          .value.data !=
                                                      null &&
                                                  userController
                                                          .userTimeStampModel
                                                          .value
                                                          .data
                                                          ?.in_1At !=
                                                      null
                                              ? userController
                                                  .userTimeStampModel
                                                  .value
                                                  .data!
                                                  .in_1At!
                                              : "-",
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const Icon(
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          userController.userTimeStampModel
                                                          .value.data !=
                                                      null &&
                                                  userController
                                                          .userTimeStampModel
                                                          .value
                                                          .data
                                                          ?.out_1At !=
                                                      null
                                              ? userController
                                                  .userTimeStampModel
                                                  .value
                                                  .data!
                                                  .out_1At!
                                              : "-",
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const Icon(
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
