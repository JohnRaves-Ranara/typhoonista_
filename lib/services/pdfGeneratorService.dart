import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:html' as html;
import 'package:typhoonista_thesis/entities/Location.dart';
import 'package:typhoonista_thesis/entities/Typhoon.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';
// import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class pdfGeneratorService {
  Typhoon? typhoon;
  List<Location>? locations;

  pdfGeneratorService({this.typhoon, this.locations});
  // var typhoonistaLogo;
  final tableHeaders = [
    "Day No.",
    "Date Recorded",
    "Windspeed",
    "Rainfall",
    "Damage Cost"
  ];
  var tableRows;
  

  void initializeTableRows() {
    tableRows = locations!
        .map((loc) => loc.days
            .map((day) => [
                  day.day,
                  "${DateTime.parse(day.dateRecorded).month}/${DateTime.parse(day.dateRecorded).day}/${DateTime.parse(day.dateRecorded).year}",
                  day.windSpeed,
                  day.rainfall,
                  day.damageCost
                ])
            .toList())
        .toList();
  }

  Future<void> generateSamplePDF() async {
    List<Widget> widgets = [];
    // initializeWidgets();
    final typhoonistaLogo =
        (await rootBundle.load('lib/assets/images/typhoonista_logo.png'))
            .buffer
            .asUint8List();
    widgets.add(
      Container(
        width: double.maxFinite,
        child: Column(
          children: [
            Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  Text(
                    'Typhoonista',
                    style: TextStyle(fontSize: 16),
                  ),
                  Image(height: 25, width: 25, MemoryImage(typhoonistaLogo))
                ],
              ),
            ),
            Text(
              "Typhoon Summary Report",
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
        Divider(color: PdfColor.fromHex("#5A5A5A")),
        Container(
                    width: double.maxFinite,
                    // color: Colors.green.shade200,
                    child: Container(
                      // color: Colors.green,
                      height: 280,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              //this right here is the first child
                              // padding: EdgeInsets.all(20),
                              // color: Colors.blue,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Name of Typhoon",
                                        // style: titleStyle,
                                      ),
                                      Text(
                                        "Typhoon ${typhoon!.typhoonName}",
                                        // style: valueStyle,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Typhoon Starting Date",
                                          // style: titleStyle
                                          ),
                                      Text(
                                        "${DateTime.parse(typhoon!.startDate).month}/${DateTime.parse(typhoon!.startDate).day}/${DateTime.parse(typhoon!.startDate).year}",
                                        // style: valueStyle,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Typhoon Ending Date",
                                          // style: titleStyle
                                          ),
                                      Text(
                                        (typhoon!.endDate == "")
                                            ? "Unknown"
                                            : "${DateTime.parse(typhoon!.endDate).month}/${DateTime.parse(typhoon!.endDate).day}/${DateTime.parse(typhoon!.endDate).year}",
                                        // style: valueStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              //this right here is the second child
                              // color: Colors.orange,
                              // padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Typhoon Status", 
                                      // style: titleStyle
                                      ),
                                      Text(
                                        "${typhoon!.status}",
                                        // style: valueStyle,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Total Damage To Rice Crops",
                                          // style: titleStyle
                                          ),
                                      Text(
                                        "${typhoon!.totalDamageCost} PHP",
                                        // style: valueStyle,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Locations", 
                                      // style: titleStyle
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: locations!
                                                .map((loc) => Text(
                                                      "- ${loc.name}",
                                                      // style: valueStyle,
                                                    ))
                                                .toList(),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
          ]
        )
      ),
    );
    
    final pdf = Document();

    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context)  {
          return widgets;
        }
        ));

    var savedFile = await pdf.save();
    List<int> fileInts = List.from(savedFile);
    html.AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
      ..setAttribute("download", "sample.pdf")
      ..click();
  }
}
