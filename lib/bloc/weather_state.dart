part of 'weather_bloc.dart';

@immutable
abstract class WeatherState extends Equatable{}

class WeatherInitial extends WeatherState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class WeatherLoading extends WeatherState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  WeatherLoaded(this.weather);

  @override
  // TODO: implement props
  List<Object> get props =>  [weather];
}
