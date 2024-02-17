import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:vector_map/vector_map.dart';

class test5 extends StatefulWidget {
  const test5({super.key});

  @override
  State<test5> createState() => _test5State();
}

class _test5State extends State<test5> {
  late MapShapeSource _shapeSource;
  // VectorMapController? _controller;
  @override
  void initState() {
    super.initState();
    _shapeSource = const MapShapeSource.asset(
      // 'lib/philippines-with-regions_ (2).geojson',
      'lib/services/MuniCities.minimal.json',
      
      shapeDataField: "NAME_2",
    );

    print(_shapeSource);
    
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            child: 
            
            SfMaps(
              layers: [
                MapShapeLayer(
                  source: _shapeSource,
                  showDataLabels: true,
                  dataLabelSettings: const MapDataLabelSettings(
                    overflowMode: MapLabelOverflow.hide,
                    textStyle: TextStyle(color: Colors.black, fontSize: 9),
                  ),
                )
              ],
            ),
            

          )
          // Text("hello world")
        ],
      ),
    );
  }
}
