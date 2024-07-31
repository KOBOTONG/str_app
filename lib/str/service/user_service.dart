import 'dart:convert';
import 'dart:io';

import 'package:srt_app/str/service/base_service.dart';

class UserService {
  fetchBranch({required token}) async {
    try {
      var response = await BaseService()
          .getResponse(path: "/emp/branch/fetch", token: token);
      if (response != null) {
        return utf8.decode(response.bodyBytes);
      }
      return null;
    } catch (e) {
      print(e);
    }
  }

  fetchTimeStamp({required token, required date}) async {
    try {
      var response = await BaseService().postReponseByJson(
          path: "/emp/timestamp", data: {"date": date}, token: token);
      if (response != null) {
        return utf8.decode(response.bodyBytes);
      }
      return null;
    } catch (e) {
      print(e);
    }
  }

  saveTimestamp(
      {required token,
      required latitude,
      required longitude,
      required branchId,
      required imgTimeStamp}) async {
    try {
      final bytes = File(imgTimeStamp.path).readAsBytesSync();
      String base64Image = "data:image/png;base64," + base64Encode(bytes);
      String base64imgTimeStamp = base64Image.toString();
      print(latitude);
      print(longitude);
      print(branchId);
      print(base64imgTimeStamp);

      var response = await BaseService().postReponseByJson(
          path: "/emp/timestamp/location/create",
          data: {
            "latitude": latitude,
            "longitude": longitude,
            "branch_id": branchId,
            "img": base64imgTimeStamp
          },
          token: token);
      if (response != null) {
        return utf8.decode(response.bodyBytes);
      }
      return null;
    } catch (e) {
      print(e);
    }
  }
}
