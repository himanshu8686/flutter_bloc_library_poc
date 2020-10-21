import 'dart:async';
import 'dart:math';
import 'package:bloc_library_poc/model/weather.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends HydratedBloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial());

  @override
  WeatherState get initialState{
    return super.state ?? WeatherInitial();
  }

  @override
  WeatherState fromJson(Map<String, dynamic> json) {
    try{
      final weather = Weather.fromJson(json);
      return WeatherLoaded(weather);
    }catch(_){
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(WeatherState state) {
    if(state is WeatherLoaded){
      return state.weather.toJson();
    }
    else{
      // returning null means it told the hydrated bloc package
      // it should leave the stored state as it is.
      return null;
    }
  }

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
