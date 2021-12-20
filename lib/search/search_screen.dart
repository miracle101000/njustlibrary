import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:njust_library/search/search_body/search_body_provider.dart';
import 'package:njust_library/search/search_controller.dart';
import 'package:provider/provider.dart';

import 'search_body/search_body.dart';

class SearchScreen extends StatelessWidget {
  static const routeName = '/search-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            bottom: true,
            child: GetBuilder<SearchController>(
                builder: (controller) => Scaffold(
                      resizeToAvoidBottomInset: false,
                      appBar: AppBar(
                        elevation: 0,
                        shadowColor: Colors.grey,
                        title: Text(
                          'Search',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color),
                        ),
                        leading: BackButton(
                          color: Colors.purple,
                          onPressed: () {
                            Provider.of<SearchBodyProvider>(context,
                                    listen: false)
                                .clearAll();
                            Get.back();
                          },
                        ),
                      ),
                      body: SearchBody(),
                    ))));
  }
}
