import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:srt_app/str/controller/authen_controller.dart';
import 'package:srt_app/str/model/stations_model.dart';
import 'package:srt_app/str/model/user_time_stamp_model.dart';
import 'package:srt_app/str/service/user_service.dart';

class UserController extends GetxController {
  var authenController = Get.put(AuthenController());
  var stationsModel = StationsModel().obs;
  var userTimeStampModel = UserTimeStampModel().obs;

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

  Future<UserTimeStampModel> fetchTimeStamp() async {
    try {
      String jsonData = await UserService().fetchTimeStamp(
          token: authenController.loginModel.value.data!.token ?? "",
          date: "31/01/2024");
      userTimeStampModel.value =
          UserTimeStampModel.fromJson(json.decode(jsonData));
          print(json.decode(jsonData));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return userTimeStampModel.value;
  }

  Future saveTimeStamp(
      {required latitude,
      required longitude,
      required branchId,
      required imgTimeStamp}) async {
    try {
      var jsonData = await UserService().saveTimestamp(
          token: authenController.loginModel.value.data!.token ?? "",
          latitude: latitude,
          longitude: longitude,
          branchId: branchId,
          imgTimeStamp: imgTimeStamp);
      if (jsonData != null) {
        var data = json.decode(jsonData);
        print(json.decode(jsonData));
        return data;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }
}
