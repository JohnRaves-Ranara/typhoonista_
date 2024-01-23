import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:html' as html;
import 'package:typhoonista_thesis/entities/Location.dart';
import 'package:typhoonista_thesis/entities/Typhoon.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';
// import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:typhoonista_thesis/entities/Row.dart';
import 'package:flutter/material.dart' as m;

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

  // printthis() {
  //   final v = locations!
  //       .map((loc) => loc.days
  //           .map((day) => [
  //                 day.day,
  //                 "${DateTime.parse(day.dateRecorded).month}/${DateTime.parse(day.dateRecorded).day}/${DateTime.parse(day.dateRecorded).year}",
  //                 day.windSpeed,
  //                 day.rainfall,
  //                 day.damageCost
  //               ])
  //           .toList())
  //       .toList();
  // }

  String numberFormatter({required double number}) {
    return NumberFormat('#,##0.00', 'en_US').format(number);
  }

  Future<void> generateSamplePDF() async {
    final tableRows = locations!
        .map((loc) => loc.days
            .map((day) => [
                  day.day,
                  "${DateTime.parse(day.dateRecorded).month}/${DateTime.parse(day.dateRecorded).day}/${DateTime.parse(day.dateRecorded).year}",
                  day.windSpeed,
                  day.rainfall,
                  numberFormatter(number: day.damageCost)
                ])
            .toList())
        .toList();
    List<Widget> widgets = [];
    // initializeWidgets();
    final typhoonistaLogo =
        (await rootBundle.load('lib/assets/images/typhoonista_logo.png'))
            .buffer
            .asUint8List();
    widgets.add(
      Container(
          width: double.maxFinite,
          child: Column(children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text(
                          'Typhoonista',
                          style: TextStyle(fontSize: 14),
                        ),
                        Image(
                            height: 25, width: 25, MemoryImage(typhoonistaLogo))
                      ],
                    ),
                  ),
                  Text(
                    "Typhoon Summary Report",
                    style: TextStyle(fontSize: 14),
                  ),
                  
                ],
              ),
            Divider(color: PdfColor.fromHex("#5A5A5A")),
            Container(
            width: double.maxFinite,
            height: 225,//todo try gridview
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Typhoon Starting Date",
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Typhoon Ending Date",
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Typhoon Status",
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Damage To Rice Crops",
                            // style: titleStyle
                          ),
                          Text(
                            "${numberFormatter(number: typhoon!.totalDamageCost)} PHP",
                            // style: valueStyle,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Locations",
                            // style: titleStyle
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: locations!
                                .map((loc) => Bullet(text: "${loc.name}"
                                    //style
                                    ))
                                .toList(),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
                        ),
            SizedBox(height: 10)
          ])),
    );

    for (int i = 0; i < locations!.length; i++) {
      final location = locations![i];
      widgets.add(Wrap(children: [
        Container(
          margin: (i == 0)
              ? EdgeInsets.only(bottom: 15)
              : (i == locations!.length - 1)
                  ? EdgeInsets.only(top: 15)
                  : EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Location",
                // style: textStyles.lato_regular(
                //     fontSize: 14, color: Colors.grey),
              ),
              Text(
                "${location.name}",
                // style: textStyles.lato_regular(
                //     fontSize: 14, color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  child: TableHelper.fromTextArray(
                      headers: tableHeaders, data: tableRows[i])),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Spacer(),
                  Text(
                      "Total Damage Cost: ${numberFormatter(number: location.totalDamageCost)} PHP")
                ],
              ),
            ],
          ),
        )
      ]));
    }

    final pdf = Document();

    pdf.addPage(MultiPage(
        margin: EdgeInsets.all(20),
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return widgets;
        },
        footer: (context) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(height: 18, width: 18, MemoryImage(typhoonistaLogo)),
                SizedBox(width: 10),
                Text('TYPHOONISTA  -  ${DateTime.now().year}', style: TextStyle(fontSize: 10, color: PdfColor.fromHex("#0090D9")))
              ]);
        }));

    var savedFile = await pdf.save();
    List<int> fileInts = List.from(savedFile);
    html.AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
      ..setAttribute("download", "sample.pdf")
      ..click();
  }
}
