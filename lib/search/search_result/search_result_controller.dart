import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../search_service.dart';
import 'search_paramters_model.dart';

class SearchResultController extends GetxController {
  bool _isLoading = true,
      _hasError = false,
      _loadMore = false,
      _hasErrorForMore = false,
      _lastPage = false,
      _isComputing = false;
  var _data;
  var paramters;
  int _pageCount = 1;
  int _total = 0;
  List _content = [], _filterList = [];
  int get total => _total;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get loadMore => _loadMore;
  bool get hasErrorForMore => _hasErrorForMore;
  bool get lastPage => _lastPage;

  List get content => _content;
  List get filterList => _filterList;
  ScrollController scrollController = ScrollController();
  @override
  void onInit() {
    super.onInit();
    getData();
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.removeListener(getMoreData);
    scrollController.dispose();
  }

  setIsLoading(bool value) {
    _isLoading = value;
    update();
  }

  setHasError(bool value) {
    _hasError = value;
    update();
  }

  setLoadMore(bool value) {
    _loadMore = value;
    update();
  }

  setHasErrorForMore(bool value) {
    _hasErrorForMore = value;
    update();
  }

  setLastPage(bool value) {
    _lastPage = value;
    update();
  }

  _reset() {
    _pageCount = 1;
    update();
    setIsLoading(true);
    setHasError(false);
    setLoadMore(false);
    setHasErrorForMore(false);
    setLastPage(false);
  }

  getData([SearchParamtersModel? pModel]) async {
    _reset();
    if (pModel == null) {
      paramters = Get.arguments as SearchParamtersModel;
    } else {
      paramters = pModel;
    }
    try {
      await SearchService.search(
              fieldList: paramters.fieldList,
              filters: paramters.filters,
              limiter: paramters.limiter,
              sortField: paramters.sortField!,
              sortType: paramters.sortType!,
              campusLocations: paramters.campusLocations,
              singleLocations: paramters.singleLocations,
              pageCount: _pageCount)
          .then((response) {
        if (response.statusCode == 200) {
          _data = json.decode(response.body);
          _content.addAll(_data['content']);
          _filterList = _data['facetsList'];
          _total = _data['total'];
          setIsLoading(false);
          scrollController.addListener(getMoreData);
          update();
        } else {
          setIsLoading(false);
          setHasError(true);
        }
      }, onError: (c, v) {
        setIsLoading(false);
        setHasError(true);
      }).timeout(Duration(seconds: 20));
    } on TimeoutException catch (_) {
      setIsLoading(false);
      setHasError(true);
    } catch (_) {
      setIsLoading(false);
      setHasError(true);
    }
  }

  void getMoreData() async {
    if (_isComputing == false) {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setHasErrorForMore(false);
        setLoadMore(true);

        if (_pageCount != (_total / 20).ceil()) {
          _pageCount++;
          _isComputing = true;
          SearchService.search(
                  fieldList: paramters.fieldList,
                  filters: paramters.filters,
                  limiter: paramters.limiter,
                  sortField: paramters.sortField!,
                  sortType: paramters.sortType!,
                  campusLocations: paramters.campusLocations,
                  singleLocations: paramters.singleLocations,
                  pageCount: _pageCount)
              .then((response) {
            _isComputing = false;
            if (response.statusCode == 200) {
              _data = json.decode(response.body);
              _content.insertAll(_content.length, _data['content']);
              setLoadMore(false);
              update();
            } else {
              setLoadMore(false);
              setHasErrorForMore(true);
            }
          });
        } else if (_pageCount == 1 && (_total / 20) < 1) {
          setLoadMore(false);
          setLastPage(true);
        }
      }
    }
  }
}
