
import 'dart:convert';
import 'package:http/http.dart' as http;

class forecastModel{

  Future<List<double>> forecastDamages(
  double windSpeed,
  double rainfall24, 
  double rainfall6, 
  double area, 
  double riceYield, 
  double distance, 
  double price, 
  int dayCount,
  ) async{
    List<double> damageCosts = [];

    var typhoonista_input_initial = {
      "features" : [
        windSpeed,
        rainfall24,
        rainfall6,
        area,
        riceYield,
        distance,
        price
      ]
    };

    double predicted_cost = await predictDayOne(typhoonista_input_initial);
    damageCosts.add(predicted_cost);

    for(int dayNum = 1; dayNum < dayCount; dayNum++){ 

      var windspeed_input = {
        "features": [
          rainfall24,
          rainfall6,
          distance,
          area,
          riceYield,
          predicted_cost
        ]
      };
      
      double windspeed_response_data = await predictWindSpeed(windspeed_input);

      var rainfall24_input = {
        "features": [
          windSpeed,
          rainfall6,
          distance,
          area,
          riceYield,
          predicted_cost
        ]
      };

      
      double rainfall24_response_data = await predictRainfall24(rainfall24_input);

      var rainfall6_input = {
        "features": [
          windspeed_input,
          rainfall24,
          distance,
          area,
          riceYield,
          predicted_cost
        ]
      };

      double rainfall6_response_data = await predictRainfall6(rainfall6_input);

      var distance_input = {
        "features": [
          windspeed_input,
          rainfall24,
          rainfall6,
          area,
          riceYield,
          predicted_cost
        ]
      };

      double distance_response_data = await predictDistance(distance_input);

      windSpeed = windspeed_response_data;
      rainfall24 = rainfall24_response_data;
      rainfall6 = rainfall6_response_data;
      distance = distance_response_data;

      var next_day_input = {
        "features": [
          windSpeed,
          rainfall24,
          rainfall6,
          area,
          riceYield,
          distance,
          price
        ]
      };
      var next_day_cost = await predictNextDayCost(next_day_input);
      predicted_cost = next_day_cost;
      damageCosts.add(next_day_cost);
    }
    return damageCosts;
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

}