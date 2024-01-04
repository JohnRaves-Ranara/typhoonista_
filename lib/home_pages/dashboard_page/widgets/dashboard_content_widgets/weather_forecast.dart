import 'package:flutter/material.dart';

class weather_forecast extends StatefulWidget {
  const weather_forecast({super.key});

  @override
  State<weather_forecast> createState() => _weather_forecastState();
}

class _weather_forecastState extends State<weather_forecast> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26)
        ),
        child: Center(child: Text("weather forecast")),
      ),
    );
  }
}