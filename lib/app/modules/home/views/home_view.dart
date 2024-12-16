import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(100, 80, 100, 100),
        color: Colors.black,
        child: Align(
            alignment: Alignment.topRight,
            child: Container(
              height: Get.height,
              width: Get.width,
              child: Text(
                "Satya Prakash",
                style: GoogleFonts.aboreto(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                )
              ),
            )),
      ),
    );
  }
}
