import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Day.dart';
import '../HOMEPAGES2/entities2/new/Owner.dart';
import '../assets/themes/textStyles.dart';

class test1 extends StatefulWidget {
  const test1({super.key});

  @override
  State<test1> createState() => _test1State();
}

class _test1State extends State<test1> {
  Owner owner = Owner(
      id: '12345',
      ownerName: 'Aklan, Kalibo',
      munName: 'Kalibo',
      provName: 'Aklan',
      municipalityID: '12345666',
      provinceID: '213213',
      totalDamageCost: 123456.7,
      colorMarker: Colors.green,
      dateRecorded: "2024-03-06 00:45:12.252"
      );

  Day firstDay = Day(
  id: '123123123' ,
  typhoonID: '12312312',
  provinceID: '123123',
  municipalityID: '123123',
  ownerID: '123123',
  damageCost: 1234567.21,
  dayNum: 1,
  rainfall24: 11.23,
  rainfall6: 12.3,
  riceArea: 1234.1,
  riceYield: 2.21,
  ricePrice: 23,
  windSpeed: 24.23,
  distance: 211.2,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(child: Text("das"), onPressed: ((){
              showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    content: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.5,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                    owner.ownerName,
                    style: textStyles.lato_black(fontSize: 24),
                  ),
                  Row(
                    children: [
                      Text("Date Recorded:", style: textStyles.lato_bold(fontSize: 15),),
                      SizedBox(width: 10,),
                  Text("${DateTime.parse(owner.dateRecorded!).month}/${DateTime.parse(owner.dateRecorded!).day}/${DateTime.parse(owner.dateRecorded!).year} ${DateTime.parse(owner.dateRecorded!).hour.toString().padLeft(2, '0')}:${DateTime.parse(owner.dateRecorded!).minute.toString().padLeft(2, '0')}:${DateTime.parse(owner.dateRecorded!).second.toString().padLeft(2, '0')}", style: textStyles.lato_regular(fontSize: 15),)
                    ],
                  )
                    ],
                  ),
                  SizedBox(height: 15,),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Windspeed (km/h)", style: textStyles.lato_bold(fontSize: 15),),
                                  Text(firstDay.windSpeed.toString(), style: textStyles.lato_regular(fontSize: 15),)
                                ],
                              ),
                              SizedBox(height: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("24-hour rainfall (mm)", style: textStyles.lato_bold(fontSize: 15),),
                                  Text(firstDay.windSpeed.toString(), style: textStyles.lato_regular(fontSize: 15),)
                                ],
                              ),
                              SizedBox(height: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("6-hour rainfall (mm)", style: textStyles.lato_bold(fontSize: 15),),
                                  Text(firstDay.windSpeed.toString(), style: textStyles.lato_regular(fontSize: 15),)
                                ],
                              ),
                              SizedBox(height: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Rice Price (PHP)", style: textStyles.lato_bold(fontSize: 15),),
                                  Text(firstDay.windSpeed.toString(), style: textStyles.lato_regular(fontSize: 15),)
                                ],
                              ),
                              SizedBox(height: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Days Count", style: textStyles.lato_bold(fontSize: 15),),
                                  Text('6', style: textStyles.lato_regular(fontSize: 15),)
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Rice Area (ha)", style: textStyles.lato_bold(fontSize: 15),),
                                  Text(firstDay.windSpeed.toString(), style: textStyles.lato_regular(fontSize: 15),)
                                ],
                              ),
                              SizedBox(height: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Yield (ton/ha)", style: textStyles.lato_bold(fontSize: 15),),
                                  Text(firstDay.windSpeed.toString(), style: textStyles.lato_regular(fontSize: 15),)
                                ],
                              ),
                              SizedBox(height: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Province", style: textStyles.lato_bold(fontSize: 15),),
                                  Text(firstDay.windSpeed.toString(), style: textStyles.lato_regular(fontSize: 15),)
                                ],
                              ),
                              SizedBox(height: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Municipality", style: textStyles.lato_bold(fontSize: 15),),
                                  Text(firstDay.windSpeed.toString(), style: textStyles.lato_regular(fontSize: 15),)
                                ],
                              ),
                              SizedBox(height: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Distance of Typhoon to Location (km)", style: textStyles.lato_bold(fontSize: 15),),
                                  Text(firstDay.distance.toString(), style: textStyles.lato_regular(fontSize: 15),)
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
                  );
                }
              );
            }),)
          )
        ],
      ),
    );
  }
}
