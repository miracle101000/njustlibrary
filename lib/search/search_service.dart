import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../api_service.dart';

class SearchService {
  static Future<http.Response> getAnySearch(
    String query, {
    List? fieldList,
  }) async {
    return http.post(Uri.parse('${BASE_URL}ajax_search_adv.php'),
        headers: <String, String>{
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "searchWords": [
            {
              "fieldList": [
                {"fieldCode": "any", "fieldValue": query}
              ]
            }
          ],
          "filters": [],
          "limiter": [],
          "sortField": "relevance",
          "sortType": "desc",
          "pageSize": "20",
          "pageCount": "1",
          "locale": Get.locale.toString(),
          "first": "true"
        }));
  }

  static Future<http.Response> search({
    required List fieldList,
    required List filters,
    required List limiter,
    required String sortField,
    required String sortType,
    required List campusLocations,
    required List singleLocations,
    required int pageCount,
  }) async {
    //Isolate created
    List unionFilters =
        await compute(_computeLocations, [campusLocations, singleLocations]);
    return http.post(Uri.parse('${BASE_URL}ajax_search_adv.php'),
        headers: <String, String>{
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "searchWords": [
            {
              "fieldList": fieldList,
            }
          ],
          "filters": filters,
          "limiter": limiter,
          "sortField": sortField,
          "sortType": sortType,
          "pageSize": "20",
          "pageCount": pageCount.toString(),
          "locale": Get.locale.toString(),
          "first": "true",
          "unionFilters": [
            {'fieldName': "locationUnionFacet", "values": unionFilters}
          ],
        }));
  }

  static Future<http.Response> getFullTextSearchWebPage() async {
    http.Response? data;
    await getlocale(Get.locale.toString()).then((cookie) async {
      data = await http.get(
        Uri.parse('${BASE_URL}ajax_adv_info.php'),
        headers: <String, String>{"Cookie": cookie!},
      );
    });
    return data!;
  }

  static Future<String?> getlocale(String locale) async {
    var data = await http.get(Uri.parse(
        "http://202.119.83.14:8080/uopac/locale/ajax_change_locale.php?lan=$locale"));
    print(data.headers['set-cookie']);
    return data.headers['set-cookie'].toString().split(';')[0].trim();
  }
}

//Inside the isolate function
Future<List> _computeLocations(List paramters) async {
  List result = [];
  result.addAll(paramters[0]);
  for (var data in paramters[1]) {
    result.add(data['code']);
  }
  return result.toSet().toList();
}
