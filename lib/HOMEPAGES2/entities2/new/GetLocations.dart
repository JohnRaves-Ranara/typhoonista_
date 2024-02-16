
import 'dart:io';
import 'dart:convert';
import 'Location.dart';

class GetLocations{

  List<Location> getLocations(){
  String geojsonData = File('lib/MuniCities.minimal.json').readAsStringSync();

  // Parse JSON
  Map<String, dynamic> jsonData = json.decode(geojsonData);

  // Extract "features" array
  List<dynamic> features = jsonData['features'];

  // Map to List<Location>
  List<Location> locations = features.map((feature) {
    return Location(
      provID: feature['properties']['ID_1'],
      munID: feature['properties']['ID_2'],
      provName: feature['properties']['NAME_1'],
      munName: feature['properties']['NAME_2'],
    );
  }).toList();

  return locations;
    
  }
}