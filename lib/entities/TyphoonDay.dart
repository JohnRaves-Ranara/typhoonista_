

class TyphoonDay {
  final String id;
  final String dateRecorded;
  final String typhoonID;
  final String typhoonName;
  final String location;
  final double windSpeed;
  final double rainfall24;
  final double rainfall6;
  final double price;
  final double distrackmin;
  final double damageCost;
  final int day;
  String? locationCode;
  String? locationID;

  TyphoonDay({
    required this.price,
    required this.distrackmin,
    required this.rainfall24,
    required this.rainfall6,
    this.locationCode,
    this.locationID,
    required this.id,
    required this.dateRecorded,
    required this.typhoonName,
    required this.location,
      required this.windSpeed,
      required this.damageCost,
      required this.day,
      required this.typhoonID});

  Map<String,dynamic> toJson() => {
      "damageCost" : damageCost,
      "dateRecorded" : dateRecorded,
      "day" : day,
      "id" : id,
      "location" : location,
      "rainfall6" : rainfall6,
      "rainfall24" : rainfall24,
      "price" : price,
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
      rainfall6 : json["rainfall6"],
      rainfall24 : json["rainfall24"],
      price : json["price"],
      distrackmin : json["distrackmin"],
      typhoonID : json["typhoonID"],
      typhoonName : json["typhoonName"],
      windSpeed : json["windSpeed"],
      locationCode : json["locationCode"],
      locationID : json['locationID']
    );
  }
}




