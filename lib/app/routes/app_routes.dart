part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const CASE_STUDY = _Paths.CASE_STUDY;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/';
  static const CASE_STUDY = '/case-study';
}
