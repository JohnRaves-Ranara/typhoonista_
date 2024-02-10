import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:typhoonista_thesis/entities/Location.dart';

class test2 extends StatefulWidget {
  const test2({super.key});

  @override
  State<test2> createState() => _test2State();
}

class _test2State extends State<test2> {
  late List<LocationDamage> data;

  @override
  void initState(){
    super.initState();
    data = getData();
  }


  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
        Container(
          child: SfCircularChart(
            series: <CircularSeries>[
              DoughnutSeries<LocationDamage, String>(
                pointColorMapper: (LocationDamage data, _) => data.pointColor,
                dataSource: data,
                xValueMapper: (LocationDamage data, _) => data.locationName,
                yValueMapper: (LocationDamage data, _) => data.damageInPercentage,
              )
            ],
          ),
        ),
        Column(
          children: [
            Text('Total Damage Cost of \nTyphoon to Rice Crops', textAlign: TextAlign.center, style: textStyles.lato_bold( fontSize: 20), ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: data.map((d) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    CircleAvatar(radius: 10, backgroundColor: d.pointColor,),
                    SizedBox(width: 10,),
                    Text(d.locationName!, style: textStyles.lato_light(fontSize: 20),),
                    SizedBox(width: 10,),
                    Text('${d.damageInPercentage}%' ,style: textStyles.lato_light(fontSize: 20),),
                  ],
                ),
              )).toList(),
            )
          ],
        ),
      ]
      );
  }



  List<LocationDamage> getData(){
    final List<LocationDamage> data = [
      LocationDamage('Aklan', 30, Colors.green),
      LocationDamage('Tagum', 15, Colors.red),
      LocationDamage('Aborlan', 15, Colors.orange),
      LocationDamage('Hevabi', 40, Colors.blue)
    ];
    return data;
  }
}

class LocationDamage{
  String? locationName;
  double? damageInPercentage;
  Color? pointColor;
  LocationDamage(this.locationName, this.damageInPercentage, this.pointColor);
}