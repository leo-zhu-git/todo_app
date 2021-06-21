import 'package:dio/dio.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'dart:async';
import '../config/index.dart';

Future request(url, {formData}) async {
  try {
    Response response;
    Dio dio = new Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    var httpUrl;

    DbHelper helper = DbHelper();

    //dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
    if (formData == null) {
      print(servicePath[url]);
      String userID = await helper.getUserID();
      httpUrl = servicePath[url] + "?id=" + userID;
      print('form data is null');
      print(httpUrl);
      print(servicePath[url]);
      response = await dio.post(httpUrl);
    } else {
      print(servicePath[url]);
      String userID = await helper.getUserID();
      httpUrl = servicePath[url] + "?id=" + userID;
      print('form data is not null');
      print(httpUrl);
      print(servicePath[url]);
      response = await dio.post(httpUrl, data: formData);
    }

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(
          'back end interface error, please check the code and server running status');
    }
  } catch (e) {
    return print('error::::${e}');
  }
}
