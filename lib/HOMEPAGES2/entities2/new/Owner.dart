
import 'dart:ui';
import 'Day.dart';

class Owner {
  String id;
  String? provinceID;
  String? municipalityID;
  String? provName;
  String? munName;
  String? typhoonID;
  String ownerName;
  double totalDamageCost;
  List<Day> days = [];
  Color colorMarker;

  Owner({
    required this.id,
    this.provinceID,
    this.municipalityID,
    this.typhoonID,
    this.munName,
    this.provName,
    required this.ownerName,
    required this.totalDamageCost,
    required this.colorMarker,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Owner &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          provinceID == other.provinceID &&
          municipalityID == other.municipalityID &&
          typhoonID == other.typhoonID &&
          ownerName == other.ownerName &&
          totalDamageCost == other.totalDamageCost &&
          colorMarker == other.colorMarker &&
          munName == other.munName &&
          provName == other.provName
          
          ;

  @override
  int get hashCode =>
      id.hashCode ^
      provinceID.hashCode ^
      municipalityID.hashCode ^
      typhoonID.hashCode ^
      ownerName.hashCode ^
      totalDamageCost.hashCode ^
      colorMarker.hashCode ^
      munName.hashCode ^
      provName.hashCode;

  Map<String, dynamic> toJson() => {
        "id": id,
        "ownerName": ownerName,
        "totalDamageCost": totalDamageCost,
        "provinceID": provinceID,
        "municipalityID": municipalityID,
        "typhoonID": typhoonID,
        "color": colorMarker 
      };

  static Owner fromJson(Map<String, dynamic> json) {
    return Owner(
        id: json["id"],
        ownerName: json["ownerName"],
        totalDamageCost: json["totalDamageCost"],
        provinceID: json["provinceID"],
        municipalityID: json["municipalityID"],
        typhoonID: json["typhoonID"],
        munName: json['munName'],
        provName: json['provName'],
        colorMarker: Color.fromARGB(
            255, json["color"][0], json["color"][1], json["color"][2]).withOpacity(0.3));
  }
}
