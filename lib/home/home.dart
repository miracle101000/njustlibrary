import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:njust_library/api_service.dart';
import 'package:njust_library/home/homecontroller.dart';
import 'package:njust_library/home/widget/top_circulating_books.dart';
import 'package:njust_library/search/search_screen.dart';

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
                              'NJUST',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple),
                            ),
                            Text(
                              ' - Lib',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'ENG',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Container(
                                height: 30,
                                width: 5,
                                decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              'CHN',
                              style: TextStyle(fontWeight: FontWeight.bold),
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
              ? Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.purple)),
                )
              : controller.isLoading && !controller.hasError
                  ? GestureDetector(
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          alignment: Alignment.center,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  height:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: SvgPicture.asset(NO_NETWORK),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  'Network error',
                                  style: TextStyle(color: Colors.purple),
                                )
                              ])),
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
                            GestureDetector(
                                onTap: () {
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
                                        'Search here...',
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
                                'Popular searches',
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
                                      return Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        decoration: BoxDecoration(
                                            color: Colors.purple.withAlpha(190),
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
                                      );
                                    })),
                            SizedBox(
                              height: 32,
                            ),
                            TopCirculatingBooks(
                                topCirculation: controller.topCirculation),
                            // SizedBox(
                            //   height: 16,
                            // ),

                            TopCirculatingBooks(
                                topCirculation: controller.topBooks)
                          ])))),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
