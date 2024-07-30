import 'dart:convert';

import 'package:srt_app/str/service/base_service.dart';

class UserService {
  fetchBranch({required token}) async {
    try {
      var response = await BaseService().getResponse(
        path: "/emp/branch/fetch",
      token: token
      );
      if (response != null) {
        return utf8.decode(response.bodyBytes);
      }
      return null;
    } catch (e) {
      print(e);
    }
  }
}
