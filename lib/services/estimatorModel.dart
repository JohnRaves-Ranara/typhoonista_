import "dart:math";
import 'package:http/http.dart' as http;
import 'dart:convert';
//DUMMY ONLY!!

class estimatorModel{
  
  double getEstimation(){
    final random = Random();
    final min = 1000000.0; // 1 million
    final max = 3000000.0; // 3 million

    // Generate a random double between 0 and 1 (exclusive)
    final randomDouble = random.nextDouble();

    // Scale the random value to the desired range
    return (min + (randomDouble * (max - min)) / 10).round() * 10;
  }

  Future<double> sendPredictionRequest({
    required double windspeed,
    required double rainfall24,
    required double rainfall6,
    required double area,
    required double riceYield,
    required double distrackmin,
    required double price,
  }) async {
    double? prediction;
    print('$windspeed\n$rainfall24\n$rainfall6\n$area\n$riceYield\n$distrackmin\n$price');
    try {
      
      final response = await http.post(
        Uri.parse('https://typhoonista.onrender.com/typhoonista/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'features': [
            windspeed,
            rainfall24,
            rainfall6,
            area,
            riceYield,
            distrackmin,
            price,
          ],
        }),
      );

      if (response.statusCode == 200) {
        prediction = double.parse('${json.decode(response.body)}');
        print(prediction);
        print(prediction.runtimeType);
      } else {
        print("failed");
      }
    } catch (error) {
      print('Errorz: $error');
    }
    return prediction!;
  }
  

}