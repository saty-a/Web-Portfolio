import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import '../../../data/models/project_model.dart';

class CaseStudyController extends GetxController {
  late final Project project;

  @override
  void onInit() {
    super.onInit();
    project = Get.arguments as Project;
  }

  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await launcher.canLaunchUrl(uri)) {
      await launcher.launchUrl(uri, mode: launcher.LaunchMode.externalApplication);
    }
  }
}
