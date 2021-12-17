import 'package:get/get.dart';

import 'base_screen_controller.dart';
import 'home/homecontroller.dart';
import 'search/search_controller.dart';

class GlobalBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<BaseScreenController>(() => BaseScreenController(),
        fenix: true);
    Get.lazyPut<SearchController>(() => SearchController(), fenix: true);
  }
}
