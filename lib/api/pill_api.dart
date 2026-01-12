import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PillApi {
  PillApi._();

  // 👇 Change port if your FastAPI is running on a different one
  static const int _port = 8000;

  static String get _baseUrl {
    // Web build
    if (kIsWeb) return 'http://localhost:$_port';

    // Android emulator -> your Mac host machine
    if (Platform.isAndroid) return 'http://10.0.2.2:$_port';

    // iOS simulator / macOS desktop -> localhost works
    return 'http://localhost:$_port';
  }

  static Uri _uri(String path, [Map<String, String>? q]) {
    final p = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$_baseUrl$p').replace(queryParameters: q);
  }

  /// Calls FastAPI /identify
  /// Expected response: {"results":[{...},{...}]}
  static Future<List<Map<String, dynamic>>> identify({
    required String imprint,
    String? color,
    String? shape,
  }) async {
    final body = <String, dynamic>{
      "imprint": imprint,
      "color": (color ?? "").trim().isEmpty ? null : color!.trim(),
      "shape": (shape ?? "").trim().isEmpty ? null : shape!.trim(),
    };

    final res = await http.post(
      _uri('/identify'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      throw Exception('API ${res.statusCode}: ${res.body}');
    }

    final decoded = jsonDecode(res.body);
    final results = decoded is Map<String, dynamic> ? decoded["results"] : null;

    if (results is List) {
      return results.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    return <Map<String, dynamic>>[];
  }
}
