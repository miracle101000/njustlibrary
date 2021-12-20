import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:njust_library/base_screen.dart';
import 'package:njust_library/book_info_page.dart';
import 'package:njust_library/search/search_screen.dart';
import 'package:provider/provider.dart';
import 'GlobalBindings.dart';
import 'search/search_body/search_body_provider.dart';
import 'search/search_result/search_result.dart';
import 'search/search_result/search_result_provider.dart';
import 'theme/app_theme.dart';

void main() async {
  GlobalBindings().dependencies();
  configLoading();
  runApp(MyApp());
}

void configLoading() {
  EasyLoading.instance..userInteractions = false;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SearchBodyProvider()),
          ChangeNotifierProvider(create: (_) => SearchResultProvider()),
        ],
        child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                currentFocus.focusedChild!.unfocus();
              }
            },
            child: GetMaterialApp(
              title: 'Flutter Demo',
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: ThemeMode.system,
              debugShowCheckedModeBanner: false,
              builder: EasyLoading.init(),
              home: BaseScreen(),
              getPages: [
                GetPage(
                    name: BookInfoPage.routeName, page: () => BookInfoPage()),
                GetPage(
                    name: SearchScreen.routeName, page: () => SearchScreen()),
                GetPage(
                    name: SearchResult.routeName, page: () => SearchResult()),
              ],
            )));
  }
}
