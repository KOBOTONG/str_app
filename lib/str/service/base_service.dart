import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class BaseService {
  // var serverUrl = "https://www.smethaidev.com";
  //api test
  var serverUrl = "https://railway.smethaidata.com";
  var serverPath = "/api/v1";
  String getServerUrl() {
    return serverUrl;
  }

  String getServerApiUrl() {
    if (kDebugMode) {
      print(" $serverUrl$serverPath");
    }

    return serverUrl + serverPath;
  }

  Future<bool> getServerStatus() async {
    try {
      final response = await http.get(Uri.parse(serverUrl));
      if (response.statusCode == 200) {
        return true;
      }
    } catch (ex) {
      if (kDebugMode) {
        print(ex);
      }
    }
    return false;
  }

  getServerTime() async {
    var client = http.Client();
    try {
      var url = Uri.parse("${BaseService().getServerApiUrl()}/server/datetime");
      final response = await client.get(url);
      return utf8.decode(response.bodyBytes);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      client.close();
    }
  }

  Future<http.Response?> getResponse({
    required String path,
    String? token,
  }) async {
    var client = http.Client();
    try {
      var url = Uri.parse(getServerApiUrl() + path);

      var response = token != null && token.isNotEmpty
          ? await client.get(
              url,
              headers: {
                'Authorization': 'Bearer $token',
                "Content-Type": 'application/json'
              },
            )
          : await client.get(
              url,
              headers: {"Content-Type": 'application/json'},
            );
      return response;
    } catch (ex) {
      if (kDebugMode) {
        print(ex);
      }
    } finally {
      client.close();
    }
    return null;
  }

  Future<http.Response?> postReponseByJson({
    required String path,
    Map? data,
    String? token,
  }) async {
    var client = http.Client();
    try {
      var url = Uri.parse(getServerApiUrl() + path);
      var body = json.encode(data);
      var response = token != null && token.isNotEmpty
          ? await client.post(
              url,
              headers: {
                'Authorization': 'Bearer $token',
                "Content-Type": 'application/json'
              },
              body: body,
            )
          : await client.post(
              url,
              headers: {"Content-Type": 'application/json'},
              body: body,
            );
      return response;
    } catch (ex) {
      if (kDebugMode) {
        print(ex);
      }
    } finally {
      client.close();
    }
    return null;
  }
}
