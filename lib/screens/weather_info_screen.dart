import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/constants/colours.dart';
import 'package:weatherapp/controller/weather_controller.dart';
import 'package:weatherapp/screens/search_screen.dart';
import 'package:weatherapp/utils/loader.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    final weatherData = ref.watch(weatherDataProvider);
    final cityName = ref.watch(controllerProvider);
    final weatherController = ref.watch(weatherControllerProvider.notifier);
    final isLoading = ref.watch(weatherControllerProvider);
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      cityName,
                      style: const TextStyle(color: Colour.blueColour, fontSize: 30),
                    ),
                  ),
                  Center(
                    child: Image.network(
                        "https://openweathermap.org/img/wn/${weatherData!.weather![0].icon}@2x.png"),
                  ),
                  Center(
                    child: Text(
                      '${((weatherData.main!.temp!) - 273.15).toInt()}\u00B0c',
                      style: const TextStyle(
                        color: Colour.blueColour,
                        fontSize: 50,
                      ),
                    ),
                  ),
                  const Center(
                    child: SizedBox(
                      width: 120,
                      child: Divider(
                        color: Colour.blueColour,
                        thickness: 3,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Colour.whiteColour, width: 4),
                        ),
                        height: 100,
                        width: 150,
                        child: Text(
                          '${weatherData.weather![0].description}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colour.blueColour,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Colour.whiteColour, width: 4),
                        ),
                        height: 100,
                        width: 150,
                        child: Text(
                          '${weatherData.main!.humidity}%\nHumidity',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colour.blueColour,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Colour.whiteColour, width: 4),
                        ),
                        height: 100,
                        width: 150,
                        child: Text(
                          '${weatherData.wind!.speed}m/s\nWind Speed',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colour.blueColour,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Colour.whiteColour, width: 4),
                        ),
                        height: 100,
                        width: 150,
                        child: Text(
                          '${weatherData.name}\n Station',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colour.blueColour,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  Center(
                      child: ElevatedButton(
                    onPressed: () async {
                      final geolocation =
                          await weatherController.fetchCoordinates(context);
                      final weatherData =
                          await weatherController.fetchWeatherData(
                              geolocation.lat!, geolocation.lon!, context);
                      ref.watch(weatherDataProvider.notifier).state =
                          weatherData;
                    },
                    style: const ButtonStyle(
                        minimumSize: MaterialStatePropertyAll(Size(150, 75))),
                    child: const Text(
                      "Refresh",
                      style: TextStyle(fontSize: 20, color: Colour.whiteColour),
                    ),
                  ))
                ],
              ),
            ),
    );
  }
}
