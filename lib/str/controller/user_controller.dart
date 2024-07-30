import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:srt_app/str/controller/authen_controller.dart';
import 'package:srt_app/str/model/stations_model.dart';
import 'package:srt_app/str/service/user_service.dart';

class UserController extends GetxController {
  var authenController = Get.put(AuthenController());
  var stationsModel = StationsModel().obs;
  Future<StationsModel> fetchBranch() async {
    try {
      String jsonData = await UserService().fetchBranch(
          token: authenController.loginModel.value.data!.token ?? "");
      stationsModel.value = StationsModel.fromJson(json.decode(jsonData));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return stationsModel.value;
  }
}
