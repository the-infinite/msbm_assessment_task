import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:msbm_assessment_test/core/base.dart';
import 'package:msbm_assessment_test/core/task/concurrency.dart';
import 'package:msbm_assessment_test/helper/app_constants.dart';
import 'package:msbm_assessment_test/helper/data.dart';

/// A helper function we use to do things right.
class MultipartBody {
  String key;
  XFile? file;

  MultipartBody(this.key, this.file);
}

/// A class that represents the mechanic used to embody responses as they are
/// sent to the repositories and controllers.
class AppResponse {
  final int statusCode;
  final int errorCode;
  final String message;
  final List<int> bytes;
  final dynamic data;

  // This is fair enough.
  AppResponse({
    required this.statusCode,
    required this.errorCode,
    required this.message,
    required this.bytes,
    this.data,
  });

  /// Was this response successful?
  bool get isOk => statusCode <= 201 && statusCode > 199;

  /// The status code of this response.
  int get status => statusCode;
}

/// The... object responsible for making API calls to the backend.
class AppClient {
  final _baseClient = http.Client();

  // Now for the ones that are subject to transient change.
  String _token = "";
  String _userId = "";
  String _userToken = "";
  double _latitude = double.infinity;
  double _longitude = double.infinity;
  bool _isTestMode = false;

  // A useful constructor to keep around for now that is.
  AppClient();

  /// A helper function used to set the authorization token to something after
  /// we have identified an authenticated user.
  void setToken(String token) {
    _token = token;
  }

  /// A helper function used to set whether or not this is operating in test
  /// mode.
  void setTestMode(bool isTest) {
    _isTestMode = isTest;
  }

  /// Set the longitude and latitude.
  void setPosition(double longitude, double latitude) {
    _longitude = longitude;
    _latitude = latitude;
  }

  // Used to update the user ID
  void setUserId(String userId) {
    _userId = userId;
  }

  // Used to update the user token.
  void setUserToken(String userToken) {
    _userToken = userToken;
  }

  /// A helper function used to reset all the relevant client side variables.
  void resetVariables() {
    _token = "";
    _userId = "";
    _userToken = "";
    _latitude = double.infinity;
    _longitude = double.infinity;
  }

  /// A helper function used to compose the headers that accompany every request.
  Future<Map<String, String>> _composeHeaders([bool useBase = true]) async {
    final Map<String, String> data = {
      'Content-Type': 'application/json; charset=UTF-8',
      if (useBase) 'Accept': 'application/json',
    };

    //? If there is an authenticated user...
    if (_token.isNotEmpty) {
      data[AppConstants.session] = _token;
      data[AppConstants.device] = (await getDeviceData()).toHTTPHeader(_userId, _userToken);
    }

    //? If there is latitude set...
    if (_latitude != double.infinity) {
      data[AppConstants.latitude] = _latitude.toString();
      data[AppConstants.longitude] = _longitude.toString();
    }

    //* Return the generated list of headers.
    return data;
  }

  /// A Utility function used to parse a response according to the specifications
  /// present in the server-side.
  AppResponse _parseResponse(http.Response response, int duration, [bool canLog = true]) {
    // We do it like this.
    String message = "";
    dynamic data;
    int status = response.statusCode;

    // First, do this much.
    try {
      data = jsonDecode(response.body);

      // Extract the message from this place.
      message = data["report"];

      // Take the status inside here too.
      status = data["code"];

      // Extract the data from this place.
      data = data["data"];
    } catch (e) {
      data = response.body;
    }

    // Then we do this.
    try {
      //? Only log here if we are in debug mode.
      if (canLog) {
        AppRegistry.debugLog(
          "AppClient.Request\n::[${response.request?.method} ${response.request?.url.toString()} in ${duration}ms]\n(${response.statusCode}/$status)\n${response.body}",
        );
      }

      // Return this one.
      return AppResponse(
        statusCode: response.statusCode,
        errorCode: status,
        message: message,
        bytes: response.bodyBytes.toList(),
        data: data,
      );
    } catch (e) {
      AppRegistry.debugLog("Error: $e", "AppClient.Request");
    }

    // We do this.
    return _parseError(Exception("Unable to reach our services right now"));
  }

  /// A utility function used to parse an error's response according to whatever
  /// specifications that the processes use.
  AppResponse _parseError(dynamic error) {
    try {
      return AppResponse(
        statusCode: 600,
        errorCode: 600,
        message: error?.message ?? error?.toString(),
        bytes: const <int>[],
      );
    } catch (e) {
      return AppResponse(
        statusCode: 600,
        errorCode: 600,
        message: error?.toString() ?? e.toString(),
        bytes: const <int>[],
      );
    }
  }

  /// A helper function used to send a request with MultipartData. By default,
  /// this would send a post request since the assumption is that is what you
  /// would prefer sending using this means typically.
  Future<AppResponse> sendMultipart(
    String uri,
    List<MultipartBody> bodyChunks, {
    bool useBase = true,
    String method = "POST",
    Map<String, String> body = const {},
    Map<String, String> extraHeaders = const {},
    ProcessFn<AppResponse>? processFn,
    PostProcessCallback? toProcess,
  }) async {
    // This is fine too.
    final response = await AppRegistry.scheduleTask(
      Task(
        computation: () async {
          //? First, fetch the HTTP headers to use for this request.
          final headers = await _composeHeaders(useBase);
          headers.addAll(extraHeaders);

          //? Next, make the actual request.
          final request = http.MultipartRequest(
            method,
            Uri.parse("${useBase ? _isTestMode ? AppConstants.testBaseUrl : AppConstants.liveBaseUrl : ""}$uri"),
          );

          //? Bind the headers to this request.
          request.headers.addAll(headers);

          //? Add each chunk to this one.
          for (MultipartBody chunk in bodyChunks) {
            if (chunk.file != null) {
              File file = File(chunk.file!.path);
              request.files.add(http.MultipartFile(
                chunk.key,
                file.readAsBytes().asStream(),
                file.lengthSync(),
                filename: file.path.split('/').last,
              ));
            }
          }

          //? Add all the body if there is shtick to add....
          request.fields.addAll(body);

          // Take the timestamp of when this request was originally sent.
          final start = DateTime.now();

          // This is fine.
          final response = await http.Response.fromStream(await request.send());

          // This is fine.
          final end = DateTime.now();

          //? Return the results we obtained from this operation.
          return _parseResponse(response, end.difference(start).abs().inMilliseconds, useBase);
        },
        onError: (error, [stackTrace]) {
          AppRegistry.debugLog(error.toString());
          AppRegistry.debugLogStack(stackTrace: stackTrace);
          return _parseError(error);
        },
        processFn: processFn,
      ).weave(toProcess),
    );

    // We do it like this.
    return response;
  }

  /// A helper function used to send a GET request to a server using the
  /// underlying task scheduler.
  Future<AppResponse> get(
    String uri, {
    bool useBase = true,
    Map<String, String> extraHeaders = const {},
    ProcessFn<AppResponse>? processFn,
    PostProcessCallback? toProcess,
  }) async {
    // This is fine too.
    final response = await AppRegistry.scheduleTask(
      Task(
        computation: () async {
          //? First, fetch the HTTP headers to use for this request.
          final headers = await _composeHeaders(useBase);

          // This is fine.
          headers.addAll(extraHeaders);

          // Take the timestamp of when this request was originally sent.
          final start = DateTime.now();

          //? Next, make the actual request.
          final request = await _baseClient.get(
            Uri.parse("${useBase ? _isTestMode ? AppConstants.testBaseUrl : AppConstants.liveBaseUrl : ""}$uri"),
            headers: headers,
          );

          // This is fine.
          final end = DateTime.now();

          //? Return the results we obtained from this operation.
          return _parseResponse(request, end.difference(start).abs().inMilliseconds, useBase);
        },
        onError: (error, [stackTrace]) {
          AppRegistry.debugLog(error.toString());
          AppRegistry.debugLogStack(stackTrace: stackTrace);

          // This is fine.
          return _parseError(error);
        },
        processFn: processFn,
      ).weave(toProcess),
    );

    // We do it like this.
    return response;
  }

  /// A helper function used to send a POST request to a server using the
  /// underlying task scheduler.
  Future<AppResponse> post(
    String uri,
    dynamic body, {
    bool useBase = true,
    Map<String, String> extraHeaders = const {},
    ProcessFn<AppResponse>? processFn,
    PostProcessCallback? toProcess,
  }) async {
    // This is fine too.
    final response = await AppRegistry.scheduleTask(
      Task(
        computation: () async {
          //? First, fetch the HTTP headers to use for this request.
          final headers = await _composeHeaders(useBase);
          headers.addAll(extraHeaders);

          // Take the timestamp of when this request was originally sent.
          final start = DateTime.now();

          //? Next, make the actual request.
          final request = await _baseClient.post(
            Uri.parse("${useBase ? _isTestMode ? AppConstants.testBaseUrl : AppConstants.liveBaseUrl : ""}$uri"),
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );

          // This is fine.
          final end = DateTime.now();

          //? Return the results we obtained from this operation.
          return _parseResponse(request, end.difference(start).abs().inMilliseconds, useBase);
        },
        onError: (error, [stackTrace]) {
          AppRegistry.debugLog(error.toString());
          AppRegistry.debugLogStack(stackTrace: stackTrace);
          return _parseError(error);
        },
        processFn: processFn,
      ).weave(toProcess),
    );

    // We do it like this.
    return response;
  }

  /// A helper function used to send a PUT request to a server using the
  /// underlying task scheduler.
  Future<AppResponse> put(
    String uri,
    dynamic body, {
    bool useBase = true,
    Map<String, String> extraHeaders = const {},
    ProcessFn<AppResponse>? processFn,
    PostProcessCallback? toProcess,
  }) async {
    // This is fine too.
    final response = await AppRegistry.scheduleTask(
      Task(
        computation: () async {
          //? First, fetch the HTTP headers to use for this request.
          final headers = await _composeHeaders(useBase);
          headers.addAll(extraHeaders);

          // Take the timestamp of when this request was originally sent.
          final start = DateTime.now();

          //? Next, make the actual request.
          final request = await _baseClient.put(
            Uri.parse("${useBase ? _isTestMode ? AppConstants.testBaseUrl : AppConstants.liveBaseUrl : ""}$uri"),
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );

          // Take the timestamp of when this request was originally sent.
          final end = DateTime.now();

          //? Return the results we obtained from this operation.
          return _parseResponse(request, end.difference(start).abs().inMilliseconds, useBase);
        },
        onError: (error, [stackTrace]) {
          AppRegistry.debugLog(error.toString());
          AppRegistry.debugLogStack(stackTrace: stackTrace);

          // Return this error app response.
          return _parseError(error);
        },
        processFn: processFn,
      ).weave(toProcess),
    );

    // Return the parsed response.
    return response;
  }

  /// A helper function used to send a PATCH request to a server using the
  /// underlying task scheduler.
  Future<AppResponse> patch(
    String uri, {
    bool useBase = true,
    dynamic body,
    Map<String, String> extraHeaders = const {},
    ProcessFn<AppResponse>? processFn,
    PostProcessCallback? toProcess,
  }) async {
    // This is fine too.
    final response = await AppRegistry.scheduleTask(
      Task(
        computation: () async {
          //? First, fetch the HTTP headers to use for this request.
          final headers = await _composeHeaders(useBase);
          headers.addAll(extraHeaders);

          // Take the timestamp of when this request was originally sent.
          final start = DateTime.now();

          //? Next, make the actual request.
          final request = await _baseClient.patch(
            Uri.parse("${useBase ? _isTestMode ? AppConstants.testBaseUrl : AppConstants.liveBaseUrl : ""}$uri"),
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );

          // Take the timestamp of when this request was originally sent.
          final end = DateTime.now();

          //? Return the results we obtained from this operation.
          return _parseResponse(request, end.difference(start).abs().inMilliseconds, useBase);
        },
        onError: (error, [stackTrace]) {
          AppRegistry.debugLog(error.toString());
          AppRegistry.debugLogStack(stackTrace: stackTrace);

          // Return this error app response.
          return _parseError(error);
        },
        processFn: processFn,
      ).weave(toProcess),
    );

    // Return the parsed response.
    return response;
  }

  /// A helper function used to send a PUT request to a server using the
  /// underlying task scheduler.
  Future<AppResponse> delete(
    String uri, {
    dynamic body,
    bool useBase = true,
    Map<String, String> extraHeaders = const {},
    ProcessFn<AppResponse>? processFn,
    PostProcessCallback? toProcess,
  }) async {
    // This is fine too.
    final response = await AppRegistry.scheduleTask(
      Task(
        computation: () async {
          //? First, fetch the HTTP headers to use for this request.
          final headers = await _composeHeaders(useBase);
          headers.addAll(extraHeaders);

          // Take the timestamp of when this request was originally sent.
          final start = DateTime.now();

          //? Next, make the actual request.
          final request = await _baseClient.delete(
            Uri.parse("${useBase ? _isTestMode ? AppConstants.testBaseUrl : AppConstants.liveBaseUrl : ""}$uri"),
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );

          // Take the timestamp of when this request was originally sent.
          final end = DateTime.now();

          //? Return the results we obtained from this operation.
          return _parseResponse(request, end.difference(start).abs().inMilliseconds, useBase);
        },
        onError: (error, [stackTrace]) {
          AppRegistry.debugLog(error.toString());
          AppRegistry.debugLogStack(stackTrace: stackTrace);

          // Return this error app response.
          return _parseError(error);
        },
        processFn: processFn,
      ).weave(toProcess),
    );

    // Return the parsed response.
    return response;
  }
}