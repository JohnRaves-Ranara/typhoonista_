import 'package:cloud_firestore/cloud_firestore.dart';

class Day {
  final String id;
  final Timestamp time_recorded;
  final String typh_name;
  final String location;
  final double windspeed;
  final double rainfall;
  final double damageCost;

  Day(this.id, this.time_recorded, this.typh_name, this.location,
      this.windspeed, this.rainfall, this.damageCost);
}
