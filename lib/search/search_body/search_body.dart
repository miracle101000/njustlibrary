import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:njust_library/home/home_controller.dart';
import 'package:njust_library/search/search_body/search_body_provider.dart';
import 'package:njust_library/search/search_result/search_paramters_model.dart';
import 'package:njust_library/search/search_result/search_result.dart';
import 'package:njust_library/search/search_service.dart';
import 'package:provider/provider.dart';

import 'locations_data_source.dart';

enum DropDowns { FORMAT, LANG, SORTBY }

class SearchBody extends StatefulWidget {
  @override
  _SearchBodyState createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  double height = 115;
  var formats = [],
      languages = [],
      sortBys = [],
      sortByDir = [],
      year = [],
      campus = [],
      locations = [],
      searchFields = [],
      deptLocationList = {};
  String? format, language, sortBy;
  bool isInit = false, isLoading = true, hasError = false;
  RangeValues? _currentRangeValues;
  List<Widget> listTextFields = [];
  Map<int, dynamic> data = {};
  final _formKey = GlobalKey<FormState>();

  LocationsDataSource? locationsDataSource;
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (!isInit) {
      isInit = true;
      listTextFields.clear();
      listTextFields.add(field(width, 0));
    }
    return Scaffold(
      bottomNavigationBar:
          Consumer<SearchBodyProvider>(builder: (context, data, child) {
        if (data.value[SearchBodyProvider.textFields][0]['fieldValue']
            .trim()
            .isNotEmpty) {
          return Container(
              height: 60,
              alignment: Alignment.center,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                TextButton(
                    onPressed: () async {
                      Get.toNamed(SearchResult.routeName,
                          arguments: SearchParamtersModel(
                              fieldList:
                                  data.value[SearchBodyProvider.textFields],
                              filters: data.filters,
                              limiter: data.limiterList,
                              campusLocations: data.currentLocations,
                              singleLocations: data.locations,
                              sortField: data.sortBy!,
                              sortType: data.sortType!));
                    },
                    child: Icon(
                      Icons.check,
                      color: Colors.purple,
                    )),
                TextButton(
                    onPressed: () {
                      clearAll(data, width);
                    },
                    child: Icon(
                      CupertinoIcons.clear,
                      color: Colors.red,
                    ))
              ]));
        }
        return Container(
          height: 0,
        );
      }),
      body: isLoading && !hasError
          ? HomeController.progressIndciator()
          : !isLoading && hasError
              ? GestureDetector(
                  child: Center(
                    child: HomeController.networkError(context),
                  ),
                  onTap: () async {
                    getData();
                  },
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                          height: height,
                          child: Form(
                            key: _formKey,
                            child: ListView.builder(
                                itemCount: listTextFields.length,
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return listTextFields[index];
                                }),
                          )),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16,
                            ),
                            Container(
                                width: width * 0.9,
                                child: Text(
                                  'ext_rest'.tr,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      dropDowns('format'.tr, formats, DropDowns.FORMAT),
                      dropDowns('language'.tr, languages, DropDowns.LANG),
                      dropDowns('sort_by'.tr, sortBys, DropDowns.SORTBY),
                      SizedBox(
                        height: 8,
                      ),
                      Row(children: [
                        SizedBox(
                          width: 16,
                        ),
                        Row(
                          children: sortByDir.reversed.map<Widget>((value) {
                            return sortByItems(value);
                          }).toList(),
                        )
                      ]),
                      SizedBox(
                        height: 16,
                      ),
                      Row(children: [
                        SizedBox(
                          width: 18,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'pub_year'.tr,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    ' ${_currentRangeValues!.start.round()} - ${_currentRangeValues!.end.round()}',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        )
                      ]),
                      SizedBox(
                        height: 8,
                      ),
                      Consumer<SearchBodyProvider>(
                          builder: (context, data, child) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: RangeSlider(
                                values: _currentRangeValues!,
                                max: DateTime.now().year.toDouble(),
                                min: 1900,
                                activeColor: Colors.purple,
                                inactiveColor:
                                    Colors.purple.shade500.withAlpha(89),
                                labels: RangeLabels(
                                  _currentRangeValues!.start.round().toString(),
                                  _currentRangeValues!.end.round().toString(),
                                ),
                                onChanged: (RangeValues values) {
                                  setState(() {
                                    _currentRangeValues = values;
                                    data.setYear(_currentRangeValues!.start,
                                        _currentRangeValues!.end);
                                  });
                                },
                              ))),
                      Row(
                        children: [
                          SizedBox(
                            width: 16,
                          ),
                          Text('campus'.tr,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(children: [
                        SizedBox(
                          width: 16,
                        ),
                        Row(
                          children: campus.map<Widget>((value) {
                            return campusItems(value);
                          }).toList(),
                        )
                      ]),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 16,
                          ),
                          Text('location'.tr,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      locationsTable()
                    ],
                  ),
                ),
    );
  }

  Widget field(double width, int index) {
    return Consumer<SearchBodyProvider>(
        builder: (context, textField, child) =>
            Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (index != 0)
                    GestureDetector(
                      child: Container(
                        height: 45,
                        width: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color:
                                textField.value[SearchBodyProvider.textFields]
                                            [index]['fieldConj'] ==
                                        'AND'
                                    ? Colors.purple
                                    : Colors.transparent,
                            border: Border.all(color: Colors.purple)),
                        child: Text(
                          'AND',
                          style: TextStyle(
                              color:
                                  textField.value[SearchBodyProvider.textFields]
                                              [index]['fieldConj'] ==
                                          'AND'
                                      ? Colors.white
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color),
                        ),
                      ),
                      onTap: () {
                        textField.updateANDOR(index, 'AND');
                      },
                    ),
                  if (index != 0)
                    GestureDetector(
                      child: Container(
                        height: 45,
                        width: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color:
                                textField.value[SearchBodyProvider.textFields]
                                            [index]['fieldConj'] ==
                                        'OR'
                                    ? Colors.purple
                                    : Colors.transparent,
                            border: Border.all(color: Colors.purple)),
                        child: Text('OR',
                            style: TextStyle(
                                color: textField.value[SearchBodyProvider
                                            .textFields][index]['fieldConj'] ==
                                        'OR'
                                    ? Colors.white
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color)),
                      ),
                      onTap: () {
                        textField.updateANDOR(index, 'OR');
                      },
                    ),
                  SizedBox(
                    width: 4,
                  ),
                  if (index != 0 &&
                      textField.value['totalTextFields'] == (index + 1))
                    Container(
                        height: 45,
                        width: 45,
                        color: Colors.purple,
                        child: GestureDetector(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onTap: () {
                            setState(() {
                              listTextFields.add(field(
                                  width, textField.value['totalTextFields']));
                              textField.addToTextFields(searchFields[0], index);
                              height = height + 125;
                            });
                          },
                        )),
                  if (index != 0)
                    SizedBox(
                      width: 4,
                    ),
                  if (index != 0)
                    GestureDetector(
                      child: Container(
                        height: 45,
                        width: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.purple,
                            border: Border.all(color: Colors.purple)),
                        child: Icon(
                          Icons.horizontal_rule,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        textField.subtractFromTextFields(index);
                        setState(() {
                          listTextFields.removeAt(index);
                          height = index == 1 ? height - 65 : height - 125;
                        });
                      },
                    )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Center(
                    child: Container(
                        height: 65,
                        width: width * 0.92,
                        child: TextFormField(
                          cursorColor: Colors.purple,
                          initialValue: '',
                          textInputAction: TextInputAction.none,
                          onChanged: (text) {
                            textField.updateFieldValue(index, text);
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.purple, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            prefixIcon: Container(
                              child: DropdownButton<dynamic>(
                                  underline: Container(),
                                  isDense: false,
                                  elevation: 0,
                                  hint: Row(
                                    children: [
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        SearchBodyProvider.getName(
                                            searchFields,
                                            textField.value[SearchBodyProvider
                                                .textFields][index]),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .color),
                                      )
                                    ],
                                  ),
                                  items: searchFields
                                      .map<DropdownMenuItem>((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Container(
                                        child: Text(value['name']),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    textField.updateHint(index, value!);
                                  }),
                            ),
                          ),
                        ))),
              ]),
              if (textField.value[SearchBodyProvider.totalTextFields] == 1)
                Container(
                    height: 45,
                    width: 45,
                    color: Colors.purple,
                    child: GestureDetector(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onTap: () {
                        setState(() {
                          listTextFields.add(field(
                              width,
                              textField
                                  .value[SearchBodyProvider.totalTextFields]));
                          textField.addToTextFields(searchFields[0], index);
                          height = height + 65;
                        });
                      },
                    )),
            ]));
  }

  Widget dropDowns(String name, List list, DropDowns type) {
    return Consumer<SearchBodyProvider>(
        builder: (context, data, child) => Row(
              children: [
                SizedBox(
                  width: 16,
                ),
                Text(
                  '$name:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(
                  child: DropdownButton<Map<String, dynamic>?>(
                    underline: Container(),
                    isDense: false,
                    elevation: 0,
                    hint: Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          type == DropDowns.LANG
                              ? language != null
                                  ? language
                                  : list[0]['name']
                              : type == DropDowns.FORMAT
                                  ? format != null
                                      ? format
                                      : list[0]['name']
                                  : sortBy != null
                                      ? sortBy
                                      : list[0]['name'],
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color),
                        )
                      ],
                    ),
                    onChanged: (Map<String, dynamic>? value) {
                      setState(() {
                        if (type == DropDowns.LANG) {
                          language = value!['name'];
                          data.setFilter(value, "langFacet");
                        } else if (type == DropDowns.FORMAT) {
                          format = value!['name'];
                          data.setFilter(value, "docTypeFacet");
                        } else if (type == DropDowns.SORTBY) {
                          sortBy = value!['name'];
                          data.setSortBys(value);
                        }
                      });
                    },
                    items: list.map((value) {
                      return DropdownMenuItem<Map<String, dynamic>?>(
                        value: value,
                        child: Container(
                          child: Text(value['name']),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  width: 8,
                )
              ],
            ));
  }

  Widget campusItems(var value) {
    return Consumer<SearchBodyProvider>(
      builder: (context, data, child) => GestureDetector(
        child: Row(
          children: [
            if (data.selectedCampus.contains(value['name']))
              Icon(
                Icons.check_box,
                color: Colors.purple,
              )
            else
              Icon(
                Icons.crop_square_outlined,
                color: Colors.purple,
              ),
            SizedBox(
              width: 4,
            ),
            Text(value['name']),
            SizedBox(
              width: 8,
            ),
          ],
        ),
        onTap: () {
          data.setCampus(value, deptLocationList);
        },
      ),
    );
  }

  Widget sortByItems(var value) {
    return Consumer<SearchBodyProvider>(
        builder: (context, data, child) => GestureDetector(
              child: Row(
                children: [
                  if (data.sortType == value['code'])
                    Icon(
                      Icons.radio_button_on,
                      color: Colors.purple,
                    )
                  else
                    Icon(
                      Icons.circle_outlined,
                      color: Colors.purple,
                    ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(value['name']),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
              onTap: () {
                data.setSortType(value);
              },
            ));
  }

  getData() {
    setState(() {
      isLoading = true;
    });
    try {
      SearchService.getFullTextSearchWebPage().then((value) {
        if (mounted)
          setState(() {
            var response = jsonDecode(value.body);
            formats = response['docTypeList'];
            languages = response['langList'];
            sortBys = response['sortsList'];
            sortByDir = response['sortTypeList'];
            year = response['limitersList'];
            campus = response['deptList'];
            locations = response['locationList'];
            deptLocationList = response['deptLocationList'];
            searchFields = response['searchFieldsList'];
            _currentRangeValues = RangeValues(
                double.tryParse(year[0]['start'])!,
                double.tryParse(year[0]['end'])!);
            locationsDataSource = LocationsDataSource(locations);
            isLoading = false;
            hasError = false;
          });
      }, onError: (c, v) {
        if (mounted)
          setState(() {
            hasError = true;
            isLoading = false;
          });
      }).timeout(Duration(seconds: 15));
    } on TimeoutException catch (_) {
      if (mounted)
        setState(() {
          hasError = true;
          isLoading = false;
        });
    } catch (_) {
      if (mounted)
        setState(() {
          hasError = true;
          isLoading = false;
        });
    }
  }

  Widget locationsTable() {
    return Theme(
        data: Theme.of(context).copyWith(
            cardColor: Theme.of(context).scaffoldBackgroundColor,
            cardTheme: CardTheme(elevation: 0),
            dividerColor: Colors.purple),
        child: Consumer<SearchBodyProvider>(
            builder: (context, data, child) => Center(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: PaginatedDataTable(
                      showCheckboxColumn: false,
                      showFirstLastButtons: true,
                      columns: <DataColumn>[
                        DataColumn(
                            label: GestureDetector(
                              child: Row(children: [
                                if (data.locations.length == locations.length)
                                  Icon(
                                    Icons.check_box,
                                    color: Colors.purple,
                                  ),
                                if (data.locations.length != locations.length ||
                                    data.locations.isEmpty)
                                  Icon(
                                    Icons.crop_square_outlined,
                                    color: Colors.purple,
                                  ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'selection'.tr,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                )
                              ]),
                              onTap: () {
                                data.setLocations(
                                    locations, false, locations.length);
                              },
                            ),
                            numeric: false),
                      ],
                      source: locationsDataSource!,
                    )))));
  }

  clearAll(SearchBodyProvider provider, double width) {
    setState(() {
      isInit = false;
      language = null;
      sortBy = null;
      height = 115;
      format = null;
      _formKey.currentState!.reset();
      _currentRangeValues = RangeValues(
          double.tryParse(year[0]['start'])!, double.tryParse(year[0]['end'])!);
      locationsDataSource = LocationsDataSource(locations);
    });
    provider.clearAll();
  }
}
