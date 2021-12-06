import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class PdfViewerPage extends StatefulWidget {
  final String path;
  final pw.Document pdf;
  const PdfViewerPage({required  this.path, required this.pdf});

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.print),
            iconSize: 30.0,
            onPressed: () async {
              await Printing.layoutPdf(
                  onLayout: (PdfPageFormat format) async => widget.pdf.save());
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            autoSpacing: true,
            enableSwipe: true,
            pageSnap: true,
            swipeHorizontal: true,
            onError: (e) {
              print(e);
            },
            onRender: (_pages) {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
