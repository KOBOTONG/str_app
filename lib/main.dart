import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:srt_app/str/constants/color_constants.dart';
import 'package:srt_app/str/page/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'srt_app',
      theme: ThemeData(
        fontFamily: 'Prompt-Regular',
        primarySwatch: primaryColor,
      ),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
