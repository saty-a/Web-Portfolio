import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with theme toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Portfolio',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Obx(() => Tooltip(
                          message: controller.isDarkMode.value
                              ? 'Switch to Light Mode'
                              : 'Switch to Dark Mode',
                          child: IconButton(
                            onPressed: controller.toggleTheme,
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                controller.isDarkMode.value
                                    ? Icons.light_mode
                                    : Icons.dark_mode,
                                key: ValueKey(controller.isDarkMode.value),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 32.h),
                // Hero section
                Text(
                  'Welcome to my portfolio',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(height: 16.h),
                Text(
                  'I create beautiful and functional web experiences',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                // Add more sections here as we progress
              ],
            ),
          ),
        ),
      ),
    );
  }
}
