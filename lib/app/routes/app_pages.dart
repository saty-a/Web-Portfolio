import 'package:get/get.dart';
import '../modules/home/views/home_view.dart';
import '../modules/loading/views/loading_view.dart';
import '../modules/loading/bindings/loading_binding.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOADING;

  static final routes = [
    GetPage(
      name: _Paths.LOADING,
      page: () => const LoadingView(),
      binding: LoadingBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
    ),
  ];
}
