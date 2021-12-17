import 'package:flutter/material.dart';
import 'package:njust_library/search/types_of_search.dart/full_text_search_provider.dart';
import 'package:provider/provider.dart';

class FullTextSearch extends StatefulWidget {
  @override
  _FullTextSearchState createState() => _FullTextSearchState();
}

class _FullTextSearchState extends State<FullTextSearch>
    with AutomaticKeepAliveClientMixin {
  double height = 190;

  String hint = 'Any';
  bool isInit = false;
  List<Widget> listTextFields = [];
  Map<int, dynamic> data = {};
  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    if (!isInit) {
      isInit = true;
      listTextFields.add(field(width, 0));
      listTextFields.add(field(width, 1));
    }

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Container(
              height: height,
              child: ListView.builder(
                  itemCount: listTextFields.length,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return listTextFields[index];
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget field(double width, int index) {
    return Consumer<FullTextSearchProvider>(
        builder: (context, textField, child) =>
            Column(key: ObjectKey(index.toString()), children: [
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
                            color: textField.value[FullTextSearchProvider
                                        .textFields][index][1] ==
                                    'AND'
                                ? Colors.purple
                                : Colors.transparent,
                            border: Border.all(color: Colors.purple)),
                        child: Text(
                          'AND',
                          style: TextStyle(
                              color: textField.value[FullTextSearchProvider
                                          .textFields][index][1] ==
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
                            color: textField.value[FullTextSearchProvider
                                        .textFields][index][1] ==
                                    'OR'
                                ? Colors.purple
                                : Colors.transparent,
                            border: Border.all(color: Colors.purple)),
                        child: Text('OR',
                            style: TextStyle(
                                color: textField.value[FullTextSearchProvider
                                            .textFields][index][1] ==
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
                              textField.addToTextFields();
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
                        child: TextField(
                          cursorColor: Colors.purple,
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
                              child: DropdownButton<String>(
                                  underline: Container(),
                                  isDense: false,
                                  elevation: 0,
                                  hint: Row(
                                    children: [
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        textField.value[FullTextSearchProvider
                                            .textFields][index][0],
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .color),
                                      )
                                    ],
                                  ),
                                  items: <String>[
                                    'Any',
                                    'Title',
                                    'Author',
                                    'Subject',
                                    'ISBN',
                                    'Classification',
                                    'Call No.',
                                    'Publisher',
                                    'Series'
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        child: Text(value),
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
              if (textField.value['totalTextFields'] == 1)
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
                          listTextFields.add(
                              field(width, textField.value['totalTextFields']));
                          textField.addToTextFields();
                          height = height + 125;
                        });
                      },
                    )),
            ]));
  }

  @override
  bool get wantKeepAlive => true;
}
