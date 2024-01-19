import 'dart:convert';
import 'dart:ui';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:html' as html;

class pdfGeneratorService {
  Future<void> generateSamplePDF(String text) async {

    final pdf = Document();

    // pdf.addPage(
    //   MultiPage(
    //     pageFormat: PdfPageFormat.a4,
    //     build: (context){
    //       return z;
    //     }
    //   )
    // );
    pdf.addPage(Page(
        margin: EdgeInsets.all(10),
        pageFormat: PdfPageFormat.a4,
        build: (Context context) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: 300,
                  child: Center(child: Text("SAMPLE TEXT")),
                  decoration: BoxDecoration(
                    
                    color: PdfColor(0, 1, 0,0),
                    borderRadius: BorderRadius.circular(15)
                  )
                ),
                Container(
                  height: 200,
                  width: 300,
                  child: Center(child: Text("SAMPLE TEXT 2")),
                  decoration: BoxDecoration(
                    color: PdfColor(1,0, 0,0),
                    borderRadius: BorderRadius.circular(15)
                  )
                )
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
