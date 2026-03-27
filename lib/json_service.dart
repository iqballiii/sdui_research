import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/web.dart';

class JsonBinService {
  static const String _baseUrl = 'https://api.jsonbin.io/v3/b';

  static String get _binId => dotenv.env['JSONBIN_BIN_ID'] ?? '';
  static String get _apiKey => dotenv.env['JSONBIN_API_KEY'] ?? '';

  /// Fetches SDUI JSON from JSONBin.
  /// Returns the raw map for Stac to render.
  /// Also returns the fetch duration for research benchmarking.
  static Future<({Map<String, dynamic> json, int fetchMs})> fetchScreen(
    String binId,
  ) async {
    final stopwatch = Stopwatch()..start();
    final uri = Uri.parse('$_baseUrl/$binId'); // Use the dynamic binId

    final response = await Dio().get(
      uri.toString(),
      options: Options(headers: {'X-Master-Key': _apiKey}),
    );
    Logger().i('JSONBin response: ${response.statusCode} ${response.data}');
    stopwatch.stop();
    final fetchMs = stopwatch.elapsedMilliseconds;

    if (response.statusCode == 200) {
      log('✅ JSONBin fetch success: ${fetchMs}ms');
      final decoded = response.data['record'] as Map<String, dynamic>;
      return (json: decoded, fetchMs: fetchMs);
    } else {
      log('❌ JSONBin fetch failed: ${response.statusCode} ${response.data}');
      throw Exception('Failed to fetch SDUI screen: ${response.statusCode}');
    }
  }
}
