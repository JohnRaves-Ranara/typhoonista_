class Day {
  String? id;
  String? typhoonID;
  String? provinceID;
  String? municipalityID;
  String? ownerID;
  double? damageCost;
  int? dayNum;
  double? rainfall24;
  double? rainfall6;
  double? riceArea;
  double? riceYield;
  double? ricePrice;
  double? windSpeed;
  double? distance;


  Day({
    this.id,
    this.typhoonID,
    this.provinceID,
    this.municipalityID,
    this.ownerID,
    this.damageCost,
    this.dayNum,
    this.rainfall24,
    this.rainfall6,
    this.riceArea,
    this.riceYield,
    this.ricePrice,
    this.windSpeed,
    this.distance,
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
        typhoonID: json["typhoonID"],
        provinceID: json["provinceID"],
        municipalityID: json["municipalityID"],
        ownerID: json["ownerID"],
        distance: json["disTrackMin"]);
  }

  @override
  String toString() {
    return "Day(id: $id, typhoonID: $typhoonID, provinceID: $provinceID, municipalityID: $municipalityID, ownerID: $ownerID, damageCost: $damageCost, dayNum: $dayNum, rainfall24: $rainfall24, rainfall6: $rainfall6, riceArea: $riceArea, riceYield: $riceYield, ricePrice: $ricePrice, windSpeed: $windSpeed, distance: $distance)";
  }
}
