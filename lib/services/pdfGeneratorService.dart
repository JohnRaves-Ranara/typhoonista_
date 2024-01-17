import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:convert';
import 'dart:html';

class pdfGeneratorService {
  Future<void> generateSamplePDF(String text) async {
    PdfDocument document = PdfDocument();

    document.pages.add().graphics.drawString(
        text, PdfStandardFont(PdfFontFamily.helvetica, 20),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(20, 60, 150, 30)); 

    List<int> bytes = await document.save();
    //Dispose the document
    document.dispose();

    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "output.pdf")
      ..click();
  }
}
