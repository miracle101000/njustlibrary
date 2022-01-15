import 'dart:convert';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'search/search_service.dart';

const String BASE_URL = "http://202.119.83.14:8080/uopac/opac/";

const NO_DATA = 'assets/images/nodata.svg';
const NO_NETWORK = 'assets/images/books.svg';

class APIService {
  static Future<Map<String, dynamic>> getDashboard() async {
    http.Response response =
        await http.get(Uri.parse("${BASE_URL}ajax_top_lend_shelf.php"));

    Map<String, dynamic> finalResult = {};

    if (response.statusCode == 200) {
      finalResult['circulatory'] =
          _topBooks(response, "search_container_center");
      finalResult['topBooks'] = _topBooks(response, "search_container_right");
      finalResult['topTen'] = await _getTopQueries();
      return finalResult;
    } else {
      throw ('Network error');
    }
  }

  static Future<String?> getImage(String query) async {
    String image = 'image';
    var response =
        await http.get(Uri.parse('${BASE_URL}ajax_isbn_marc_no.php?$query'));

    if (response.statusCode == 200) {
      image = json.decode(response.body)['image'].replaceAll('\\', "");
    }
    return image;
  }

  static Future<List> _getTopQueries() async {
    List data = [];
    var response = await http.get(Uri.parse('${BASE_URL}ajax_topten_adv.php'));
    var document = parse(response.body);
    document.body!.children.forEach((element) {
      data.add(
          {'name': element.text.trim(), 'link': element.attributes['href']});
    });
    return data;
  }

  static List _topBooks(http.Response response, String elementId) {
    var document = parse(response.body).getElementById(elementId);
    List<Map<String, String>> results = [];

    String title = document!.children[0].innerHtml;

    document.children[2].text.trim().split("\n").forEach((element) {
      results.add({'name': element.trim(), 'link': '', 'image': ''});
    });
    List<String> data =
        document.getElementsByTagName('ul')[0].innerHtml.trim().split('\n');
    for (int i = 0; i < data.length; i++) {
      var linkExtraction = parse(data[i].trim());
      results[i].update('link', (value) {
        value = linkExtraction
            .getElementsByTagName('li')[0]
            .nodes[0]
            .attributes['href']!;
        return value;
      });
    }
    results.forEach((element) async {
      await _imageUrl(element['name']!.trim()).then((image) {
        element.update('image', (value) {
          value = image;
          return value;
        });
      });
    });
    return [title, results];
  }

  static Future<String> _imageUrl(String name) async {
    String image =
        'https://100scopenotes.com/files/2016/02/no_book_cover_lg.jpg';
    await SearchService.getAnySearch(name).then((value) async {
      var data = json.decode(value.body)['content'];
      if (data != null && data.length != 0) {
        String isbn = data[0]['isbn'];
        String marcRecNo = data[0]['marcRecNo'];
        await APIService.getImage('marc_no=$marcRecNo&isbn=$isbn')
            .then((value) {
          image = value!.isEmpty
              ? 'https://100scopenotes.com/files/2016/02/no_book_cover_lg.jpg'
              : value;
        });
      }
    });
    return image;
  }

  static Future<List> getBookInfo(String path) async {
    await Future.delayed(Duration(seconds: 1));
    var response = await http.get(Uri.parse('$BASE_URL$path'));
    var document = parse(response.body.trim());
    //Book details
    List<List<String>> data = [];
    Map<String, dynamic> extract = {};
    document.body!.children[21].children[0].children[1].children[1].children[1]
        .children[0].children[0].children[0].children[1].children
        .forEach((element) {
      data.add(element.text.split('\n'));
    });
    data.forEach((element) {
      if (element[1].trim().isNotEmpty && element[2].trim().isNotEmpty)
        extract[element[1].trim()] = element[2].trim();
    });


    // Table of availability
    int rowLength = document.body!.children[21].children[0].children[1]
        .children[2].children[1].children[1].children[0].children.length;
    List table = [];
    List keys = [];
    if (rowLength > 2) {
      for (int x = 0; x < rowLength; x++) {
        Map<String, dynamic> result = {};
        var temp = document.body!.children[21].children[0].children[1]
            .children[2].children[1].children[1].children[0].children[x];
        for (int y = 0; y < temp.children.length; y++) {
          if (x == 0) {
            keys.add(temp.children[y].text.trim());
          } else {
            result[keys[y]] = temp.children[y].text.trim();
          }
        }
        if (x != 0) table.add(result);
      }
    }
    return [extract, table];
  }
}
