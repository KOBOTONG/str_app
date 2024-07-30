import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:srt_app/str/service/auth_service.dart';

class AuthenController extends GetxController {
  fetchLogin({
    required username,
    required password,
  }) {
    try {
      var jsonData =
          AuthenService().login(username: username, password: password);
      if (jsonData != null) {
        //loginModel.value = LoginModel.fromJson(json.decode(jsonData));
        // print( json.decode(jsonData));
        // return loginModel.value;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
