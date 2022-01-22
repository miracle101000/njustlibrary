import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'base_screen_controller.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<BaseScreenController>(
        builder: (controller) {
          return Scaffold(
            body: PageView(
              physics: NeverScrollableScrollPhysics(),
              children: controller.widgetOptions,
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
            ),
            bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color:
                            Get.isDarkMode ? Colors.grey.shade800 : Colors.grey,
                        blurRadius: 1,
                        spreadRadius: 0.005),
                  ],
                ),
                child: BottomNavigationBar(
                  unselectedItemColor: Colors.grey,
                  selectedItemColor: Colors.purple,
                  onTap: controller.onPageChanged,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  currentIndex: controller.pageIndex,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.home),
                      label: 'home'.tr,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.info_circle),
                      label: 'about'.tr,
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
