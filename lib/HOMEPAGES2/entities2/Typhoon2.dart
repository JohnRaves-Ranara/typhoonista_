import 'package:typhoonista_thesis/entities/Location.dart';

class Typhoon {
  final String id;
  final String typhoonName;
  double? peakWindspeed;
  double? peakRainfall6;
  double? peakRainfall24;
  String? startDate;
  String? endDate;
  double? totalDamageCost;
  int? currentDay;
  List<Location>? locations;
  String? status;


  Typhoon({
    this.status,
    this.locations,
    required this.id, required this.typhoonName, this.peakWindspeed, this.peakRainfall6,
    this.peakRainfall24,
  this.startDate, this.endDate, this.totalDamageCost, this.currentDay
  });

  Map<String, dynamic> toJson(){
    return {
      "id" : id,
      "typhoonName" : typhoonName, 
      "peakWindspeed" : peakWindspeed, 
      "peakRainfall6" : peakRainfall6,
      "peakRainfall24" : peakRainfall24,
      "startDate" : startDate,
      "endDate" : endDate,
      "totalDamageCost" : totalDamageCost,
      "currentDay" : currentDay,
      "status" : status
    };
  }

  static Typhoon fromJson(Map<String,dynamic> json) {
    return Typhoon(
      id: json["id"],
      typhoonName : json["typhoonName"] ,
      peakWindspeed : json["peakWindspeed"], 
      peakRainfall6 : json["peakRainfall6"],
      peakRainfall24 : json["peakRainfall24"],
      startDate : json["startDate"],
      endDate:  json["endDate"],
      totalDamageCost: json["totalDamageCost"],
      currentDay: json["currentDay"],
      status: json["status"]
    );
  } 
}

