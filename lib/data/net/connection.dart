import 'dart:async';
import 'dart:io';
import 'dart:convert';

class RestConnection {
  RestConnection() : _httpClient = new HttpClient();
  
  final HttpClient _httpClient;

  Future<String> postHttps<T>(String authority, String unencodedPath, Map<String, dynamic> params) async {
    final Uri uri = new Uri.https(authority, unencodedPath, params);
    var request = await _httpClient.postUrl(uri);
    var response = await request.close();
    return await response.transform(UTF8.decoder).join();
  }

  Future<String> getHttps<T>(String authority, String unencodedPath, Map<String, dynamic> params) async {
    final Uri uri = new Uri.https(authority, unencodedPath, params);
    var request = await _httpClient.getUrl(uri);
    var response = await request.close();
    return await response.transform(UTF8.decoder).join();
  }
}