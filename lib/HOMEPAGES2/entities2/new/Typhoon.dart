import 'Province.dart';

class Typhoon{
  String id;
  String typhoonName;
  String? status;
  double totalDamageCost;
  List<Province> owners = [];

  Typhoon({
    this.status,
    required this.id,
    required this.typhoonName,
    required this.totalDamageCost
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "typhoonName": typhoonName,
        "totalDamageCost": totalDamageCost,
      };

  static Typhoon fromJson(Map<String, dynamic> json) {
    return Typhoon(
      id: json["id"],
      typhoonName: json["typhoonName"],
      totalDamageCost: json["totalDamageCost"],
      status: json["status"]
    );
  }

}