

class Typhoon {
  final String id;
  final String typhoonName;
  final double peakWindspeed;
  final double peakRainfall;
  final String location;
  final String startDate;
  final String endDate;
  final double totalDamageCost;
  final int currentDay;

  Typhoon({required this.id, required this.typhoonName, required this.peakWindspeed, required this.peakRainfall, required this.location, 
  required this.startDate, required this.endDate, required this.totalDamageCost, required this.currentDay
  });

  Map<String, dynamic> toJson(){
    return {
      "id" : id,
      "typhoonName" : typhoonName, 
      "peakWindspeed" : peakWindspeed, 
      "peakRainfall" : peakRainfall,
      "location" : location,
      "startDate" : startDate,
      "endDate" : endDate,
      "totalDamageCost" : totalDamageCost,
      "currentDay" : currentDay
    };
  }

  static Typhoon fromJson(Map<String,dynamic> json) {
    return Typhoon(
      id: json["id"],
      typhoonName : json["typhoonName"] ,
      peakWindspeed : json["peakWindspeed"], 
      peakRainfall : json["peakRainfall"],
      location : json["location"], 
      startDate : json["startDate"],
      endDate:  json["endDate"],
      totalDamageCost: json["totalDamageCost"],
      currentDay: json["currentDay"]
    );
  } 
}

