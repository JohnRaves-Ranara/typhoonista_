
import 'package:typhoonista_thesis/entities/Location_.dart';
import 'jsonLocations.dart';

class Locations_{
  List<Location_> getLocations(){
  return jsonLocations().locations.map((loc) => Location_.fromJson(loc)).toList();
  }
}

void main(){

  final v = Locations_().getLocations();

  print(v.length);
  
  }


