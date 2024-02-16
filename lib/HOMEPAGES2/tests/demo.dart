import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class demo extends StatefulWidget {
  const demo({super.key});

 

  @override
  State<demo> createState() => _demoState();
}

class _demoState extends State<demo> {
  TextEditingController wsController = TextEditingController();
  TextEditingController rf24Controller = TextEditingController();
  TextEditingController rf6Controller = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController yieldController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController daysController = TextEditingController();

  String result = '';

  Future<void> forecast() async {
    double initial_ws = double.parse(wsController.text);
    double initial_rf24 = double.parse(rf24Controller.text);
    double initial_rf6 = double.parse(rf6Controller.text);
    double initial_area = double.parse(areaController.text);
    double initial_yield = double.parse(yieldController.text);
    double initial_distance = double.parse(distanceController.text);
    double price = double.parse(priceController.text);
    int days = int.parse(daysController.text);

    double next_ws = initial_ws;
    double next_rf24 = initial_rf24;
    double next_rf6 = initial_rf6;
    double next_area = initial_area;
    double next_yield = initial_yield;
    double next_distance = initial_distance;
    double rice_price = price;
    List<double> costs = [];

    var typhoonista_input = {
      "features": [
        next_ws,
        next_rf24,
        next_rf6,
        next_area,
        next_yield,
        next_distance,
        rice_price
      ]
    };
    
    double predicted_cost = await predictDayOne(typhoonista_input);
    costs.add(predicted_cost);

    for (int day = 1; day < days; day++) {
      var windspeed_input = {
        "features": [
          next_rf24,
          next_rf6,
          next_distance,
          next_area,
          next_yield,
          predicted_cost
        ]
      };

      double windspeed_response_data = await predictWindSpeed(windspeed_input);

      var rainfall24_input = {
        "features": [
          next_ws,
          next_rf6,
          next_distance,
          next_area,
          next_yield,
          predicted_cost
        ]
      };
     
      double rainfall24_response_data = await predictRainfall24(rainfall24_input);

      var rainfall6_input = {
        "features": [
          next_ws,
          next_rf24,
          next_distance,
          next_area,
          next_yield,
          predicted_cost
        ]
      };

      double rainfall6_response_data = await predictRainfall6(rainfall6_input);

      var distance_input = {
        "features": [
          next_ws,
          next_rf24,
          next_rf6,
          next_area,
          next_yield,
          predicted_cost
        ]
      };
      
      double distance_response_data = await predictDistance(distance_input);

      next_ws = windspeed_response_data;
      next_rf24 = rainfall24_response_data;
      next_rf6 = rainfall6_response_data;
      next_distance = distance_response_data;

      var next_day_input = {
        "features": [
          next_ws,
          next_rf24,
          next_rf6,
          next_area,
          next_yield,
          next_distance,
          rice_price
        ]
      };

      double day2_response_data = await predictNextDayCost(next_day_input);
      var next_day_cost = day2_response_data;
      predicted_cost = next_day_cost;
      costs.add(next_day_cost);
    }

    setState(() {
      result = costs.toString();
    });
  }

  Future<double> predictDayOne(var input ) async{

    var typhoonista_response = await http.post(
        Uri.parse("https://typhoonista.onrender.com/typhoonista/predict"),
        body: json.encode(input));
    var typhoonista_response_data = json.decode(typhoonista_response.body);
    double predicted_cost = typhoonista_response_data;

    return predicted_cost;
  }

  Future<double> predictWindSpeed(var input) async{
    var windspeed_response = await http.post(
          Uri.parse("https://typhoonista.onrender.com/windspeed/predict"),
          body: json.encode(input));
      double windspeed_response_data = json.decode(windspeed_response.body);

      return windspeed_response_data;
  }

  Future<double> predictRainfall24(var input) async{
    var rainfall24_response = await http.post(
          Uri.parse("https://typhoonista.onrender.com/rainfall24/predict"),
          body: json.encode(input));
    double rainfall24_response_data = json.decode(rainfall24_response.body);

      return rainfall24_response_data;
  }

  Future<double> predictRainfall6(var input) async{
    var rainfall6_response = await http.post(
          Uri.parse("https://typhoonista.onrender.com/rainfall6h/predict"),
          body: json.encode(input));
    double rainfall6_response_data = json.decode(rainfall6_response.body);

    return rainfall6_response_data;
  }

  Future<double> predictDistance(var input) async{
    var distance_response = await http.post(
          Uri.parse("https://typhoonista.onrender.com/distance/predict"),
          body: json.encode(input));
    double distance_response_data = json.decode(distance_response.body);

    return distance_response_data;
  }

  Future<double> predictNextDayCost(var input) async{
    var next_day_response = await http.post(
          Uri.parse("https://typhoonista.onrender.com/typhoonista/predict"),
          body: json.encode(input));
    double next_day_cost = json.decode(next_day_response.body);
    return next_day_cost;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: wsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Initial Wind Speed'),
            ),
            TextField(
              controller: rf24Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Initial Rainfall (24h)'),
            ),
            TextField(
              controller: rf6Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Initial Rainfall (6h)'),
            ),
            TextField(
              controller: areaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Area'),
            ),
            TextField(
              controller: yieldController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Yield'),
            ),
            TextField(
              controller: distanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Distance'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: daysController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Number of Days'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: forecast,
              child: Text('Calculate Forecast'),
            ),
            SizedBox(height: 20),
            Text(result),
          ],
        ),
      ),
    );
  }
}