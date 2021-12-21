import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:njust_library/about_screen.dart';
import 'package:njust_library/home/home.dart';

class BaseScreenController extends GetxController {
  int pageIndex = 0;
  PageController? pageController;
  List<Widget> widgetOptions = [];
  // RxString userName = "".obs;

  @override
  void onInit() {
    super.onInit();
    // SharedPreferences.getInstance().then((prefs) {
    //   userName = prefs.getString("userName")!.obs;
    //   update();
    // });
    pageController = PageController(initialPage: pageIndex);
    widgetOptions = [
      HomePage(),
      AboutScreen(),
    ];
  }

  void onPageChanged(int index) {
    pageIndex = index;
    update();
    pageController!.jumpToPage(pageIndex);
  }

  @override
  void onClose() {
    super.onClose();
    pageController!.dispose();
  }
}
