import 'package:flutter/material.dart';
import '/pdf_reader.dart';

void main() {
  runApp(PdfViewerApp());
}

class PdfViewerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Viewer',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: PdfViewerScreen(),
    );
  }
}
