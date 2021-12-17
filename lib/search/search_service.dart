import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api_service.dart';

class SearchService {
  static Future<http.Response> getAnySearch(String query) async {
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
}
