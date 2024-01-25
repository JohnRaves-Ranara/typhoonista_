import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:html' as html;
// import 'package:typhoonista_thesis/entities/Location.dart';
import 'package:typhoonista_thesis/entities/Location_.dart';
import 'package:typhoonista_thesis/entities/Typhoon.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';
// import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:typhoonista_thesis/entities/Row.dart';
import 'package:flutter/material.dart' as m;
import 'package:printing/printing.dart';
import 'package:printing/printing_web.dart';

class pdfGeneratorService {
  Typhoon? typhoon;
  List<Location_>? locations;

  pdfGeneratorService({this.typhoon, this.locations});
  // var typhoonistaLogo;
  final tableHeaders = [
    "Day No.",
    "Date Recorded",
    "Windspeed",
    "Rainfall",
    "Damage Cost"
  ];

  String numberFormatter({required double number}) {
    return NumberFormat('#,##0.00', 'en_US').format(number);
  }

  Future<void> generateSamplePDF() async {
    final latoReg = await PdfGoogleFonts.latoRegular();
    final latoBold = await PdfGoogleFonts.latoBold();
    final latoItalicBold = await PdfGoogleFonts.latoBoldItalic();
    TextStyle titleStyle =
      TextStyle(color: PdfColor.fromHex("#808080"), fontSize: 12, font: latoReg);
  TextStyle valueStyle =
      TextStyle(color: PdfColor.fromHex("#000000"), fontSize: 12, font: latoReg);
  TextStyle header1Style = TextStyle(color: PdfColor.fromHex("#000000"), fontSize: 14, font: latoBold);
  TextStyle header2Style = TextStyle(color: PdfColor.fromHex("#000000"), fontSize: 14, font: latoItalicBold);
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
                          style: header1Style
                        ),
                        Image(
                            height: 25, width: 25, MemoryImage(typhoonistaLogo))
                      ],
                    ),
                  ),
                  Text(
                    "Typhoon Summary Report",
                    style: header2Style
                  ),
                  
                ],
              ),
            Divider(color: PdfColor.fromHex("#5A5A5A")),
            Container(
            width: double.maxFinite,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name of Typhoon",
                            style: titleStyle,
                          ),
                          Text(
                            "Typhoon ${typhoon!.typhoonName}",
                            style: valueStyle,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Typhoon Starting Date",
                            style: titleStyle
                          ),
                          Text(
                            "${DateTime.parse(typhoon!.startDate).month}/${DateTime.parse(typhoon!.startDate).day}/${DateTime.parse(typhoon!.startDate).year}",
                            style: valueStyle,
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
                            "Typhoon Ending Date",
                            style: titleStyle
                          ),
                          Text(
                            (typhoon!.endDate == "")
                                ? "Unknown"
                                : "${DateTime.parse(typhoon!.endDate).month}/${DateTime.parse(typhoon!.endDate).day}/${DateTime.parse(typhoon!.endDate).year}",
                            style: valueStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Typhoon Status",
                            style: titleStyle
                          ),
                          Text(
                            "${typhoon!.status}",
                            style: valueStyle,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Damage To Rice Crops",
                            style: titleStyle
                          ),
                          Text(
                            "${numberFormatter(number: typhoon!.totalDamageCost)} PHP",
                            style: TextStyle(font: latoBold),
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
                            style: titleStyle
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: locations!
                                .map((loc) => Bullet(text: "${loc.munName}",
                                    style: valueStyle
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
    print("YADA");
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
                style: titleStyle
              ),
              Text(
                "${location.munName}",
                style: valueStyle
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  child: TableHelper.fromTextArray(
                    headerStyle: TextStyle(font: latoReg),
                    cellStyle: TextStyle(font: latoReg),
                    border: TableBorder.all(color: PdfColor.fromHex("#d4d4d4"), width: 1, style:BorderStyle.solid),
                      headers: tableHeaders, data: tableRows[i])),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Spacer(),
                  Text(
                      "Total Damage Cost: ${numberFormatter(number: location.totalDamageCost)} PHP", style: TextStyle(font: latoBold))
                ],
              ),
            ],
          ),
        )
      ]));
    }

    final pdf = Document();
    print("DAMEE");
    pdf.addPage(MultiPage(
        margin: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
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
                Text('TYPHOONISTA  -  ${DateTime.now().year}', style: TextStyle(fontSize: 10, color: PdfColor.fromHex("#0090D9"), font: latoReg))
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
