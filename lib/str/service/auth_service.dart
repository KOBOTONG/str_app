import 'dart:convert';
import 'package:srt_app/str/service/base_service.dart';

class AuthenService {
  login({
    required username,
    required password,
  }) async {
    var response = await BaseService().postReponseByJson(path: "/auth/login");
    if (response != null) {
      return utf8.decode(response.bodyBytes);
    }
    return null;
  }
}
