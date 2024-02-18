import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entities2/new/Day.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class forecastModel {
  Future<List<Day>> forecast({
    required double initial_ws,
    required double initial_rf24,
    required double initial_rf6,
    required double initial_area,
    required double initial_yield,
    required double initial_distance,
    required double rice_price,
    required int days,
  }) async {
    List<Day> dayDamages = [];

    var typhoonista_input = {
      "features": [
        initial_ws,
        initial_rf24,
        initial_rf6,
        initial_area,
        initial_yield,
        initial_distance,
        rice_price
      ]
    };

    double predicted_cost = await predictDayOne(typhoonista_input);
    dayDamages.add(Day(
        damageCost: predicted_cost,
        windSpeed: initial_ws,
        rainfall24: initial_rf24,
        rainfall6: initial_rf6,
        riceArea: initial_area,
        riceYield: initial_yield,
        distance: initial_distance,
        ricePrice: rice_price,
        dayNum: 1));

    double next_ws = initial_ws;
    double next_rf24 = initial_rf24;
    double next_rf6 = initial_rf6;
    double next_area = initial_area;
    double next_yield = initial_yield;
    double next_distance = initial_distance;

    for (int day = 2; day <= days; day++) {
      var area_input = {
        "features": [
          next_ws,
          next_rf24,
          next_rf6,
          next_area,
          next_yield,
          next_distance,
          predicted_cost
        ]
      };
      double area_response_data = await predictNextDayArea(area_input);

      var yield_input = {
        "features": [
          next_ws,
          next_rf24,
          next_rf6,
          next_area,
          next_yield,
          next_distance,
          predicted_cost
        ]
      };
      
      double yield_response_data = await predictNextDayYield(yield_input);

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

      double rainfall24_response_data =
          await predictRainfall24(rainfall24_input);

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
      next_yield = yield_response_data;
      next_area = area_response_data;

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

      dayDamages.add(Day(
          damageCost: next_day_cost,
          windSpeed: next_ws,
          rainfall24: next_rf24,
          rainfall6: next_rf6,
          riceArea: next_area,
          riceYield: next_yield,
          distance: next_distance,
          ricePrice: rice_price,
          dayNum: day));

      predicted_cost = next_day_cost;
    }

    //round off all damages to 2 decimals

    dayDamages.forEach((day) {
      day.damageCost = double.parse(day.damageCost!.toStringAsFixed(2));
    });

    return dayDamages;
  }

  Future<double> predictDayOne(var input) async {
    var typhoonista_response = await http.post(
        Uri.parse("https://typhoonista.onrender.com/typhoonista/predict"),
        body: json.encode(input));
    var typhoonista_response_data = json.decode(typhoonista_response.body);
    double predicted_cost = typhoonista_response_data;

    return predicted_cost;
  }

  Future<double> predictWindSpeed(var input) async {
    var windspeed_response = await http.post(
        Uri.parse("https://typhoonista.onrender.com/windspeed/predict"),
        body: json.encode(input));
    double windspeed_response_data = json.decode(windspeed_response.body);

    return windspeed_response_data;
  }

  Future<double> predictRainfall24(var input) async {
    var rainfall24_response = await http.post(
        Uri.parse("https://typhoonista.onrender.com/rainfall24/predict"),
        body: json.encode(input));
    double rainfall24_response_data = json.decode(rainfall24_response.body);

    return rainfall24_response_data;
  }

  Future<double> predictRainfall6(var input) async {
    var rainfall6_response = await http.post(
        Uri.parse("https://typhoonista.onrender.com/rainfall6h/predict"),
        body: json.encode(input));
    double rainfall6_response_data = json.decode(rainfall6_response.body);

    return rainfall6_response_data;
  }

  Future<double> predictDistance(var input) async {
    var distance_response = await http.post(
        Uri.parse("https://typhoonista.onrender.com/distance/predict"),
        body: json.encode(input));
    double distance_response_data = json.decode(distance_response.body);

    return distance_response_data;
  }

  Future<double> predictNextDayCost(var input) async {
    var next_day_response = await http.post(
        Uri.parse("https://typhoonista.onrender.com/typhoonista/predict"),
        body: json.encode(input));
    double next_day_cost = json.decode(next_day_response.body);
    return next_day_cost;
  }

  Future<double> predictNextDayArea(var input) async{
    var area_response = await http.post(
          Uri.parse("https://typhoonista.onrender.com/damaged-area/predict"),
          body: json.encode(input));
      double area_response_data = json.decode(area_response.body);
    return area_response_data;
  }

  Future<double> predictNextDayYield(var input) async{
    var yield_response = await http.post(
          Uri.parse("https://typhoonista.onrender.com/damaged-yield/predict"),
          body: json.encode(input));
    double yield_response_data = json.decode(yield_response.body);
    
    return yield_response_data;
  }

  
}
