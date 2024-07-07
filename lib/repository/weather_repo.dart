import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/constants/api_key.dart';
import 'package:weatherapp/failure.dart';
import 'package:weatherapp/models/geolocation.dart';
import 'package:weatherapp/models/weathermodel.dart';
import 'package:weatherapp/screens/search_screen.dart';

final cityNameProvider = StateProvider((ref) {
  final cityName = ref.watch(controllerProvider.notifier).state;
  return cityName;
});

final weatherRepositoryProvider =
    StateNotifierProvider<WeatherRepository, bool>((ref) {
  return WeatherRepository(ref: ref);
});

class WeatherRepository extends StateNotifier<bool> {
  final Ref _ref;
  WeatherRepository({required Ref ref})
      : _ref = ref,
        super(false);

  Future<Either<Failure, Geolocation>> getCoordinates() async {
    final String cityname = _ref.read(controllerProvider.notifier).state;

    print(cityname);
    try {
      String url =
          "http://api.openweathermap.org/geo/1.0/direct?q=$cityname&limit=2&appid=${ApiKey.apiKey}";

      final response = await http.get(Uri.parse(url));
      var responseData = jsonDecode(response.body);
      // print(response.statusCode);

      if (response.statusCode == 200) {
        print(responseData);
        return right(Geolocation.fromJson(responseData[0])) ;
      } else {
        return left(Failure(responseData));
      }
    } catch (e) {
      print(e);
      return left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, WeatherModel>> getWeather(
      double lat, double long) async {
    try {
      String url =
          "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=${ApiKey.apiKey}";

      final response = await http.get(Uri.parse(url));
      var responseData = jsonDecode(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        print(responseData);
        return right(WeatherModel.fromJson(responseData));
      } else {
        return left(Failure(responseData));
       
      }
    } catch (e) {
      
      return left(Failure(e.toString()));
    }
  }
}
