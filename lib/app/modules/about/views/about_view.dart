import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/about_controller.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (value, _) {
        debugPrint("stack pop $value");

        /// back navigation is disabled
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AboutView'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            InkWell(
                onTap: () => Get.toNamed(Routes.HOME),
                child: const Icon(Icons.arrow_back_ios)),
            const Center(
              child: Text(
                'AboutView is working',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
