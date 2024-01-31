import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class weather_forecast extends StatefulWidget {
  const weather_forecast({super.key});

  @override
  State<weather_forecast> createState() => _weather_forecastState();
}

class _weather_forecastState extends State<weather_forecast> {
  List<Map<String, dynamic>> weatherData = [];

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "WEATHER FORECAST",
                style: textStyles.lato_bold(color: Colors.black, fontSize: 15),
              )),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(26)),
                child: (weatherData.isEmpty)
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SpinKitPouringHourGlassRefined(size: 50, color: Colors.blue),
                      ],
                    )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: weatherData
                                .map(
                                  (forecastData) {
                                    double temp = forecastData['main']['temp'];
                                    temp = temp- 273.15;
                                    return Container(
                                    child: Container(
                                      padding: const EdgeInsets.all(30.0),
                                      decoration: const BoxDecoration(
                                          // color: Colors.blue.shade50
                                          ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Format the time
                                          Text(
                                            DateFormat('h a').format(
                                                DateTime.parse(
                                                    forecastData['dt_txt'])),
                                            style: textStyles.lato_bold(),
                                          ),
                                          // Format the date
                                          Text(
                                            DateFormat('E, MMM d').format(
                                                DateTime.parse(
                                                    forecastData['dt_txt'])),
                                            style: textStyles.lato_bold(),
                                          ),
                                          Image.network(
                                              "https://openweathermap.org/img/wn/${forecastData['weather'][0]['icon']}.png"),
                                          Text(
                                              "${temp.round()} °C", style: textStyles.lato_regular(),),
                                          Text(
                                              "${forecastData['weather'][0]['description']}", style: textStyles.lato_regular(),),
                                        ],
                                      ),
                                    ),
                                  );
                                  }
                                )
                                .toList(),
                          ),
                        ),
                      )),
          ),
        ],
      ),
    );
  }

  Future<void> fetchWeatherData() async {
    String selectedCity = 'Davao';
    try {
      final Uri uri = Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$selectedCity&appid=5b0d11ec7d5a0162d3a9559e944c079e");
      final http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        // print("API Response: ${response.body}");
        setState(() {
          final Map<String, dynamic> data = json.decode(response.body);
          weatherData = List<Map<String, dynamic>>.from(data['list']);
        });
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
