import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:task_bap/helpers/nav_context.dart';

class ApiCallBuilder {
  late String action;
  late Map<String, dynamic> params;
  Map<String, String>? headers;

  ApiCallBuilder();

  ApiCall build() {
    return ApiCall(this);
  }
}

class ApiCall {
  dynamic _action;
  late BuildContext buildContext;
  late Map<String, dynamic> _params;
  Map<String, String>? _headers;

  ApiCall(ApiCallBuilder builder) {
    _action = builder.action;
    _params = builder.params;
    _headers = builder.headers;
    buildContext = NavContext.navigatorKey.currentContext!;
  }

  Map<String, dynamic> get params => _params;

  Future _apiCall(Map<String, dynamic> params, String action) async {
    Map<String, dynamic> apiParams = {...params};
    apiParams['key'] = dotenv.env['KEY'] ?? "";
    apiParams['action'] = action;

    try {
      Uri url;

      if (kReleaseMode) {
        url = Uri.https(dotenv.env['URL_API'] ?? "", action, params);
      } else {
        if (dotenv.env['URL_API'] == "http://192.168.0.187/apispalive/") {
          url = Uri.parse("${dotenv.env['URL_API']}$action");
        } else {
          url = Uri.https(dotenv.env['URL_API'] ?? "", action, params);
        }
      }

      var response = await http.post(url, body: apiParams, headers: _headers);

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        return res;
      } else {
        return 'Server error.';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> setData(String action, Map<String, dynamic> params) {
    return _apiCall(params, action);
  }
}
