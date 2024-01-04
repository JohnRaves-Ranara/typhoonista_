import 'package:cloud_firestore/cloud_firestore.dart';

import 'Day.dart';

class Typhoon {
  final String id;
  final String name;  
  final double? avg_winspeed;
  final double? avg_rainfall;
  final String location;
  final List<Day> days;
  final DateTime startDate;
  final DateTime? endDate;
  final double totalDamageCost;

  Typhoon(this.id, this.name, this.avg_winspeed, this.avg_rainfall, this.location,
      this.days, this.startDate, this.endDate, this.totalDamageCost);
}
