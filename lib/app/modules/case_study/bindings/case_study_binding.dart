import 'package:get/get.dart';
import '../controllers/case_study_controller.dart';

class CaseStudyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CaseStudyController>(() => CaseStudyController());
  }
}
