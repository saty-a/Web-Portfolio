import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/responsive.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [

            Obx(() {
              return controller.isInternet.value
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: Get.height * .061,
                        width: Get.width,
                        decoration: const BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: const Text(
                                  "About",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: const SizedBox(
                                  width: 20,
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: const Text(
                                  "Experience",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: () {},
                                child: const Text(
                                  "Projects",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            })
          ],
        ),
      ),
    );
  }
}
