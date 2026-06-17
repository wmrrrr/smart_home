import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home/core/api/weather_api.dart';

class WeatherCache {
  WeatherCache._();

  static final WeatherCache instance = WeatherCache._();

  static const _key = 'sh_weather_cache';

  Future<void> save(final WeatherData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(data.toJson()));
  }

  Future<WeatherData?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return WeatherData(
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      weatherCode: json['weatherCode'] as int,
    );
  }
}
