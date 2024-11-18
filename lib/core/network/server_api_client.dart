import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:danh_ba_c06_app/core/network/network_info.dart';
import 'package:danh_ba_c06_app/core/util/logger/logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;

// Thiết lập các phương thức gọi get, post, delete, patch,..
class ServerApiClient {
  final NetworkInfoRepository networkInfoRepository;

  String? serverScheme = 'https';
  String? serverAuthority = 'api-psa.gmobile.vn';
  int? serverPort = 443;

  ServerApiClient({
    required this.networkInfoRepository,
  });
  // Định nghĩa các tham số mã hóa
  final String algorithm = 'AES/CBC/PKCS7Padding';
  final key = encrypt.Key.fromBase16(
      '6dae14c0822b82f9a9afd4c08c5f013daf12fed90bd084848444f16e102d3f23');
  final iv = encrypt.IV.fromBase16('1b5fa63da5130be7d0d2cdad4b82d329');


  // Mã hóa dữ liệu trước khi gửi về server
  String encryptPayloadBody(Map<String, dynamic> data) {

    final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
    final encryptedData = encrypter.encrypt(jsonEncode(data), iv: iv);
    return encryptedData.base16;
  }

  // Giải mã dữ liệu nhận về từ server
  Map<String, dynamic> decryptPayloadBody(String payload,
      {String method = ''}) {
    final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
    final decryptedData = encrypter.decrypt16(payload, iv: iv);

    if (method != 'GET') {
      return jsonDecode(decryptedData) as Map<String, dynamic>;
    } else {
      // For GET requests, handle query parameters as per your logic
      final queryParams = Uri.splitQueryString(decryptedData);
      return queryParams;
    }
  }

  // Your methods for API calls go here, using the baseUrl configured above
  final Map<String, String> _authHeader = {};
  Map<String, String> get authHeader => _authHeader;

  // các phương thức có cấu trúc tương tự nhau
  // Phương thức GET
  Future<http.Response> get(
    path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    // Thiết lập tham số truyền
    final url = Uri(
      scheme: serverScheme,
      host: serverAuthority,
      port: serverPort,
      path: path,
      queryParameters: queryParameters,
    );

    // Thiết lập header
    final Map<String, String> allHeaders = _authHeader;
    if (headers != null) {
      allHeaders.addAll(headers);
    }
    if (!allHeaders.containsKey('Content-Type')) {
      allHeaders['Content-Type'] = 'application/json';
    }

    http.Response response;
    try {
      response =
          await http.get(url, headers: _authHeader..addAll(headers ?? {}));
    } catch (ex) {
      final check = await networkInfoRepository.hasConnection;
      if (!check) {
        // for check another event
      }
      rethrow;
    }

    if (kDebugMode) {
      log(_formatResponseLog(response));
    }

    return _processResponse(
      response: response,
      requestFunc: () =>
          get(path, queryParameters: queryParameters, headers: headers),
    );
  }
  // Phương thức POST
  Future<http.Response> post(
    path, {
    required Map<String, dynamic> body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      encryptPayloadBody(body);
    } catch (ex) {
      logger.e(ex);
    }

    final url = Uri(
      scheme: serverScheme,
      host: serverAuthority,
      port: serverPort,
      path: path,
      queryParameters: queryParameters,
    );
    final Map<String, String> allHeaders = _authHeader;
    if (headers != null) {
      allHeaders.addAll(headers);
    }
    if (!allHeaders.containsKey('Content-Type')) {
      allHeaders['Content-Type'] = 'application/json';
    }

    final encodedBody = jsonEncode(body);

    http.Response response;
    try {
      response = await http.post(
        url,
        headers: _authHeader..addAll(headers ?? {}),
        body: encodedBody,
      );
    } catch (ex) {
      logger.e(ex);
      // ... existing error handling
      final check = await networkInfoRepository.hasConnection;
      if (!check) {
        // for check another event
      }
      rethrow;
    }
    if (kDebugMode) {
      log(_formatResponseLog(response));
    }
    return _processResponse(
      response: response,
      requestFunc: () => post(path,
          queryParameters: queryParameters, headers: headers, body: body),
    );
    // ... response logging and processing
  }
  // Phương thức Multipart Request dùng để gửi file
  Future<http.Response> multipartRequest(
    path, {
    required String method,
    required Map<String, String> body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    List<PlatformFile>? files,
  }) async {
    final url = Uri(
      scheme: serverScheme,
      host: serverAuthority,
      port: serverPort,
      path: path,
      queryParameters: queryParameters,
    );

    final Map<String, String> allHeaders = _authHeader;
    if (headers != null) {
      allHeaders.addAll(headers);
    }
    if (!allHeaders.containsKey('Content-Type')) {
      allHeaders['Content-Type'] = 'application/json';
    }

    // final encodedBody = jsonEncode(body);

    http.MultipartRequest request;
    http.StreamedResponse response;
    try {
      request = await http.MultipartRequest(
        method,
        url,
      );
      request.fields.addAll(body);
      for (final file in files!) {
        if (file.bytes == null) {
          continue;
        }
        request.files.add(await http.MultipartFile.fromBytes(
          'files',
          file.bytes as List<int>,
          filename: file.name, // Set filename as required
        ));
      }
      request.headers.addAll(headers!);
      response = await request.send();
    } catch (ex) {
      // ... existing error handling
      final check = await networkInfoRepository.hasConnection;
      if (!check) {
        // for check another event
      }
      rethrow;
    }

    final responseData = await utf8.decodeStream(response.stream);
    final convertedResponse = http.Response(
      responseData,
      response.statusCode,
      headers: response.headers,
      reasonPhrase: response.reasonPhrase,
    );

    if (kDebugMode) {
      log(_formatResponseLog(convertedResponse));
    }
    return _processResponse(
      response: convertedResponse,
      requestFunc: () => multipartRequest(path,
          queryParameters: queryParameters,
          headers: headers,
          body: body,
          method: method),
    );
  }
  // Phương thức DELETE
  Future<http.Response> delete(
    path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final url = Uri(
      scheme: serverScheme,
      host: serverAuthority,
      port: serverPort,
      path: path,
      queryParameters: queryParameters,
    );

    final Map<String, String> allHeaders = _authHeader;
    if (headers != null) {
      allHeaders.addAll(headers);
    }

    http.Response response;
    try {
      response =
          await http.delete(url, headers: _authHeader..addAll(headers ?? {}));
    } catch (ex) {
      // ... existing error handling
      final check = await networkInfoRepository.hasConnection;
      if (!check) {
        // for check another event
      }
      rethrow;
    }
    if (kDebugMode) {
      log(_formatResponseLog(response));
    }
    return _processResponse(
      response: response,
      requestFunc: () =>
          delete(path, queryParameters: queryParameters, headers: headers),
    );
    // ... response logging and processing
  }
  // Phương thức PATCH
  Future<http.Response> patch(
    path, {
    required Map<String, dynamic> body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final url = Uri(
      scheme: serverScheme,
      host: serverAuthority,
      port: serverPort,
      path: path,
      queryParameters: queryParameters,
    );

    final Map<String, String> allHeaders = _authHeader;
    if (headers != null) {
      allHeaders.addAll(headers);
    }
    if (!allHeaders.containsKey('Content-Type')) {
      allHeaders['Content-Type'] = 'application/json';
    }

    final encodedBody = jsonEncode(body);
    http.Response response;
    try {
      response = await http.patch(
        url,
        headers: _authHeader..addAll(headers ?? {}),
        body: encodedBody,
      );
    } catch (ex) {
      // ... existing error handling
      final check = await networkInfoRepository.hasConnection;
      if (!check) {
        // for check another event
      }
      rethrow;
    }
    if (kDebugMode) {
      log(_formatResponseLog(response));
    }
    return _processResponse(
      response: response,
      requestFunc: () => patch(path,
          queryParameters: queryParameters, headers: headers, body: body),
    );
    // ... response logging and processing
  }
  // Phương thức PUT
  Future<http.Response> put(
    path, {
    required Map<String, dynamic> body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final url = Uri(
      scheme: serverScheme,
      host: serverAuthority,
      port: serverPort,
      path: path,
      queryParameters: queryParameters,
    );

    final Map<String, String> allHeaders = _authHeader;
    if (headers != null) {
      allHeaders.addAll(headers);
    }
    if (!allHeaders.containsKey('Content-Type')) {
      allHeaders['Content-Type'] = 'application/json';
    }

    final encodedBody = jsonEncode(body);

    http.Response response;
    try {
      response = await http.put(
        url,
        headers: allHeaders,
        body: encodedBody,
      );
    } catch (ex) {
      // ... existing error handling
      final check = await networkInfoRepository.hasConnection;
      if (!check) {
        // for check another event
      }
      rethrow;
    }
    if (kDebugMode) {
      log(_formatResponseLog(response));
    }
    return _processResponse(
      response: response,
      requestFunc: () => put(path,
          queryParameters: queryParameters, headers: headers, body: body),
    );
    // ... response logging and processing
  }

  Future<T> _processResponse<T>({
    required http.Response response,
    required FutureOr<T> Function() requestFunc,
  }) async {
    // final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

    // final encryptedBody = decryptPayloadBody(responseJson['payload']);
    try {
      // print('-------------------------------------------------');
      // logger.i(response.body);
      // logger.i(responseJson);
      // logger.i(responseJson['payload']);
      // logger.i(encryptedBody);
      // print('-------------------------------------------------');
    } catch (e) {}

    if (response.statusCode >= 200 && response.statusCode <= 300) {
      return response as T;
    } else if (response.statusCode == 401) {
      // for check another event
      return response as T;
    } else {
      // for check another event
      return response as T;
    }
  }

  String _formatResponseLog(http.Response response, {Object? requestBody}) {
    final time = DateTime.now().toUtc().toIso8601String();
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String formattedRequestBody =
        requestBody != null ? encoder.convert(requestBody) : '';
    String formattedBodyJson;
    try {
      final json = jsonDecode(response.body);
      formattedBodyJson = encoder.convert(json);
    } catch (e) {
      formattedBodyJson = response.body;
    }
    return '''
  $time
  Request: ${response.request}${formattedRequestBody.isNotEmpty == true ? '\n  Request body: $formattedRequestBody' : ''}
  Response code: ${response.statusCode}
  Body: $formattedBodyJson
  ''';
  }
}
