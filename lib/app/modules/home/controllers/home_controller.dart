import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  final RxBool isDarkMode = false.obs;
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize theme based on system preference
    final window = WidgetsBinding.instance.window;
    isDarkMode.value = window.platformBrightness == Brightness.dark;
    
    // Listen to system theme changes
    window.onPlatformBrightnessChanged = () {
      if (!Get.isDarkMode) { // Only update if user hasn't manually set theme
        isDarkMode.value = window.platformBrightness == Brightness.dark;
        Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
      }
    };
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void setCurrentIndex(int index) {
    currentIndex.value = index;
  }

  @override
  void onReady() {
    super.onReady();
    // Called after the widget is rendered on screen
  }

  @override
  void onClose() {
    // Remove the listener when controller is disposed
    WidgetsBinding.instance.window.onPlatformBrightnessChanged = null;
    super.onClose();
  }
}
