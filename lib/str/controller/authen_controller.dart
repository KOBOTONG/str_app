import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:srt_app/str/model/login_model.dart';
import 'package:srt_app/str/service/auth_service.dart';

class AuthenController extends GetxController {
  var loginModel = LoginModel().obs;
  Future<LoginModel> fetchLogin({username, password}) async {
    try {
      String jsonData = await AuthenService().login(
        username: username,
        password: password,
      );
      loginModel.value = LoginModel.fromJson(json.decode(jsonData));
      print(json.decode(jsonData));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return loginModel.value;
  }
}
