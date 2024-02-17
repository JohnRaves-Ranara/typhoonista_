// class Location {
//   int provID;
//   int munID;
//   String provName;
//   String munName;

//   Location({required this.provID, required this.munID, required this.provName, required this.munName});

// }
class Location {
  String? provID;
  String? munID;
  String? provName;
  String? munName;

  Location({
    this.provID,
    this.munID,
    this.provName,
    this.munName,
  });

   @override
  String toString() {
    return 'Location{provID: $provID, munID: $munID, provName: $provName, munName: $munName}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          provID == other.provID &&
          munID == other.munID &&
          provName == other.provName &&
          munName == other.munName;

  @override
  int get hashCode =>
      provID.hashCode ^ munID.hashCode ^ provName.hashCode ^ munName.hashCode;
}
