import 'Province.dart';

class Typhoon{
  String id;
  String typhoonName;
  double totalDamageCost;
  List<Province> owners = [];

  Typhoon({
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
    );
  }

}