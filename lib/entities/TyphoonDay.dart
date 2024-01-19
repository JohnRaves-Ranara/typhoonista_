

class TyphoonDay {
  final String id;
  final String dateRecorded;
  final String typhoonID;
  final String typhoonName;
  final String location;
  final double windSpeed;
  final double rainfall;
  final double damageCost;
  final int day;
  String? locationCode;
  String? locationID;

  TyphoonDay({
    this.locationCode,
    this.locationID,
    required this.id, required this.dateRecorded, required this.typhoonName, required this.location,
      required this.windSpeed, required this.rainfall, required this.damageCost, required this.day, required this.typhoonID});

  Map<String,dynamic> toJson() => {
      "damageCost" : damageCost,
      "dateRecorded" : dateRecorded,
      "day" : day,
      "id" : id,
      "location" : location,
      "rainfall" : rainfall,
      "typhoonID" : typhoonID,
      "typhoonName" : typhoonName,
      "windSpeed" : windSpeed,
      "locationCode" : locationCode,
      "locationID" : locationID
    };

  static TyphoonDay fromJson(Map<String, dynamic> json){
    return TyphoonDay(
      damageCost : json["damageCost"],
      dateRecorded : json["dateRecorded"],
      day : json["day"],
      id : json["id"],
      location : json["location"],
      rainfall : json["rainfall"],
      typhoonID : json["typhoonID"],
      typhoonName : json["typhoonName"],
      windSpeed : json["windSpeed"],
      locationCode : json["locationCode"],
      locationID : json['locationID']
    );
  }
}




