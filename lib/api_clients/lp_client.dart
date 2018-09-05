import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:language_pal/store_utils/user_settings_utils.dart';
import 'package:path/path.dart';
import 'package:meta/meta.dart';

class HttpClientException extends ClientException {
  Response response;

  HttpClientException({this.response}) : super("Error making http request");
}

class LPResponse {
  Map<String, dynamic> body;
  http.Response response;

  LPResponse(this.body, this.response);

  @override
  String toString() {
    var encoder = new JsonEncoder.withIndent("    ");
    return '--- LPResponse ---\n'
        'body: ${encoder.convert(body)},\n'
        'code: ${response.statusCode}';
  }
}

abstract class LPClient {
  static String domain = "http://192.168.1.9:8000/";
  var client = http.Client();

  Future<LPResponse> get(String url, {Map<String, String> headers}) async {
    return await _execute(client.get, url, headers: headers);
  }

  Future<LPResponse> head(String url, {Map<String, String> headers}) async {
    return await _execute(client.head, url, headers: headers);
  }

  Future<LPResponse> post(String url, {Map<String, String> headers, body, Encoding encoding}) async {
    return await _execute(client.post, url, headers: headers, body: body);
  }

  Future<LPResponse> put(String url, {Map<String, String> headers, body, Encoding encoding}) async {
    return await _execute(client.put, url, headers: headers, body: body);
  }

  Future<LPResponse> patch(String url, {Map<String, String> headers, body, Encoding encoding}) async {
    return await _execute(client.patch, url, headers: headers, body: body);
  }

  Future<LPResponse> delete(String url, {Map<String, String> headers}) async {
    return await _execute(client.delete, url, headers: headers);
  }

  Future<LPResponse> uploadFile(String url, {@required String path, Map<String, String> extraData = const {}}) async {
    var file = File(path);
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    url = domain + url;
    var uri = Uri.parse(url);
    var headers = new Map<String, String>();
    headers['Authorization'] = 'Bearer ${getSettings().token}';

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length, filename: basename(file.path));

    request.headers.addAll(headers);
    request.fields.addAll(extraData);
    request.files.add(multipartFile);

    var response = await Response.fromStream(await request.send());
    LPResponse lpResponse = new LPResponse(json.decode(response.body), response);
    if (response.statusCode >= 300) {
      throw new HttpClientException(response: response);
    }
    return lpResponse;
  }

  Future<LPResponse> _execute(Function func, String url, {Map<String, String> headers, body, Encoding encoding}) async {
    Response response;

    url = domain + url;
    headers = headers ?? {};
    headers['Content-Type'] = 'application/json';
    if (getSettings().token != null) {
      headers['Authorization'] = 'Bearer ${getSettings().token}';
    }

    print("Api request:");
    print({'url': url, 'headers': headers, 'body': body});

    try {
      if (body == null) {
            response = await func(url, headers: headers);
          } else {
            response = await func(url, headers: headers, body: json.encode(body));
          }
    } on ClientException catch (e) {
      if(e.message == 'Connection closed while receiving data') {
        client  = http.Client();
        throw e;
      }
    }

    try {
      if (response.statusCode >= 300) {
        throw new HttpClientException(response: response);
      }
      LPResponse lpResponse = new LPResponse(json.decode(response.body), response);
      return lpResponse;
    } on FormatException catch (e) {
      throw new HttpClientException(response: response);
    }
  }
}
