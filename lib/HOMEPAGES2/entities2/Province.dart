import 'Municipality.dart';

class Province{
  String id;
  String provName;
  double totalDamageCost;
  List<Municipality> owners = [];

  Province({
    required this.id,
    required this.provName,
    required this.totalDamageCost
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "provName": provName,
        "totalDamageCost": totalDamageCost,
      };

  static Province fromJson(Map<String, dynamic> json) {
    return Province(
      id: json["id"],
      provName: json["provName"],
      totalDamageCost: json["totalDamageCost"],
    );
  }

}