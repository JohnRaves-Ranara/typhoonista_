import 'package:flutter/material.dart';

class typhoon_forecast extends StatefulWidget {
  const typhoon_forecast({super.key});

  @override
  State<typhoon_forecast> createState() => _typhoon_forecastState();
}

class _typhoon_forecastState extends State<typhoon_forecast> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 55,
      child: Container(color: Colors.amber,));
  }
}