import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeItem extends StatelessWidget {
  const HomeItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appbar widget',
          style: TextStyle(color: Colors.purple),
        ),
        leading: BackButton(
          color: Colors.purple,
        ),
      ),
      bottomNavigationBar: Material(
          color: Colors.white,
          elevation: 30,
          shadowColor: Colors.purple,
          child: BottomNavigationBar(
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.purple,
            onTap: (index) {},
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            currentIndex: 1,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                label: 'home'.tr,
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(CupertinoIcons.search),
              //   label: 'Search',
              // ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.info_circle),
                label: 'about'.tr,
              ),
            ],
          )),
    );
  }
}
