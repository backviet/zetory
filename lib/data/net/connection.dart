import 'dart:async';
import 'dart:io';
import 'dart:convert';

class RestConnection {
  RestConnection() : _httpClient = new HttpClient();
  
  final HttpClient _httpClient;

  Future<String> postHttps<T>(String authority, String unencodedPath, Map<String, dynamic> params) async {
    final uri = Uri.https(authority, unencodedPath, params);
    final request = await _httpClient.postUrl(uri);
    final response = await request.close();
    return await response.transform(utf8.decoder).join();
  }

  Future<String> getHttps<T>(String authority, String unencodedPath, Map<String, dynamic> params) async {
    final uri = Uri.https(authority, unencodedPath, params);
    final request = await _httpClient.getUrl(uri);
    final response = await request.close();
    return await response.transform(utf8.decoder).join();
  }

  Future<String> getURL<T>(String url) async {
    final request = await _httpClient.getUrl(Uri.parse(url));
    final response = await request.close();
    return await response.transform(utf8.decoder).join();
  }
}