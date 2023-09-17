import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {

  void toggleDarkMode() {
    if (Get.isDarkMode) {
      Get.changeTheme(ThemeData.light());
    } else {
      Get.changeTheme(ThemeData.dark());
    }
    update();
  }
}
