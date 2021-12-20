import 'package:get/get.dart';
import 'base_screen_controller.dart';
import 'home/home_controller.dart';
import 'search/search_controller.dart';
import 'search/search_result/search_result_controller.dart';

class GlobalBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<BaseScreenController>(() => BaseScreenController(),
        fenix: true);
    Get.lazyPut<SearchController>(() => SearchController(), fenix: true);
    Get.lazyPut<SearchResultController>(() => SearchResultController(),
        fenix: true);
  }
}
