import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/constants/colours.dart';
import 'package:weatherapp/controller/weather_controller.dart';
import 'package:weatherapp/models/weathermodel.dart';
import 'package:weatherapp/screens/weather_info_screen.dart';
import 'package:weatherapp/utils/loader.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

// getCoordinates(Ref ref) async {
//   WeatherRepository weather = ref.watch(weatherRepositoryProvider);
//   return weather.getCoordinates();
// }

final controllerProvider = StateProvider<String>((ref) {
  return "";
});
final weatherDataProvider = StateProvider<WeatherModel?>((ref) {
  return null;
});

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final weatherController = ref.watch(weatherControllerProvider.notifier);
    final isLoading = ref.watch(weatherControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WeatherApp',
          style: TextStyle(color: Colour.blueColour),
        ),
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    onChanged: (value) {
                      ref.watch(controllerProvider.notifier).state = value;
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                        focusColor: Colour.whiteColour,
                        labelText: 'City Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colour.grayColour)),
                      onPressed: () async {
                        // ref.watch(controllerProvider.notifier).state =
                        //     _controller.text;
                        print(ref.watch(controllerProvider.notifier).state);

                        final geolocation =
                            await weatherController.fetchCoordinates(context);
                        final weatherData =
                            await weatherController.fetchWeatherData(
                                geolocation.lat!, geolocation.lon!, context);
                        ref.watch(weatherDataProvider.notifier).state =
                            weatherData;
                        if (weatherData != Null) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const WeatherScreen()));
                        }
                      },
                      child: const Text(
                        'Search',
                        style: TextStyle(color: Colour.whiteColour),
                      )),
                ],
              ),
            ),
    );
  }
}
