import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:njust_library/api_service.dart';

class HomeController extends GetxController {
  bool _isLoading = true, _hasError = false;

  List _topCirculation = [], _topBooks = [], _topTenBooks = [];

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  List get topCirculation => _topCirculation;
  List get topBooks => _topBooks;
  List get topTenBooks => _topTenBooks;

  @override
  void onInit() {
    super.onInit();
    getDashBoard(true);
  }

  setIsLoading(bool value) {
    _isLoading = value;
    update();
  }

  setHasError(bool value) {
    _hasError = value;
    update();
  }

  setTopTenBooks(value) {
    _topTenBooks = value;
    update();
  }

  setTopCirculation(value) {
    _topCirculation = value;
    update();
  }

  setTopBooks(value) {
    _topBooks = value;
    update();
  }

  getDashBoard(bool isInit) async {
    if (!isInit) setIsLoading(true);
    setHasError(false);
    try {
      await APIService.getDashboard().then((value) {
        setIsLoading(false);
        setTopBooks(value['topBooks']);
        setTopCirculation(value['circulatory']);
        setTopTenBooks(value['topTen']);
      }).timeout(Duration(seconds: 10));
    } on TimeoutException catch (_) {
      setHasError(true);
      setIsLoading(false);
    } catch (_) {
      setHasError(true);
      setIsLoading(false);
    }
  }

  static Widget networkError(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.width * 0.45,
                child: SvgPicture.asset(NO_NETWORK),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Network error',
                style: TextStyle(color: Colors.purple),
              )
            ]));
  }

  static Widget progressIndciator([bool? isResult]) {
    if (isResult != null) {
      return Center(
        child: CircularProgressIndicator(
            strokeWidth: 1,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.purple)),
      );
    }
    return Center(
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.purple)),
    );
  }

  static Widget noInfo() {
    return Center(
        child: Container(
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
                    'No information',
                    style: TextStyle(color: Colors.purple),
                  )
                ])));
  }
}
