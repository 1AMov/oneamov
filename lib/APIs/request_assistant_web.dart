import 'dart:convert';
import 'dart:html' as html;

import 'request_method.dart';

class RequestAssistantWeb {
  static Future<dynamic> onRequest(
      {required String endpoint,
      required RequestMethod requestMethod,
      Map<String, String>? headers,
      Object? body}) async {
    try {
      var request = html.HttpRequest();

      if (requestMethod == RequestMethod.GET) {
        request.open('GET', endpoint);
      } else if (requestMethod == RequestMethod.POST) {
        request.open('POST', endpoint);
      } else if (requestMethod == RequestMethod.PUT) {
        request.open('PUT', endpoint);
      } else if (requestMethod == RequestMethod.DELETE) {
        request.open('DELETE', endpoint);
      } else {
        throw UnsupportedError('Request method not supported');
      }

      // Set headers if provided
      if (headers != null) {
        headers.forEach((key, value) {
          request.setRequestHeader(key, value);
        });
      }

      // Send the request with or without the body
      if (body != null &&
          (requestMethod == RequestMethod.POST ||
              requestMethod == RequestMethod.PUT)) {
        request.send(body);
      } else {
        request.send();
      }

      // Wait for the request to complete
      await request.onLoadEnd.first;

      // Check the status code for success
      if (request.status == 200 || request.status == 201) {
        String? jsonData = request.responseText;

        return jsonDecode(jsonData!);
      } else {
        print("Failed: \nSTATUS: ${request.status}, \nDETAILS: ${request}");
        return "Failed";
      }
    } catch (e) {
      print("Failed: $e");

      return "Failed";
    }
  }
}
