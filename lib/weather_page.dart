import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather_app/Components/AdditionalInformation/additional_information.dart';
import 'package:weather_app/Components/Heading/heading_weather.dart';
import 'package:weather_app/Components/WeatherForcast/weather_forcast.dart';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late Future weather;
  @override
  void initState() {
    super.initState();
    weather = getWeatherInfo();
  }

  Future getWeatherInfo() async {
    const apiKey = '2324286e75d8b49ff5e5145958369835';
    const cityName = 'Gorakhpur';

    try {
      var uri = Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$apiKey');

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw "An unexpected error occured! Internal!";
      }

      final data = jsonDecode(response.body);
      if (data['cod'] != '200') {
        throw "An unexpected error occured!";
      }

      return data;
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  Widget getForcastWidgets(data, index) {
    final listData = data['list'];

    var currentData = listData[index + 1];
    IconData iconData;
    if (currentData['weather'][0]['main'] == 'Clouds' ||
        currentData['weather'][0]['main'] == 'Rain') {
      iconData = Icons.cloud;
    } else {
      iconData = Icons.sunny;
    }
    DateTime dateTime = DateTime.parse(currentData['dt_txt']);

    return WeatherForcast(
      time: '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}',
      icon: iconData,
      temprature: currentData['main']['temp'].toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  weather = getWeatherInfo();
                });
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          final data = snapshot.data;
          final firstData = data['list'][0];

          final headingTemprature = firstData['main']['temp'];
          IconData headingIcon;
          final headingText = firstData['weather'][0]['main'];

          if (headingText == 'Clouds' || headingText == 'Rain') {
            headingIcon = Icons.cloud;
          } else {
            headingIcon = Icons.sunny;
          }

          final humidityValue = firstData['main']['humidity'].toString();
          final pressureValue = firstData['main']['pressure'].toString();
          final windSpeedValue = firstData['wind']['speed'].toString();

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingWeather(
                    temprature: '$headingTemprature K',
                    title: headingText,
                    icon: headingIcon),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Weather Forcast",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return getForcastWidgets(data, index + 1);
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Additional Information",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformation(
                      title: "Humidity",
                      icon: Icons.water_drop,
                      value: humidityValue,
                    ),
                    AdditionalInformation(
                      title: "Wind Speed",
                      icon: Icons.air,
                      value: windSpeedValue,
                    ),
                    AdditionalInformation(
                      title: "Pressure",
                      icon: Icons.beach_access,
                      value: pressureValue,
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
