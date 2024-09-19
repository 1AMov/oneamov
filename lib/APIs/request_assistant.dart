import 'dart:convert';

import 'package:http/http.dart' as http;

import 'request_method.dart';

class RequestAssistant {
  static Future<dynamic> onRequest(
      {required String endpoint,
      required RequestMethod requestMethod,
      Map<String, String>? headers,
      Object? body}) async {
    try {
      Uri url = Uri.parse(endpoint);

      http.Response? response;

      if (requestMethod == RequestMethod.GET) {
        response = await http.get(url, headers: headers);
      } else {
        response = await http.post(url, headers: headers, body: body);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        String jsonData = response.body;

        return jsonDecode(jsonData);
      } else {
        print("=================DID NOT GET 200=================");
        print(response.statusCode);
        print(response.body);
        print("=================DID NOT GET 200=================");
        return "Failed";
      }
    } catch (e) {
      print(e.toString());

      return "Failed";
    }
  }
}
