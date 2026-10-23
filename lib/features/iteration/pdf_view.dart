// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:finoco/core/shared/widgets/scaffold_header.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerPage extends StatelessWidget {
  final File pdf;
  final String name;
  final String url;
  final String imageUrl;
  const PDFViewerPage({Key key, this.pdf, this.name, this.url, this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldHeader(
      titleLineWidget: pdf == null
          ? null
          : IconButton(
              icon: const Icon(Icons.ios_share_outlined),
              onPressed: () {
                Share.shareFiles([pdf.path], mimeTypes: ['application/pdf']);
              }),
      title: name ?? '',
      child: pdf != null
          ? SfPdfViewer.file(pdf)
          : url != null
              ? SfPdfViewer.network(url)
              : imageUrl != null
                  ? Image.network(imageUrl)
                  : const SizedBox(),
    );
  }
}
