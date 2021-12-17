import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:njust_library/search/search_controller.dart';
import 'package:njust_library/search/types_of_search.dart/full_text_search_provider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  static const routeName = '/search-screen';

  var children;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FullTextSearchProvider()),
        ],
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
                bottom: true,
                child: GetBuilder<SearchController>(
                    builder: (controller) => Scaffold(
                        resizeToAvoidBottomInset: false,
                        appBar: AppBar(
                          elevation: 2,
                          shadowColor: Colors.grey,
                          title: Text(
                            'Search',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color),
                          ),
                          leading: BackButton(
                            color: Colors.purple,
                          ),
                        ),
                        body: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          children: controller.widgetOptions,
                          controller: controller.pageController,
                          onPageChanged: controller.onPageChanged,
                        ),
                        bottomNavigationBar: bottomNav(controller))))));
  }

  Widget bottomNav(SearchController controller) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Material(
            shadowColor: Colors.purple,
            elevation: 20,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: GestureDetector(
                          onTap: () {
                            controller.onPageChanged(0);
                          },
                          child: Center(
                              child: Text(
                            'Full-Text-Search',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: controller.pageIndex == 0
                                    ? Colors.white
                                    : Colors.grey,
                                fontSize: 12.5),
                          )))),
                  Expanded(
                      child: GestureDetector(
                          onTap: () {
                            controller.onPageChanged(1);
                          },
                          child: Center(
                              child: Text(
                            'Simple Search',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: controller.pageIndex == 1
                                    ? Colors.white
                                    : Colors.grey,
                                fontSize: 12.5),
                          )))),
                  Expanded(
                      child: GestureDetector(
                          onTap: () {
                            controller.onPageChanged(2);
                          },
                          child: Center(
                              child: Text(
                            'Multi-Search',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: controller.pageIndex == 2
                                    ? Colors.white
                                    : Colors.grey,
                                fontSize: 12.5),
                          )))),
                ],
              ),
            )));
  }
}
