import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class test5 extends StatefulWidget {
  const test5({super.key});

  @override
  State<test5> createState() => _test5State();
}

class _test5State extends State<test5> {
  late MapShapeSource _shapeSource;

  @override
  void initState(){
    super.initState();
    _shapeSource = MapShapeSource.asset('MuniCities.json',
    shapeDataField: 'NAME_2',

    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SfMaps(
            layers: [
              MapShapeLayer(source: _shapeSource)
            ],
          )
        ],
      ),
    );
  }
}






