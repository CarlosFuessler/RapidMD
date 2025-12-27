import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerPage extends StatelessWidget {
  final File file;

  const PdfViewerPage({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(file.path.split('/').last),
      ),
      body: PDFView(
        filePath: file.path,
      ),
    );
  }
}
