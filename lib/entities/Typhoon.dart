import 'package:typhoonista_thesis/entities/Location.dart';

class Typhoon {
  final String id;
  final String typhoonName;
  final double peakWindspeed;
  final double peakRainfall6;
  final double peakRainfall24;
  final String startDate;
  final String endDate;
  final double totalDamageCost;
  final int currentDay;
  List<Location>? locations;
  String? status;


  Typhoon({
    this.status,
    this.locations,
    required this.id, required this.typhoonName, required this.peakWindspeed, required this.peakRainfall6,
    required this.peakRainfall24,
  required this.startDate, required this.endDate, required this.totalDamageCost, required this.currentDay
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

