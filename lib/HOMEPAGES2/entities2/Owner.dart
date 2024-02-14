import 'Day.dart';

class Owner{
  String id;
  String ownerName;
  double totalDamageCost;
  List<Day> days = [];

  Owner({
    required this.id,
    required this.ownerName,
    required this.totalDamageCost
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "ownerName": ownerName,
        "totalDamageCost": totalDamageCost,
      };

  static Owner fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json["id"],
      ownerName: json["ownerName"],
      totalDamageCost: json["totalDamageCost"],
    );
  }
}