import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:njust_library/home/home_controller.dart';
import 'package:njust_library/home/widget/item.dart';
import 'package:njust_library/home/widget/top_circulating_books.dart';
import 'package:njust_library/search/search_result/search_paramters_model.dart';
import 'package:njust_library/search/search_result/search_result.dart';
import 'package:njust_library/search/search_screen.dart';
import 'package:njust_library/search/search_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<HomeController>(
      builder: (controller) => Scaffold(
          extendBody: true,
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 65,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Container(
                  height: 65,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              'title'.tr,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              child: Text(
                                'lang'.tr,
                                style: Get.locale.toString() == 'en_US'
                                    ? TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )
                                    : TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                              ),
                              onTap: () {
                                var locale = Locale('en', 'US');
                                Get.updateLocale(locale);
                              },
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                                height: 30,
                                width: 5,
                                decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                            SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              child: Text(
                                'lang2'.tr,
                                style: Get.locale.toString() == 'zh_CN'
                                    ? TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )
                                    : TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                              ),
                              onTap: () {
                                var locale = Locale('zh', 'CN');
                                Get.updateLocale(locale);
                              },
                            ),
                            SizedBox(
                              width: 16,
                            )
                          ],
                        )
                      ])),
            ),
          ),
          body: controller.isLoading && !controller.hasError
              ? HomeController.progressIndciator()
              : controller.isLoading && !controller.hasError
                  ? GestureDetector(
                      child: HomeController.networkError(context),
                      onTap: () async {
                        await controller.getDashBoard(false);
                      },
                    )
                  : RefreshIndicator(
                      color: Colors.purpleAccent,
                      onRefresh: () async {
                        await controller.getDashBoard(false);
                      },
                      child: SingleChildScrollView(
                          primary: true,
                          child: Column(children: [
                            SizedBox(
                              height: 32,
                            ),
                            // TextButton(
                            //     onPressed: () async {
                            //       // await SearchService.setLocale();
                            //       Get.to(HomeItem());
                            //     },
                            //     child: Text(' child')),
                            GestureDetector(
                                onTap: () async {
                                  Get.toNamed(SearchScreen.routeName);
                                },
                                child: Container(
                                  height: 45,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Icon(
                                        CupertinoIcons.search,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'search_here'.tr,
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color:
                                          Colors.grey.shade500.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(15)),
                                )),
                            SizedBox(
                              height: 32,
                            ),
                            Row(children: [
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                'hot_search'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ]),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                                height: 32,
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                child: ListView.builder(
                                    itemCount: controller.topTenBooks.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.purple.withAlpha(190),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Colors.purple,
                                                  width: 2)),
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 4),
                                              child: Center(
                                                  child: Text(
                                                controller.topTenBooks[index]
                                                    ['name'],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))),
                                        ),
                                        onTap: () {
                                          Get.toNamed(SearchResult.routeName,
                                              arguments: SearchParamtersModel(
                                                  fieldList: [
                                                    {
                                                      'fieldCode': "any",
                                                      "fieldValue": controller
                                                              .topTenBooks[
                                                          index]['name']
                                                    }
                                                  ],
                                                  filters: [],
                                                  limiter: [],
                                                  campusLocations: [],
                                                  singleLocations: [],
                                                  sortField: "relevance",
                                                  sortType: "desc"));
                                        },
                                      );
                                    })),
                            SizedBox(
                              height: 32,
                            ),
                            TopCirculatingBooks(
                                topCirculation: controller.topCirculation),
                            TopCirculatingBooks(
                                topCirculation: controller.topBooks)
                          ])))),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
