import 'package:bloc_library_poc/bloc/weather_bloc.dart';
import 'package:bloc_library_poc/model/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherPage(),
    );
  }
}

/**
 *  UI has 2 roles :-
 *  1. Dispatch events to the bloc
 *  2. React to states from the bloc
 */
class WeatherPage extends StatefulWidget {
  WeatherPage({Key key}) : super(key: key);

  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final weatherBloc = WeatherBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fake Weather App"),
      ),
      body: BlocProvider(
        create: (BuildContext context) => weatherBloc,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: BlocListener(
            cubit: weatherBloc,
            listener: (context,WeatherState state){
              if(state is WeatherLoaded){
                print("Loaded : ${state.weather.cityName}");
              }
            },
            child: BlocBuilder(
              cubit: weatherBloc,
              builder: (BuildContext context, WeatherState state) {
                if (state is WeatherInitial) {
                  return buildInitialInput();
                } else if (state is WeatherLoading) {
                  return buildLoading();
                } else if (state is WeatherLoaded) {
                 // print("Loaded : ${state.weather.cityName}");
                  return buildColumnWithData(state.weather);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Column buildColumnWithData(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          weather.cityName,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          "${weather.temperature.toStringAsFixed(1)} °C",
          style: TextStyle(fontSize: 80),
        ),
        CityInputField(),
      ],
    );
  }

  @override
  void dispose() {
    weatherBloc.close();
    super.dispose();
  }
}

Widget buildLoading() {
  return Center(
    child: CircularProgressIndicator(),
  );
}

  Widget buildInitialInput() {
    return Center(
      child: CityInputField(),
    );
  }

class CityInputField extends StatefulWidget {
  const CityInputField({
    Key key,
  }) : super(key: key);

  @override
  _CityInputFieldState createState() => _CityInputFieldState();
}

/**
 *  Since we dont have weatherBloc instance in CityInputField it is
 *  present in the WeatherPageState
 *  then we use BlocProvider which is a Inherited widget
 */
class _CityInputFieldState extends State<CityInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: submitCityName,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a city",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  void submitCityName(String cityName) {
    // We will use the city name to search for the fake forecast
    //Get the Bloc using the blocProvider
    final weatherBloc= BlocProvider.of<WeatherBloc>(context);
    weatherBloc.add(GetWeatherEvent(cityName));
  }
}
