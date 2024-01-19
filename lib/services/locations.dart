
import 'package:typhoonista_thesis/entities/Location.dart';

class Locations{
  
  final List<Location> _locationsJson = [
    Location(name: "Davao", code: "dav1"),
    Location(name: "Cebu", code: "ceb2"),
    Location(name: "Arakan", code: "arak3"),
    Location(name: "Surigao", code: "sur4")
  ];

  List<Location> get locationsJson => _locationsJson;

}

void main(){

  // for(var i in Locations().locationsJson.entries){
  //   print(i);
  // }
}