import 'Owner.dart';

class Municipality{
  String id;
  String munName;
  double totalDamageCost;
  List<Owner> owners = [];

  Municipality({
    required this.id,
    required this.munName,
    required this.totalDamageCost
  });

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
    );
  }

}