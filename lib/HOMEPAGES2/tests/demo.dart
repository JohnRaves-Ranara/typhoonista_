import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Day.dart';
import '../services2/forecastModel.dart';

class demo extends StatefulWidget {
  const demo({super.key});

 

  @override
  State<demo> createState() => _demoState();
}

class _demoState extends State<demo> {
  TextEditingController wsController = TextEditingController();
  TextEditingController rf24Controller = TextEditingController();
  TextEditingController rf6Controller = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController yieldController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController daysController = TextEditingController();

  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: wsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Initial Wind Speed'),
            ),
            TextField(
              controller: rf24Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Initial Rainfall (24h)'),
            ),
            TextField(
              controller: rf6Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Initial Rainfall (6h)'),
            ),
            TextField(
              controller: areaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Area'),
            ),
            TextField(
              controller: yieldController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Yield'),
            ),
            TextField(
              controller: distanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Distance'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: daysController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Number of Days'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (()async{
                List<Day> forecastDamageCosts = await forecastModel().forecast(
                  initial_ws: double.parse(wsController.text.trim()),
                  initial_rf24: double.parse(rf24Controller.text.trim()),
                  initial_rf6: double.parse(rf6Controller.text.trim()),
                  initial_area: double.parse(areaController.text.trim()),
                  initial_yield: double.parse(yieldController.text.trim()),
                  initial_distance: double.parse(distanceController.text.trim()),
                  rice_price: double.parse(priceController.text.trim()),
                  days: int.parse(daysController.text.trim())
                  );
                
                forecastDamageCosts.forEach((dayDamage) => print(dayDamage));
                setState(() {
                  result = forecastDamageCosts.map((dayDamage) => dayDamage.damageCost).toList().toString();
                });
              }),
              child: Text('Calculate Forecast'),
            ),
            SizedBox(height: 20),
            Text(result),
          ],
        ),
      ),
    );
  }
}