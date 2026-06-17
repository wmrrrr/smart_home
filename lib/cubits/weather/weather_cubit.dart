import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/core/api/weather_api.dart';
import 'package:smart_home/core/api/weather_cache.dart';
import 'package:smart_home/cubits/weather/weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(const WeatherInitial()) {
    fetch();
  }

  Future<void> fetch() async {
    emit(const WeatherLoading());
    try {
      final data = await WeatherApi.instance.fetchWeather();
      await WeatherCache.instance.save(data);
      emit(WeatherLoaded(data));
    } on Exception catch (e) {
      final cached = await WeatherCache.instance.load();
      if (cached != null) {
        emit(WeatherLoaded(cached, fromCache: true));
      } else {
        emit(WeatherError(e.toString()));
      }
    }
  }
}
