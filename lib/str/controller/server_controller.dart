import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:srt_app/str/model/server_time_model.dart';
import 'package:srt_app/str/service/base_service.dart';

class ServerController extends GetxController {
  var serverTimeModel = ServerTimeModel().obs;
  Future<bool> checkPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<ServerTimeModel> fetchServerTime() async {
    try {
      String jsonData = await BaseService().getServerTime();
      print(jsonData);
      serverTimeModel.value = ServerTimeModel.fromJson(json.decode(jsonData));
    } catch (e) {
      print(e);
    }
    return serverTimeModel.value;
  }
}
