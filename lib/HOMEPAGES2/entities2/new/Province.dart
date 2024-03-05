import 'dart:ui';

import 'Municipality.dart';

class Province {
  String id;
  String? typhoonID;
  String provName;
  double totalDamageCost;
  List<Municipality> owners = [];
  double? damageCostInPercentage;
  Color? colorMarker;

  double? highestWs;
  double? highestRf24;
  double? highestRf6;
  double? avgWs;
  double? avgRf24;
  double? avgRf6;
  double? avgDamage;

  Province(
      {this.avgWs,
      this.avgRf24,
      this.avgRf6,
      this.avgDamage,
      this.highestWs,
      this.highestRf24,
      this.highestRf6,
      required this.id,
      this.typhoonID,
      required this.provName,
      required this.totalDamageCost,
      this.damageCostInPercentage,
      this.colorMarker});

  Map<String, dynamic> toJson() => {
        "id": id,
        "provName": provName,
        "totalDamageCost": totalDamageCost,
      };

  static Province fromJson(Map<String, dynamic> json) {
    return Province(
        id: json["id"],
        provName: json["provName"],
        totalDamageCost: json["totalDamageCost"],
        typhoonID: json["typhoonID"],
        colorMarker: Color.fromARGB(
            255, json["color"][0], json["color"][1], json["color"][2]));
  }
}
