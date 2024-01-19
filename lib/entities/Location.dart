import 'TyphoonDay.dart';
import 'package:flutter/foundation.dart';

class Location {
  String? typhoonID;
  String code;
  String name;
  double totalDamageCost = 0;
  List<TyphoonDay> days = [];

  Location({
    this.typhoonID,
    required this.code,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          typhoonID == other.typhoonID &&
          code == other.code &&
          name == other.name;

  @override
  int get hashCode =>
      typhoonID.hashCode ^
      code.hashCode ^
      name.hashCode;

  @override
  String toString() {
    return 'Location{typhoonID: $typhoonID, code: $code, name: $name, totalDamageCost: $totalDamageCost, days: $days}';
  }
}

// You may need to import the following package for the listEquals function:
// import 'package:flutter/foundation.dart';

Location fromJson(Map<String, dynamic> json) {
  return Location(
    typhoonID: json['typhoonId'],
    code: json['locationCode'],
    name: json['name'],
  );
}
