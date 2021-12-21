import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:njust_library/api_service.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

class BookInfoPage extends StatefulWidget {
  static const routeName = '/book-info';
  final path = Get.arguments;

  @override
  _BookInfoPageState createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  bool isLoading1 = true;
  bool isMore = false;
  List<TableRow> rows = [];
  double height = 200;
  var extract;
  var table = [];
  @override
  void initState() {
    super.initState();
    APIService.getBookInfo(widget.path['link']).then((value) {
      if (mounted)
        setState(() {
          isLoading1 = false;
          extract = value[0];
          table = value[1];
        });
      getRows(table);
    });
  }

  getRows(List table) {
    for (int x = 0; x < table.length; x++) {
      for (int y = 0; y < table[x].keys.toList().length; y++) {
        List<Widget> dataCell = [];
        dataCell.add(Container(
            height: 50,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border:
                    Border(right: BorderSide(width: 1.0, color: Colors.grey))),
            child: Text(
              table[x].keys.toList()[y],
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold),
            )));
        dataCell.add(Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width * 0.4,
            padding: EdgeInsets.only(left: 8),
            height: 50,
            child: Text(
              table[x][table[x].keys.toList()[y]],
              overflow: TextOverflow.clip,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: table[x][table[x].keys.toList()[y]] == '可借'
                      ? Colors.green
                      : null),
            )));
        rows.add(TableRow(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    width: y == 0 ? 5.0 : 0,
                    color: y == 0 ? Colors.purple : Colors.grey),
                left: BorderSide(width: 1.0, color: Colors.transparent),
                right: BorderSide(width: 1.0, color: Colors.transparent),
                bottom: BorderSide(
                    width: 0,
                    color: y == table[x].keys.toList().length - 1
                        ? Colors.purple
                        : Colors.grey),
              ),
            ),
            children: dataCell));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        // appBar: AppBar(
        //   toolbarHeight: 0,
        //   elevation: 0,
        //   backgroundColor: Colors.transparent,
        // ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          child: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        body: isLoading1
            ? Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple)))
            : Container(
                child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipPath(
                      clipper: ProsteThirdOrderBezierCurve(
                        position: ClipPosition.bottom,
                        list: [
                          ThirdOrderBezierCurveSection(
                            p1: Offset(0, screenHeight * 0.3),
                            p2: Offset(0, screenHeight * 0.5),
                            p3: Offset(screenWidth, screenHeight * 0.39),
                            p4: Offset(screenWidth, screenHeight * 0.47),
                          ),
                        ],
                      ),
                      child: Container(
                          height: screenHeight * 0.47,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                  child: ExtendedImage.network(
                                widget.path['image'],
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                cache: true,
                                fit: BoxFit.cover,
                                loadStateChanged: (state) {
                                  if (state.extendedImageLoadState ==
                                      LoadState.completed) {
                                    return ExtendedRawImage(
                                      fit: BoxFit.cover,
                                      image: state.extendedImageInfo?.image,
                                      width: screenWidth,
                                    );
                                  }
                                  return Container(
                                    width: screenWidth,
                                    child: Center(
                                      child: Text(
                                        widget.path['name'],
                                        textAlign: TextAlign.center,
                                        maxLines: 6,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 25),
                                      ),
                                    ),
                                    decoration:
                                        BoxDecoration(color: Colors.purple),
                                  );
                                },
                              )),
                              Container(
                                width: screenWidth,
                                decoration:
                                    BoxDecoration(color: Colors.black38),
                              ),
                            ],
                          )),
                    ),
                    Row(children: [
                      SizedBox(
                        width: 16,
                      ),
                      Container(
                          height: 35,
                          width: 5,
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "book_info".tr,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )
                    ]),
                    AnimatedContainer(
                      height: height,
                      duration: Duration(milliseconds: 200),
                      padding: EdgeInsets.zero,
                      child: ListView.builder(
                          itemCount: extract.keys.toList().length,
                          physics:
                              isMore ? null : NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: EdgeInsets.only(left: 14, top: 8),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(children: [
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Container(
                                            height: 10,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Colors.purple,
                                                shape: BoxShape.circle))
                                      ]),
                                      SizedBox(width: 8),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.90,
                                        child: RichText(
                                          maxLines: isMore ? null : 1,
                                          overflow: isMore
                                              ? TextOverflow.clip
                                              : TextOverflow.ellipsis,
                                          text: TextSpan(
                                            text: extract.keys.toList()[index],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .color,
                                                fontSize: 15),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text:
                                                      ' ${extract[extract.keys.toList()[index]]}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 15)),
                                            ],
                                          ),
                                        ),
                                      )
                                    ]));
                          }),
                    ),
                    if (extract.keys.toList().length > 4)
                      GestureDetector(
                          onTap: () {
                            if (isMore) {
                              setState(() {
                                isMore = false;
                                height = 200;
                              });
                            } else {
                              setState(() {
                                isMore = true;
                                height =
                                    (extract.keys.toList().length.toDouble()) *
                                        45;
                              });
                            }
                          },
                          child: Padding(
                              padding: EdgeInsets.only(left: 32, top: 8),
                              child: Text(
                                isMore ? 'close'.tr : 'view_det'.tr,
                                style: TextStyle(color: Colors.blue),
                              ))),
                    SizedBox(
                      height: 32,
                    ),
                    Row(children: [
                      SizedBox(
                        width: 16,
                      ),
                      Container(
                          height: 35,
                          width: 5,
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "location2".tr,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )
                    ]),
                    SizedBox(
                      height: 16,
                    ),
                    if (table.length != 0)
                      locationTable(table)
                    else
                      Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 200,
                                  height: 150,
                                  child: SvgPicture.asset(NO_DATA),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  'no_info'.tr,
                                  style: TextStyle(color: Colors.purple),
                                )
                              ])),
                    SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              )));
  }

  locationTable(List data) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Table(
            columnWidths: {0: FixedColumnWidth(100), 1: FlexColumnWidth()},
            children: rows));
  }
}
