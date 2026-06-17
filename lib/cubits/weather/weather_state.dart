import 'package:smart_home/core/api/weather_api.dart';

sealed class WeatherState {
  const WeatherState();
}

final class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

final class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

final class WeatherLoaded extends WeatherState {
  const WeatherLoaded(this.data, {this.fromCache = false});

  final WeatherData data;
  final bool fromCache;
}

final class WeatherError extends WeatherState {
  const WeatherError(this.message);

  final String message;
}
