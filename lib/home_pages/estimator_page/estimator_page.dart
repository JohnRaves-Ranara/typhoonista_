import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:typhoonista_thesis/services/FirestoreService.dart';

class estimator_page extends StatefulWidget {
  const estimator_page({super.key});

  @override
  State<estimator_page> createState() => _estimator_pageState();
}

class _estimator_pageState extends State<estimator_page> {
  final typhoonNameCtlr = TextEditingController();
  final windspeedCtlr = TextEditingController();
  final rainfallCtlr = TextEditingController();
  final locationCtlr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 70, vertical: 50),
        child: Column(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Damage Cost Estimator",
                    style: textStyles.lato_black(fontSize: 32),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "The impact of the industrial revolution has began to uprise in terms of the rice and skermberlu it ornare accumsan. Justo vulputate in pretium integer vulputate vitae proin congue etiam. Sollicitudin egestas est in ultrices molestie lacus iaculis risus. Velit habitasse felis auctor at.",
                    style: textStyles.lato_light(fontSize: 18),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Divider(
              thickness: 1,
            ),
            Expanded(
                flex: 80,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      // color: Colors.green,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Add New Typhoon",
                            style: textStyles.lato_black(fontSize: 30),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          TextField(
                            controller: typhoonNameCtlr,
                            decoration: InputDecoration(
                                labelStyle: textStyles.lato_light(
                                    color: Colors.grey.withOpacity(0.9)),
                                border: OutlineInputBorder(),
                                labelText: "Name"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: windspeedCtlr,
                            decoration: InputDecoration(
                                labelStyle: textStyles.lato_light(
                                    color: Colors.grey.withOpacity(0.9)),
                                border: OutlineInputBorder(),
                                labelText: "Peak Windspeed"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: rainfallCtlr,
                            decoration: InputDecoration(
                                labelStyle: textStyles.lato_light(
                                    color: Colors.grey.withOpacity(0.9)),
                                border: OutlineInputBorder(),
                                labelText: "Peak Rainfall"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: locationCtlr,
                            decoration: InputDecoration(
                                labelStyle: textStyles.lato_light(
                                    color: Colors.grey.withOpacity(0.9)),
                                border: OutlineInputBorder(),
                                labelText: "Location"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Material(
                              color: Colors.blue,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: (() {
                                  FirestoreService().addDay(
                                      typhoonId: null,
                                      typhoonName: typhoonNameCtlr.text.trim(),
                                      windSpeed: double.parse(windspeedCtlr.text.trim()),
                                      rainfall: double.parse(rainfallCtlr.text.trim()),
                                      location: locationCtlr.text.trim(),
                                      isFirstDay: true
                                      );
                                  typhoonNameCtlr.clear();
                                  windspeedCtlr.clear();
                                  rainfallCtlr.clear();
                                  locationCtlr.clear();
                                }),
                                child: Ink(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  width: double.maxFinite,
                                  height: 55,
                                  child: Row(
                                    children: [
                                      Text(
                                        "Estimate Damage Cost",
                                        style: textStyles.lato_bold(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.arrow_right_alt_sharp,
                                        size: 40,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                    Expanded(
                        child: Container(
                      color: Colors.blue,
                    ))
                  ],
                )),
          ],
        ));
  }
}
