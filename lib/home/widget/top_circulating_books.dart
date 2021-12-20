import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:njust_library/book_info_page.dart';
import 'package:njust_library/home/home_controller.dart';

class TopCirculatingBooks extends StatefulWidget {
  final List topCirculation;
  TopCirculatingBooks({Key? key, required this.topCirculation})
      : super(key: key);

  @override
  _TopCirculatingBooksState createState() => _TopCirculatingBooksState();
}

class _TopCirculatingBooksState extends State<TopCirculatingBooks> {
  bool isMore = false;

  @override
  Widget build(BuildContext context) {
    return widget.topCirculation.isEmpty
        ? HomeController.noInfo()
        : Container(
            child: Column(children: [
              Row(children: [
                SizedBox(
                  width: 16,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  widget.topCirculation[0],
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ]),
              AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: ListView.builder(
                      itemCount: widget.topCirculation[1].length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        // GlobalKey actionKey = LabeledGlobalKey(index.toString());
                        // print(widget.topCirculation[1][index]['image']);
                        return GestureDetector(
                          // key: actionKey,
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 14, top: 8, bottom: 8),
                            child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Stack(
                                  children: [
                                    Material(
                                      elevation: 2,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      child: Container(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: ExtendedImage.network(
                                            widget.topCirculation[1][index]
                                                ['image'],
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            cache: true,
                                            fit: BoxFit.cover,
                                            loadStateChanged: (state) {
                                              if (state
                                                      .extendedImageLoadState ==
                                                  LoadState.completed) {
                                                return ExtendedRawImage(
                                                  fit: BoxFit.cover,
                                                  image: state
                                                      .extendedImageInfo?.image,
                                                  width: 180,
                                                  height: 280,
                                                );
                                              }
                                              return Container(
                                                width: 180,
                                                height: 290,
                                                decoration: BoxDecoration(
                                                    color: Colors.black38),
                                              );
                                            },
                                          )),
                                    ),
                                    Container(
                                      width: 180,
                                      height: 290,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 16,
                                                  left: 8,
                                                  right: 8),
                                              child: Text(
                                                widget.topCirculation[1][index]
                                                    ['name'],
                                                maxLines: 3,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black,
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                          onTap: () async {
                            // findDropdownData(actionKey);
                            Get.toNamed(BookInfoPage.routeName,
                                arguments: widget.topCirculation[1][index]);
                          },
                        );
                      })),
              SizedBox(
                height: 16,
              ),
              Row(children: [
                SizedBox(
                  width: 16,
                ),
              ])
            ]),
          );
  }
}
