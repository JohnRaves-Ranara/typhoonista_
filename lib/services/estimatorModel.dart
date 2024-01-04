import "dart:math";
//DUMMY ONLY!!

class estimatorModel{
  
  double getEstimation(){
    final random = Random();
    final min = 1000000.0; // 1 million
    final max = 3000000.0; // 3 million

    // Generate a random double between 0 and 1 (exclusive)
    final randomDouble = random.nextDouble();

    // Scale the random value to the desired range
    return min + (randomDouble * (max - min));
  }

}