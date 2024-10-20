import 'package:get/get.dart';
import 'package:webportfolio/app/routes/app_pages.dart';

class LoadingController extends GetxController {
  moveToHomePage() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.toNamed(Routes.HOME);
  }
}
