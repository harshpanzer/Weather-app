import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/models/geolocation.dart';
import 'package:weatherapp/models/weathermodel.dart';
import 'package:weatherapp/repository/weather_repo.dart';
import 'package:weatherapp/utils/error_dialog_box.dart';

final weatherControllerProvider =
    StateNotifierProvider<WeatherController, bool>((ref) {
  return WeatherController(
      ref: ref,
      weatherRepository: ref.watch(weatherRepositoryProvider.notifier));
});

class WeatherController extends StateNotifier<bool> {
  final WeatherRepository _weatherRepo;
  final Ref _ref;
  WeatherController(
      {required WeatherRepository weatherRepository, required Ref ref})
      : _weatherRepo = weatherRepository,
        _ref = ref,
        super(false);
  Future<Geolocation> fetchCoordinates(BuildContext context) async {
    state = true;
    final coords = await _weatherRepo.getCoordinates();
    state = false;
    late Geolocation coord;
    coords.fold((l) {
      return showSnackBar(context, l.message);
    }, (r) {
      coord = r;
    });
    return coord;
  }

  Future<WeatherModel> fetchWeatherData(
      double lat, double long, BuildContext context) async {
    state = true;
    final weather = await _weatherRepo.getWeather(lat, long);
    state = false;
    late WeatherModel weatherdata;
    weather.fold((l) {
      return showSnackBar(context, l.message);
    }, (r) {
      weatherdata = r;
    });
    return weatherdata;
  }
}
