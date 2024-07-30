
import 'package:flutter/material.dart';
import 'package:srt_app/str/constants/color_constants.dart';
import 'package:srt_app/str/widgets/sme_buttons.dart';

class SMEAlertDialog extends StatelessWidget {
  final String titleMessage;
  final String contentMessage;
  final bool cancelButton;
  final String cancelText;
  final VoidCallback? onCancel;
  final bool submitButton;
  final String submitText;
  final VoidCallback? onSubmit;

  SMEAlertDialog({
    this.titleMessage = "",
    this.contentMessage = "",
    this.cancelButton = false,
    this.cancelText = "Cancel",
    this.onCancel,
    this.submitButton = false,
    this.submitText = "Submit",
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(8),
      contentPadding: EdgeInsets.all(8),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          titleMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          contentMessage.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Text(contentMessage),
                )
              : SizedBox.shrink(),
          SizedBox(height: 25),
          Row(
            children: [
              cancelButton == true
                  ? Expanded(
                      child: SMEButton(
                        onTap: onCancel,
                        btnHeight: 40,
                        btnwidth: 100,
                        title: cancelText,
                        titlecolor: Colors.white,
                        bg: Colors.grey,
                      ),
                    )
                  : SizedBox.shrink(),
              cancelButton == true && submitButton == true
                  ? SizedBox(width: 10)
                  : SizedBox.shrink(),
              submitButton == true
                  ? Expanded(
                      child: SMEButton(
                        onTap: onSubmit,
                        btnHeight: 40,
                        btnwidth: 100,
                        title: submitText,
                        titlecolor: Colors.white,
                        bg:primaryColor,
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ],
      ),
      buttonPadding: EdgeInsets.zero,
    );
  }
}
