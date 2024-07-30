import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srt_app/str/constants/color_constants.dart';
import 'package:srt_app/str/page/home_user_page.dart';
import 'package:srt_app/str/page/login_page.dart';
import 'package:srt_app/str/widgets/loading.dart';

import '../controller/authen_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> getRemember() async {
    print('object');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var username = prefs.getString('remember_username');
    var password = prefs.getString('remember_password');

    if (username != null &&
        username.isNotEmpty &&
        password != null &&
        password.isNotEmpty) {
      authenController
          .fetchLogin(
        username: username,
        password: password,
      )
          .then(
        (value) async {
          if (value.success == false) {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            prefs.setString("remember_username", "");
            prefs.setString("remember_password", "");

            Get.off(() => LoginPage());
          } else {
            Get.off(() => HomeUserPage());
          }
        },
      );
    } else {
      Get.off(() => LoginPage());
    }
  }

  _SplashPageState() {
    getRemember();
  }
  var authenController = Get.put(AuthenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              SMELoading(
                dotOneColor: primaryColor.shade400,
                dotTwoColor: primaryColor,
                dotThreeColor: primaryColor.shade600,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
