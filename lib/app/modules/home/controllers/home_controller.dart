import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/content.dart';

class HomeController extends GetxController {
  final RxBool isDarkMode = false.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    final dispatcher = PlatformDispatcher.instance;
    isDarkMode.value = dispatcher.platformBrightness == Brightness.dark;

    dispatcher.onPlatformBrightnessChanged = () {
      isDarkMode.value = dispatcher.platformBrightness == Brightness.dark;
      Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    };
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> copyEmail() async {
    await Clipboard.setData(const ClipboardData(text: AppContent.email));
  }

  @override
  void onClose() {
    scrollController.dispose();
    PlatformDispatcher.instance.onPlatformBrightnessChanged = null;
    super.onClose();
  }
}
