import 'dart:convert';

import 'package:flutter/foundation.dart';
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
          "locale": "zh_CN",
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
  }) async {
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
          "pageCount": "1",
          "locale": "zh_CN",
          "first": "true",
          "unionFilters": [
            {'fieldName': "locationUnionFacet", "values": unionFilters}
          ],
        }));
  }

  static Future<http.Response> getFullTextSearchWebPage() async {
    return http.get(Uri.parse('${BASE_URL}ajax_adv_info.php'));
  }
}

Future<List> _computeLocations(List paramters) async {
  List result = [];
  print('computing');
  result.addAll(paramters[0]);
  for (var data in paramters[1]) {
    result.add(data['code']);
  }
  return result.toSet().toList();
}
