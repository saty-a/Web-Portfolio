import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webportfolio/app/modules/about/views/about.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.grey),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: Get.height * .061,
                width: Get.width,
                decoration: const BoxDecoration(
                    color: Colors.black54,
                    boxShadow: [],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.ABOUT);
                        },
                        child: const Text(
                          "About",
                          style: TextStyle(fontSize: 20, color: Colors.white),
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
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Text(
                          "Projects",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            About(),
            // Obx(() {
            //   return controller.isInternet.value
            //       ? Align(
            //           alignment: Alignment.bottomCenter,
            //           child: Container(
            //             height: Get.height * .061,
            //             width: Get.width,
            //             decoration: const BoxDecoration(
            //                 color: Colors.lightBlueAccent,
            //                 borderRadius: BorderRadius.only(
            //                     topLeft: Radius.circular(20),
            //                     topRight: Radius.circular(20))),
            //             child: Center(
            //               child: Wrap(
            //                 alignment: WrapAlignment.center,
            //                 children: [
            //                   InkWell(
            //                     onTap: () {
            //                       Get.toNamed(Routes.ABOUT);
            //                       debugPrint("about");
            //                     },
            //                     child: const Text(
            //                       "About",
            //                       style: TextStyle(
            //                           fontSize: 20, color: Colors.white),
            //                     ),
            //                   ),
            //                   InkWell(
            //                     onTap: () {},
            //                     child: const SizedBox(
            //                       width: 20,
            //                     ),
            //                   ),
            //                   InkWell(
            //                     onTap: () {},
            //                     child: const Text(
            //                       "Experience",
            //                       style: TextStyle(
            //                           fontSize: 20, color: Colors.white),
            //                     ),
            //                   ),
            //                   const SizedBox(
            //                     width: 20,
            //                   ),
            //                   InkWell(
            //                     onTap: () {},
            //                     child: const Text(
            //                       "Projects",
            //                       style: TextStyle(
            //                           fontSize: 20, color: Colors.white),
            //                     ),
            //                   )
            //                 ],
            //               ),
            //             ),
            //           ),
            //         )
            //       : const SizedBox.shrink();
            // })
          ],
        ),
      ),
    );
  }
}
