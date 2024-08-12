import 'dart:developer';

import 'package:task_bap/builder/api_builder.dart';

enum ApiEndpoints {
  getTasks,
  getTask,
  createTask,
  updateTask,
  deleteTask,
}

class Api {
  static String getEndpoint(ApiEndpoints endpoint, [String? id]) {
    switch (endpoint) {
      case ApiEndpoints.getTasks:
        return '/tasks';
      case ApiEndpoints.getTask:
        return '/tasks/$id';
      case ApiEndpoints.createTask:
        return '/tasks';
      case ApiEndpoints.updateTask:
        return '/tasks/$id';
      case ApiEndpoints.deleteTask:
        return '/tasks/$id';
      default:
        return '';
    }
  }

  static Future<ApiResponse> callApi(
      ApiEndpoints endpoint, dynamic params) async {
    ApiCallBuilder apiCallBuilder = ApiCallBuilder();

    String? taskId = params['task_id'] ?? null;
    apiCallBuilder.action = getEndpoint(endpoint, taskId);
    apiCallBuilder.params = params;
    apiCallBuilder.endpoint = endpoint; // Asegúrate de asignar el endpoint

    ApiCall apiCall = apiCallBuilder.build();
    final response =
        await apiCall.setData(getEndpoint(endpoint, taskId), apiCall.params);

    return validateResponse(response, endpoint);
  }

  static ApiResponse validateResponse(dynamic response, ApiEndpoints endpoint) {
    bool success = false;
    String message = '';
    dynamic data;

    if (response is Map) {
      if (endpoint == ApiEndpoints.createTask &&
          response.containsKey('detail')) {
        success = true;
        message = response['detail'];
        data = response['task'];
      } else {
        success = response['success'] ?? false;
        data = response;
      }
    } else if (response is List) {
      success = true;
      data = response;
    } else if (response is String) {
      message = response;
    }

    return ApiResponse(success: success, message: message, data: data);
  }
}

class ApiResponse {
  final bool success;
  final String message;
  final dynamic data;

  ApiResponse(
      {required this.success, required this.message, required this.data});

  bool get isList => data is List;
  bool get isMap => data is Map<String, dynamic>;

  List<Map<String, dynamic>> get dataList =>
      isList ? List<Map<String, dynamic>>.from(data) : [];

  Map<String, dynamic> get dataMap =>
      isMap ? Map<String, dynamic>.from(data) : {};
}
