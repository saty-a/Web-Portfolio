import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/content.dart';
import '../../../data/models/project_model.dart';

class HomeController extends GetxController {
  final RxBool isDarkMode = false.obs;
  final ScrollController scrollController = ScrollController();

  // ── Case study in-grid state ─────────────────────────────────────────────
  final Rx<Project?> activeCaseStudy = Rx<Project?>(null);
  final RxInt caseStudyOpenVersion  = 0.obs; // increment to trigger open anim
  final RxInt caseStudyCloseVersion = 0.obs; // increment to trigger close anim

  void requestOpenCaseStudy(Project p) {
    activeCaseStudy.value = p;
    caseStudyOpenVersion.value++;
  }

  void requestCloseCaseStudy() {
    caseStudyCloseVersion.value++;
  }
  // ─────────────────────────────────────────────────────────────────────────

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
