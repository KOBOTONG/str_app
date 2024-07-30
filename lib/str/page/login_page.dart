import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:srt_app/str/constants/color_constants.dart';
import 'package:srt_app/str/page/home_user_page.dart';
import 'package:srt_app/str/widgets/sme_buttons.dart';
import 'package:srt_app/str/widgets/sme_textfileds.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: 0.0,
      duration: Duration(seconds: 5),
      upperBound: 1,
      lowerBound: -1,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (BuildContext context, Widget? child) {
                        return ClipPath(
                          clipper: DrawClip(_controller.value),
                          child: Container(
                            height: size.height * 0.5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomCenter,
                                // stops: [0.1, 0.9],
                                colors: [primaryColor, primaryColor.shade600],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      child: Image.asset(
                        'assets/logo/logo_srt.png',
                        width: 170,
                        height: 170,
                      ),
                    ),
                  ],
                ),
                SMETextField(
                    label: 'ชื่อผู้ใช้งาน',
                    icon: FluentIcons.person_24_filled,
                    controller: usernameController),
                SizedBox(height: 16),
                SMETextField(
                    label: 'รหัสผ่าน',
                    icon: FluentIcons.lock_closed_24_filled,
                    controller: usernameController),
                SizedBox(height: 30),
                SMEButton(
                    onTap: () {
                      Get.to(() => HomeUserPage());
                    },
                    title: 'เข้าสู่ระบบ',
                    bg: primaryColor,
                    titlecolor: Colors.white),
                SizedBox(height: 16),
               
              ],
            ),
          )),
    );
  }
}

class DrawClip extends CustomClipper<Path> {
  double move = 0;
  double slice = math.pi;
  DrawClip(this.move);
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8);
    double xCenter =
        size.width * 0.5 + (size.width * 0.6 + 1) * math.sin(move * slice);
    double yCenter = size.height * 0.8 + 69 * math.cos(move * slice);
    path.quadraticBezierTo(xCenter, yCenter, size.width, size.height * 0.8);

    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
