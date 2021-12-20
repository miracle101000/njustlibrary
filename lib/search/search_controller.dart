import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  int pageIndex = 0;
  PageController? pageController;
  List<Widget> widgetOptions = [];
  // RxString userName = "".obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: pageIndex);
    widgetOptions = [
      Container(
        child: Text('simple'),
      ),
      Container(
        child: Text('multi'),
      ),
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
