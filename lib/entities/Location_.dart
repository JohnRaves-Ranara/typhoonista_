import 'TyphoonDay.dart';

class Location_{
  String? typhoonID;
  String munCode;
  String munName;
  String provName;
  String provCode;
  String regName;
  String regCode;
  double glat;
  double glon;
  double meanSlope;
  double meanElevationM;
  double ruggednessStdev;
  double meanRuggedness;
  double slopeStdev;
  double areaKm2;
  double povertyPerc;
  double withCoast;
  double coastLength;
  double perimeter;
  String ricePlanted;
  double riceArea;
  double yield;
  double totalDamageCost = 0;
  List<TyphoonDay> days = [];

  Location_({
    this.typhoonID,
    required this.munCode,
    required this.munName,
    required this.provName,
    required this.provCode,
    required this.regName,
    required this.regCode,
    required this.glat,
    required this.glon,
    required this.meanSlope,
    required this.meanElevationM,
    required this.ruggednessStdev,
    required this.meanRuggedness,
    required this.slopeStdev,
    required this.areaKm2,
    required this.povertyPerc,
    required this.withCoast,
    required this.coastLength,
    required this.perimeter,
    required this.ricePlanted,
    required this.riceArea,
    required this.yield,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location_ &&
          runtimeType == other.runtimeType &&
          typhoonID == other.typhoonID &&
          munCode == other.munCode &&
          munName == other.munName &&
          provName == other.provName &&
          provCode == other.provCode &&
          regName == other.regName &&
          regCode == other.regCode &&
          glat == other.glat &&
          glon == other.glon &&
          meanSlope == other.meanSlope &&
          meanElevationM == other.meanElevationM &&
          ruggednessStdev == other.ruggednessStdev &&
          meanRuggedness == other.meanRuggedness &&
          slopeStdev == other.slopeStdev &&
          areaKm2 == other.areaKm2 &&
          povertyPerc == other.povertyPerc &&
          withCoast == other.withCoast &&
          coastLength == other.coastLength &&
          perimeter == other.perimeter &&
          ricePlanted == other.ricePlanted &&
          riceArea == other.riceArea &&
          yield == other.yield;

  @override
  int get hashCode =>
      typhoonID.hashCode ^
      munCode.hashCode ^
      munName.hashCode ^
      provName.hashCode ^
      provCode.hashCode ^
      regName.hashCode ^
      regCode.hashCode ^
      glat.hashCode ^
      glon.hashCode ^
      meanSlope.hashCode ^
      meanElevationM.hashCode ^
      ruggednessStdev.hashCode ^
      meanRuggedness.hashCode ^
      slopeStdev.hashCode ^
      areaKm2.hashCode ^
      povertyPerc.hashCode ^
      withCoast.hashCode ^
      coastLength.hashCode ^
      perimeter.hashCode ^
      ricePlanted.hashCode ^
      riceArea.hashCode ^
      yield.hashCode;

  @override
  String toString() {
    return 'Location_{typhoonID: $typhoonID, munCode: $munCode, munName: $munName, provName: $provName, provCode: $provCode, regName: $regName, regCode: $regCode, glat: $glat, glon: $glon, meanSlope: $meanSlope, meanElevationM: $meanElevationM, ruggednessStdev: $ruggednessStdev, meanRuggedness: $meanRuggedness, slopeStdev: $slopeStdev, areaKm2: $areaKm2, povertyPerc: $povertyPerc, withCoast: $withCoast, coastLength: $coastLength, perimeter: $perimeter, ricePlanted: $ricePlanted, riceArea: $riceArea, yield: $yield}';
  }

  static Location_ fromJson(Map<String, dynamic> json) {
    return Location_(
      typhoonID: json['typhoonID'],
      munCode: json['mun_code'],
      munName: json['mun_name'],
      provName: json['prov_name'],
      provCode: json['prov_code'],
      regName: json['reg_name'],
      regCode: json['reg_code'],
      glat: double.parse(json['glat']),
      glon: double.parse(json['glon']),
      meanSlope: double.parse(json['mean_slope']),
      meanElevationM: double.parse(json['mean_elevation_m']),
      ruggednessStdev: double.parse(json['ruggedness_stdev']),
      meanRuggedness: double.parse(json['mean_ruggedness']),
      slopeStdev: double.parse(json['slope_stdev']),
      areaKm2: double.parse(json['area_km2']),
      povertyPerc: double.parse(json['poverty_perc']),
      withCoast: double.parse(json['with_coast']),
      coastLength: double.parse(json['coast_length']),
      perimeter: double.parse(json['perimeter']),
      ricePlanted: json['rice_planted'],
      riceArea: double.parse(json['rice_area']),
      yield: double.parse(json['rice_area']),
    );
  }
}
