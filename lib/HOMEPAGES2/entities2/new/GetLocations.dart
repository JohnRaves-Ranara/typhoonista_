
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';

import 'Location.dart';
import 'package:http/http.dart' as http;

class GetLocations{

  Future<List<Location>> getLocations()async{
  // String geojsonData = File('lib/services/MuniCities.minimal.json').readAsStringSync();

  // // Parse JSON
  // Map<String, dynamic> jsonData = json.decode(geojsonData);

  final String response = await rootBundle.loadString('lib/services/MuniCities.minimal.json');
  Map<String,dynamic> data = await json.decode(response);

  // Extract "features" array
  List<dynamic> features = data['features'];

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

// void main(){
//   final locations = GetLocations().getLocations();
//   locations.forEach((location) {
//     print('provID: ${location.provID}, munID: ${location.munID}, provName: ${location.provName}, munName: ${location.munName}');
//   });
// }