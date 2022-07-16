import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

void showdilog() {
  Get.dialog(
    AlertDialog(
      backgroundColor: Colors.transparent,
      content: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(
            width: 10,
          ),
          Text(
            'Loading...',
            style: TextStyle(color: Colors.white),
          )
        ],
      )),
    ),
    barrierDismissible: false,
  );
}

void closeDilog() {
  Get.back();
}
