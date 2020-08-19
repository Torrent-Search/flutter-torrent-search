import 'dart:convert';

import 'package:http/http.dart' as http;

/// Returns [Map<String, dynamic>] throws [Excpetion] on Excption
Future<Map<String, dynamic>> getAppVersion(
  // ignore: non_constant_identifier_names
  String BASE_URL,
) async {
  http.Response response = await http.get('${BASE_URL}api/appversion');
  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    throw Exception();
  }
}
