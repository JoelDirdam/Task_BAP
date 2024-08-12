import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:task_bap/helpers/api_helper.dart';

class ApiCallBuilder {
  late String action;
  late Map<String, dynamic> params;
  late ApiEndpoints endpoint;

  ApiCallBuilder();

  ApiCall build() {
    return ApiCall(this);
  }
}

class ApiCall {
  dynamic _action;
  late BuildContext buildContext;
  late Map<String, dynamic> _params;
  late ApiEndpoints _endpoint;

  ApiCall(ApiCallBuilder builder) {
    _action = builder.action;
    _params = builder.params;
    _endpoint = builder.endpoint;
  }

  Map<String, dynamic> get params => _params;

  Map<String, String> _buildHeaders() {
    Map<String, String> headers = {
      'Authorization': dotenv.env['AUTH_TOKEN'] ?? "",
    };

    if (_endpoint == ApiEndpoints.createTask ||
        _endpoint == ApiEndpoints.updateTask) {
      headers['Content-Type'] = 'application/x-www-form-urlencoded';
    }

    return headers;
  }

  Uri _buildUrl() {
    String baseUrl = dotenv.env['API_URL'] ?? "";
    String endpointUrl = _action;

    if ((_endpoint == ApiEndpoints.getTask ||
        _endpoint == ApiEndpoints.updateTask ||
        _endpoint == ApiEndpoints.deleteTask)) {
      // endpointUrl = '$endpointUrl/${_params['task_id']}';
    }

    // Añadir los parámetros como query parameters para todas las solicitudes
    Uri uri = Uri.parse('$baseUrl$endpointUrl');

    if (_endpoint == ApiEndpoints.getTasks ||
        _endpoint == ApiEndpoints.getTask) {
      uri = uri.replace(
          queryParameters:
              _params.map((key, value) => MapEntry(key, value.toString())));
    }

    return uri;
  }

  Future<dynamic> _apiCall(Map<String, dynamic> params) async {
    Uri url = _buildUrl();
    var headers = _buildHeaders();
    http.Response response;

    try {
      switch (_endpoint) {
        case ApiEndpoints.getTasks:
          response = await http.get(url, headers: headers);
          break;
        case ApiEndpoints.getTask:
          response = await http.get(url, headers: headers);
          break;
        case ApiEndpoints.createTask:
          response = await http.post(url, body: params, headers: headers);
          break;
        case ApiEndpoints.updateTask:
          response = await http.put(url, body: params, headers: headers);
          break;
        case ApiEndpoints.deleteTask:
          response = await http.delete(url, headers: headers);
          break;
        default:
          return 'Invalid API action';
      }

      if (response.statusCode < 300) {
        final res = jsonDecode(response.body);
        return res;
      } else {
        return 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> setData(String action, Map<String, dynamic> params) {
    return _apiCall(params);
  }
}
