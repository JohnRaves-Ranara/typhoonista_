import 'dart:ui';

import 'Owner.dart';

class Municipality {
  String id;
  String? typhoonID;
  String? provinceID;
  String munName;
  double totalDamageCost;
  List<Owner> owners = [];
  Color colorMarker;
  int? damageCostInPercentage;

  double? highestWs;
  double? highestRf24;
  double? highestRf6;
  double? avgWs;
  double? avgRf24;
  double? avgRf6;
  double? avgDamage;

  Municipality(
      {this.highestWs,
      this.highestRf24,
      this.highestRf6,
      this.avgWs,
      this.avgRf24,
      this.avgRf6,
      this.avgDamage,
      required this.id,
      this.typhoonID,
      this.provinceID,
      required this.munName,
      required this.totalDamageCost,
      required this.colorMarker,
      this.damageCostInPercentage});

  Map<String, dynamic> toJson() => {
        "id": id,
        "munName": munName,
        "totalDamageCost": totalDamageCost,
      };

  static Municipality fromJson(Map<String, dynamic> json) {
    return Municipality(
        id: json["id"],
        munName: json["munName"],
        totalDamageCost: json["totalDamageCost"],
        typhoonID: json["typhoonID"],
        provinceID: json["provinceID"],
        colorMarker: Color.fromARGB(
            255, json["color"][0], json["color"][1], json["color"][2]));
  }
}
