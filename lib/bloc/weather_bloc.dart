import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:bloc_library_poc/model/Weather.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial());

  @override
  Stream<WeatherState> mapEventToState(
      WeatherEvent event,
      ) async* {
    // Distinguish between different events, even though this app has only one
    if(event is GetWeatherEvent)
    {
      // Outputting a state from the asynchronous generator
      yield WeatherLoading();

      final weather = await _fetchWeatherFromFakeApi(event.cityName);

      yield WeatherLoaded(weather);
    }
  }

  Future<Weather> _fetchWeatherFromFakeApi(String cityName) {
    // simulate network delay
    return Future.delayed(Duration(seconds: 2),(){
      return Weather(
        cityName: cityName,
        temperature: 20 + Random().nextInt(15) + Random().nextDouble()
      );
    });
  }
}
