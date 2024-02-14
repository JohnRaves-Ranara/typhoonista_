
class Day{
  String id;
  double damageCost;
  int dayNum;
  double rainfall24;
  double rainfall6;
  double riceArea;
  double riceYield;
  double ricePrice;
  double windSpeed;

  Day({
    required this.id,
    required this.damageCost,
    required this.dayNum,
    required this.rainfall24,
    required this.rainfall6,
    required this.riceArea,
    required this.riceYield,
    required this.ricePrice,
    required this.windSpeed
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "damageCost": damageCost,
        "dayNum": dayNum,
        "rainfall24": rainfall24,
        "rainfall6": rainfall6,
        "riceArea": riceArea,
        "riceYield": riceYield,
        "ricePrice": ricePrice,
        "windSpeed": windSpeed,
      };

  static Day fromJson(Map<String, dynamic> json) {
    return Day(
      id: json["id"],
      damageCost: json["damageCost"],
      dayNum: json["dayNum"],
      rainfall24: json["rainfall24"],
      rainfall6: json["rainfall6"],
      riceArea: json["riceArea"],
      riceYield: json["riceYield"],
      ricePrice: json["ricePrice"],
      windSpeed: json["windSpeed"],
    );
  }
  
}