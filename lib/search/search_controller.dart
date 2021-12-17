import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:njust_library/search/types_of_search.dart/full_text_search.dart';

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
      FullTextSearch(),
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
