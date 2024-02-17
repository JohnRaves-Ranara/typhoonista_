
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
  String? dateRecorded;

  // int? dayNum;
  // double? rainfall24;
  // double? rainfall6;
  // double? riceArea;
  // double? riceYield;
  // double? ricePrice;
  // double? windSpeed;
  // double? distance;

  Owner({
  //   this. dayNum,
  // this. rainfall24,
  // this. rainfall6,
  // this. riceArea,
  // this. riceYield,
  // this. ricePrice,
  // this. windSpeed,
  // this. distance,
    required this.id,
    this.provinceID,
    this.municipalityID,
    this.typhoonID,
    this.munName,
    this.provName,
    required this.ownerName,
    required this.totalDamageCost,
    required this.colorMarker,
    this.dateRecorded
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
          provName == other.provName &&
          dateRecorded == other.dateRecorded 
          // &&
          // dayNum == other.dayNum &&
          // rainfall24== other.rainfall24 &&
          // rainfall6 == other.rainfall6 &&
          // riceArea == other.riceArea &&
          // riceYield == other.riceYield &&
          // ricePrice == other.ricePrice &&
          // windSpeed == other.windSpeed &&
          // distance == other.distance
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
      provName.hashCode ^
      dateRecorded.hashCode 
  //     ^
  //     dayNum.hashCode ^
  // rainfall24.hashCode ^
  // rainfall6.hashCode ^
  // riceArea.hashCode ^
  // riceYield.hashCode ^
  // ricePrice.hashCode ^
  // windSpeed.hashCode ^
  // distance.hashCode
      
      ;

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
        dateRecorded: json["dateRecorded"],
        // dayNum : json["dayNum"],
        // rainfall24: json["rainfall24"],
        // rainfall6 : json["rainfall6"],
        // riceArea : json["riceArea"],
        // riceYield : json["riceYield"],
        // ricePrice : json["ricePrice"],
        // windSpeed : json["windSpeed"],
        // distance : json["distance"],
        colorMarker: Color.fromARGB(
            255, json["color"][0], json["color"][1], json["color"][2]).withOpacity(0.3));
  }
}
