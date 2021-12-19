import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:njust_library/search/search_controller.dart';
import 'package:njust_library/search/types_of_search.dart/fulltext/full_text_search_provider.dart';
import 'package:provider/provider.dart';
import 'search_service.dart';
import 'types_of_search.dart/fulltext/full_text_search.dart';

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
                            elevation: 0,
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
                          body: FullTextSearch(),
                        )))));
  }
}
