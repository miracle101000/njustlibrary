import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:njust_library/api_service.dart';
import 'package:njust_library/home/home_controller.dart';
import 'package:njust_library/search/search_body/search_body_provider.dart';
import 'package:njust_library/search/search_result/search_paramters_model.dart';
import 'package:njust_library/search/search_result/search_result_provider.dart';
import 'package:provider/provider.dart';
import '../../book_info_page.dart';
import 'search_result_controller.dart';

class SearchResult extends StatelessWidget {
  static const routeName = '/search-result';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<SearchResultController>(
        builder: (controller) => Scaffold(
            endDrawer: endDrawer(width, context, controller),
            appBar: AppBar(
              elevation: 0,
              leading: Consumer<SearchResultProvider>(
                  builder: (context, value, child) => BackButton(
                        onPressed: () {
                          value.clearAll();
                          Get.back();
                        },
                        color: Colors.purple,
                      )),
              actions: [
                if (controller.total != 0)
                  Consumer<SearchResultProvider>(
                      builder: (context, value, child) => Builder(
                            builder: (context) => value.hasFilters
                                ? TextButton(
                                    child: Text(
                                      'clear'.tr,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      value.setHasFilter(false);
                                      controller.getData();
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.menu,
                                      color: Colors.purple,
                                    ),
                                    onPressed: () =>
                                        Scaffold.of(context).openEndDrawer(),
                                    tooltip: MaterialLocalizations.of(context)
                                        .openAppDrawerTooltip,
                                  ),
                          ))
              ],
              title: Text(
                controller.isLoading
                    ? 'results1'.tr
                    : 'results2'
                        .trParams({'total': controller.total.toString()}),
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).textTheme.bodyText1!.color),
              ),
              centerTitle: true,
            ),
            extendBody: true,
            body: controller.isLoading && !controller.hasError
                ? HomeController.progressIndciator()
                : !controller.isLoading && controller.hasError
                    ? HomeController.networkError(context)
                    : !controller.isLoading &&
                            !controller.hasError &&
                            controller.total == 0
                        ? HomeController.noInfo()
                        : Scrollbar(
                            child: SingleChildScrollView(
                                controller: controller.scrollController,
                                child: Column(children: [
                                  ListView.builder(
                                      primary: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: controller.content.length,
                                      itemBuilder: (context, index) {
                                        final book = controller.content[index];
                                        return item(
                                            book, index.toString(), width);
                                      }),
                                  Container(
                                    child: controller.loadMore &&
                                            !controller.hasErrorForMore &&
                                            !controller.lastPage
                                        ? Container(
                                            height: 15,
                                            width: 15,
                                            child: HomeController
                                                .progressIndciator(true))
                                        : !controller.loadMore &&
                                                controller.hasErrorForMore &&
                                                !controller.lastPage
                                            ? Text(
                                                'network_err'.tr,
                                                style: TextStyle(
                                                    color: Colors.purple,
                                                    fontSize: 10),
                                              )
                                            : !controller.loadMore &&
                                                    !controller
                                                        .hasErrorForMore &&
                                                    controller.lastPage
                                                ? Text(
                                                    'last_page'.tr,
                                                    style: TextStyle(
                                                        color: Colors.purple,
                                                        fontSize: 10),
                                                  )
                                                : Container(),
                                  )
                                ])))));
  }

  Widget item(var book, String index, double width) {
    return FutureBuilder<String?>(
        key: ObjectKey(index),
        future: APIService.getImage(
            'marc_no=${book['marcRecNo']}&isbn=${book['isbn']}'),
        builder: (context, image) => GestureDetector(
              child: Container(
                  height: 110,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: Row(
                      children: [
                        Material(
                          elevation: 0,
                          child: Container(
                              child: ExtendedImage.network(
                            image.hasData && image.data != null
                                ? image.data!
                                : 'http://202.119.83.14:8080/uopac/tpl/images/nobook.jpg',
                            cache: true,
                            clearMemoryCacheWhenDispose: true,
                            fit: BoxFit.cover,
                            loadStateChanged: (state) {
                              if (state.extendedImageLoadState ==
                                  LoadState.completed) {
                                return ExtendedRawImage(
                                  fit: BoxFit.cover,
                                  image: state.extendedImageInfo?.image,
                                  width: width * 0.23,
                                  height: 110,
                                );
                              }
                              return Container(
                                width: width * 0.23,
                                height: 110,
                                color: Colors.purple,
                                child: ExtendedImage.network(
                                  "http://202.119.83.14:8080/uopac/tpl/images/nobook.jpg",
                                  fit: BoxFit.cover,
                                  cache: true,
                                ),
                              );
                            },
                          )),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Column(
                          children: [
                            Container(
                                width: width * 0.65,
                                child: Text(
                                  book['title'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                width: width * 0.65,
                                child: Text(
                                  book['author'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                            Container(
                                width: width * 0.65,
                                child: Text(
                                  '${book['publisher']} ${book['pubYear']}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey.shade500),
                                )),
                          ],
                        )
                      ],
                    ),
                  )),
              onTap: () {
                Get.toNamed(BookInfoPage.routeName, arguments: {
                  'name': book['title'],
                  'link': 'item.php?marc_no=${book['marcRecNo']}',
                  'image': image.hasData && image.data != null
                      ? image.data!
                      : 'http://202.119.83.14:8080/uopac/tpl/images/nobook.jpg'
                });
              },
            ));
  }

  Widget endDrawer(
      double width, BuildContext context, SearchResultController controller) {
    return Container(
        width: width * 0.85,
        color: Theme.of(context).textTheme.bodyText1!.color,
        child: Drawer(
          child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(children: [
                Container(
                    height: MediaQuery.of(context).size.height - 60,
                    child: ListView.builder(
                        itemCount: controller.filterList.length,
                        itemBuilder: (context, index) {
                          final filterLists = controller.filterList[index];
                          return Consumer<SearchResultProvider>(
                              builder: (context, data, child) => Container(
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    height: 250,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: width * 0.85,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      color: Colors.purple),
                                                  bottom: BorderSide(
                                                      color: Colors.purple))),
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 8),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${filterLists['label']} (${filterLists['facetList'].length})',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    if (data.filters
                                                            .isNotEmpty &&
                                                        data.filters
                                                            .where((element) =>
                                                                element[
                                                                    'fieldName'] ==
                                                                filterLists[
                                                                    'id'])
                                                            .isNotEmpty)
                                                      GestureDetector(
                                                        child: Text('clear'.tr,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .red)),
                                                        onTap: () {
                                                          data.clearThisFacet(
                                                              filterLists[
                                                                  'id']);
                                                        },
                                                      )
                                                  ])),
                                        ),
                                        Container(
                                            height: 200,
                                            child: Scrollbar(
                                              child: ListView.builder(
                                                  itemCount:
                                                      filterLists['facetList']
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final filter =
                                                        filterLists['facetList']
                                                            [index];
                                                    return GestureDetector(
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 8,
                                                            top: 8,
                                                            bottom: 8),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width:
                                                                  width * 0.70,
                                                              child: Text(
                                                                  '${filter['name']} (${filter['count']})'),
                                                            ),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                if (data.filters
                                                                        .isNotEmpty &&
                                                                    data.filters
                                                                        .where((element) =>
                                                                            element['fieldName'] ==
                                                                            filterLists[
                                                                                'id'])
                                                                        .isNotEmpty &&
                                                                    data.filters
                                                                        .where((element) =>
                                                                            element['fieldName'] ==
                                                                            filterLists[
                                                                                'id'])
                                                                        .first[
                                                                            'values']
                                                                        .contains(
                                                                            filter['code']))
                                                                  Icon(
                                                                    Icons
                                                                        .check_box,
                                                                    color: Colors
                                                                        .purple,
                                                                  )
                                                                else
                                                                  Icon(
                                                                    Icons
                                                                        .crop_square,
                                                                    color: Colors
                                                                        .purple,
                                                                  )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        bool hasCondition = data
                                                                .filters
                                                                .isNotEmpty &&
                                                            data.filters
                                                                .where((element) =>
                                                                    element[
                                                                        'fieldName'] ==
                                                                    filterLists[
                                                                        'id'])
                                                                .isNotEmpty &&
                                                            data.filters
                                                                .where((element) =>
                                                                    element[
                                                                        'fieldName'] ==
                                                                    filterLists[
                                                                        'id'])
                                                                .first['values']
                                                                .contains(filter[
                                                                    'code']);
                                                        data.updateFiltersList(
                                                            filterLists['id'],
                                                            filter['code'],
                                                            hasCondition
                                                                ? index
                                                                : null);
                                                      },
                                                    );
                                                  }),
                                            ))
                                      ],
                                    ),
                                  ));
                        })),
                Consumer2<SearchBodyProvider, SearchResultProvider>(
                    builder: (context, body, result, child) {
                  return Container(
                    height: 48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {
                              result.setHasFilter(true);
                              Get.back();
                              var paramters =
                                  Get.arguments as SearchParamtersModel;
                              controller.getData(SearchParamtersModel(
                                fieldList: paramters.fieldList,
                                filters: result.filters,
                                limiter: paramters.limiter,
                                sortField: paramters.sortField!,
                                sortType: paramters.sortType!,
                                campusLocations: paramters.campusLocations,
                                singleLocations: paramters.singleLocations,
                              ));
                            },
                            icon: Icon(
                              Icons.check,
                              color: Colors.purple,
                            )),
                        if (result.filters.isNotEmpty)
                          TextButton(
                              onPressed: () {
                                result.clearAll();
                              },
                              child: Text(
                                'clear'.tr,
                                style: TextStyle(color: Colors.red),
                              )),
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  );
                })
              ])),
        ));
  }
}
