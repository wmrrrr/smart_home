import 'package:dio/dio.dart';

class WeatherData {
  const WeatherData({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
  });

  factory WeatherData.fromJson(final Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    return WeatherData(
      temperature: (current['temperature_2m'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
    );
  }

  final double temperature;
  final double humidity;
  final double windSpeed;
  final int weatherCode;

  Map<String, dynamic> toJson() => {
        'temperature': temperature,
        'humidity': humidity,
        'windSpeed': windSpeed,
        'weatherCode': weatherCode,
      };

  String get weatherDescription {
    if (weatherCode == 0) return 'Ясно';
    if (weatherCode <= 3) return 'Хмарно';
    if (weatherCode <= 48) return 'Туман';
    if (weatherCode <= 67) return 'Дощ';
    if (weatherCode <= 77) return 'Сніг';
    return 'Гроза';
  }
}

class WeatherApi {
  WeatherApi._();

  static final WeatherApi instance = WeatherApi._();

  static const _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  final _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 10)));

  Future<WeatherData> fetchWeather({
    final double latitude = 50.45,
    final double longitude = 30.52,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _baseUrl,
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'current': 'temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code',
      },
    );
    return WeatherData.fromJson(response.data!);
  }
}
