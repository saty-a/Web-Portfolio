import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 5),
            ),
            child: CircleAvatar(
              radius: Get.width * .1,
              backgroundImage: const NetworkImage(
                  "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg"),
            ),
          ),
          Text(
            "Grischuk",
            style: GoogleFonts.lato(fontSize: 60),
          )
        ],
      ),
    );
  }
}
