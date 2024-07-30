import 'package:flutter/material.dart';
import 'package:srt_app/str/constants/color_constants.dart';

class SMEButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final Color bg, titlecolor;
  final double? btnHeight;
  final double? btnwidth;
  final bool? shadow;

  const SMEButton({
    Key? key,
    required this.onTap,
    required this.title,
    required this.bg,
    required this.titlecolor,
    this.btnHeight = 50,
    this.btnwidth = 300,
    this.shadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: btnHeight,
      width: btnwidth,
      child: Material(
        borderRadius: BorderRadius.circular(100.0),
        color: bg,
        child: InkWell(
          highlightColor: primaryColor.shade200.withOpacity(0.1),
          splashColor: primaryColor.shade200.withOpacity(0.5),
          onTap: onTap,
          borderRadius: BorderRadius.circular(100.0),
          child: Container(
            alignment: Alignment.center,
            height: 50.00,
            decoration: BoxDecoration(
              color: bg,
              boxShadow: [shadow == true ? boxShadow : transboxShadow],
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: Text(
              title,
              style: TextStyle(fontSize: 16, color: titlecolor),
            ),
          ),
        ),
      ),
    );
  }
}
