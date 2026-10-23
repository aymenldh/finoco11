import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:finoco/core/models/client.dart';
import 'package:finoco/core/models/dossier.dart';
import 'package:finoco/core/models/iteration.dart';
import 'package:finoco/core/models/type_transaction.dart';
import 'package:finoco/core/repository/dbhelper.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'export_event.dart';
import 'export_state.dart';

class ExportBloc extends Bloc<ExportEvent, ExportState> {
  ExportBloc() : super(ExportsLoading()) {
    on<ExportDossier>(_onExportDossier);
  }

  Future<void> _onExportDossier(
      ExportDossier event, Emitter<ExportState> emit) async {
    emit(ExportsLoading());

    try {
      // Fetch data
      final Dossier dossier =
          await DatabaseHelper.instance.getDossierByID(event.idFolder);
      final Client client =
          await DatabaseHelper.instance.getClientByID(dossier.idClient!);
      final services =
          await _fetchIterations(event.idFolder, TypeTransaction.SERVICE.name);
      final paiements =
          await _fetchIterations(event.idFolder, TypeTransaction.PAIEMENT.name);

      // Calculate totals
      // final double totalServiceAmount = _calculateTotal(services);
      // final double totalPaymentAmount = _calculateTotal(paiements);

      emit(ExportsLoaded(await generatePdf(
          services, paiements, client.fullName, client.phone!, dossier.devise!)));
    } catch (error) {
      emit(ExportsError());
    }
  }

  Future<File> saveUint8ListToFile(Uint8List data, String fileName) async {
    // Get the directory to save the file
    final directory = await getApplicationDocumentsDirectory();

    // Define the full file path
    final filePath = '${directory.path}/$fileName';

    // Create the file and write the data
    final file = File(filePath);
    await file.writeAsBytes(data);

    return file;
  }

  Future<List<Iteration>> _fetchIterations(int folderId, String type) async {
    return await DatabaseHelper.instance
        .listIterationsByDossierAndType(folderId, type);
  }

  double _calculateTotal(List<Iteration> iterations) {
    return iterations.fold(
        0.0, (sum, iteration) => sum + iteration.amountDevise!);
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  Future<File> generatePdf(List<Iteration> services, List<Iteration> payments,
      String nom, String phone, String devise) async {
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final PdfGrid grid = PdfGrid();

    ByteData byteData =
        await rootBundle.load('assets/poppins/Amiri-Regular.ttf');
    final Uint8List fontData = byteData.buffer.asUint8List();
    final PdfFont customFont = PdfTrueTypeFont(fontData, 13);

    ByteData byteDataBold =
        await rootBundle.load('assets/poppins/Amiri-Bold.ttf');
    final Uint8List fontDataBold = byteDataBold.buffer.asUint8List();
    final PdfFont customFontBold = PdfTrueTypeFont(fontDataBold, 16);
    final PdfFont customFontBold14 = PdfTrueTypeFont(fontDataBold, 14);

    grid.columns.add(count: 6);
    grid.style = PdfGridStyle(font: customFont);

    PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = nom;
    headerRow.cells[3].value = '';
    headerRow.cells[0].style = PdfGridCellStyle(
      borders: PdfBorders(
          left: PdfPens.transparent,
          top: PdfPens.transparent,
          bottom: PdfPens.transparent,
          right: PdfPens.transparent),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.left,
          textDirection: PdfTextDirection.rightToLeft),
    );
    headerRow.cells[0].columnSpan = 3;

    headerRow.cells[3].columnSpan = 3;
    headerRow.cells[3].style = PdfGridCellStyle(
      borders: PdfBorders(
          left: PdfPens.transparent,
          top: PdfPens.transparent,
          bottom: PdfPens.transparent,
          right: PdfPens.transparent),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: PdfTextDirection.rightToLeft),
    );

    headerRow = grid.headers.add(1)[1];
    headerRow.cells[0].style = PdfGridCellStyle(
      borders: PdfBorders(
          left: PdfPens.transparent,
          top: PdfPens.transparent,
          right: PdfPens.transparent),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.left,
          textDirection: PdfTextDirection.rightToLeft),
    );
    headerRow.cells[0].columnSpan = 3;
    headerRow.cells[3].columnSpan = 3;
    headerRow.cells[0].value = phone ?? '';
    headerRow.cells[3].value = 'Devise : ' + devise;
    headerRow.cells[3].style = PdfGridCellStyle(
      borders: PdfBorders(
          left: PdfPens.transparent,
          top: PdfPens.transparent,
          right: PdfPens.transparent),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.right,
          textDirection: PdfTextDirection.rightToLeft),
    );

    headerRow = grid.headers.add(1)[2];
    headerRow.cells[0].value = 'Services عليه';
    headerRow.cells[3].value = 'Paiements له';
    headerRow.cells[0].style = PdfGridCellStyle(
      font: customFontBold,
      borders:
          PdfBorders(right: PdfPen(PdfColor.fromCMYK(0, 0, 0, 200), width: 3)),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: PdfTextDirection.rightToLeft),
    );
    headerRow.cells[3].style = PdfGridCellStyle(
      font: customFontBold,
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: PdfTextDirection.rightToLeft),
    );
    headerRow.cells[0].columnSpan = 3;
    headerRow.cells[3].columnSpan = 3;

    double totalePaie = _calculateTotal(payments);
    double totaleServ = _calculateTotal(services);

// Add rows to the grid.
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = 'Date';
    row.cells[1].value = 'Titre';
    row.cells[2].value = 'Montant';
    row.cells[3].value = 'Date';
    row.cells[4].value = 'Titre';
    row.cells[5].value = 'Montant';
    row.cells[0].style.font = customFontBold14;
    row.cells[1].style.font = customFontBold14;
    row.cells[3].style.font = customFontBold14;
    row.cells[4].style.font = customFontBold14;
    row.cells[5].style.font = customFontBold14;
    row.cells[2].style = PdfGridCellStyle(
        font: customFontBold14,
        borders: PdfBorders(
            right: PdfPen(PdfColor.fromCMYK(0, 0, 0, 200), width: 3)));

    for (int i = 0; i <= max(payments.length, services.length); i++) {
      PdfGridRow row = grid.rows.add();

      if (i < services.length) {
        row.cells[0].value = _formatDate(services.elementAt(i).createdAt!);
        row.cells[1].value = services.elementAt(i).name;
        row.cells[1].style.stringFormat = PdfStringFormat(
            alignment: PdfTextAlignment.center,
            textDirection: PdfTextDirection.rightToLeft);
        row.cells[2].value =
            services.elementAt(i).amountDevise!.toStringAsFixed(0);
        row.cells[2].style.borders = PdfBorders(
            right: PdfPen(PdfColor.fromCMYK(0, 0, 0, 200), width: 3));
      } else if (i == services.length) {
        row.cells[0].style.borders = PdfBorders(left: PdfPens.transparent);
        row.cells[0].columnSpan = 2;
        row.cells[0].value = 'Totale services : ';
        row.cells[0].style.borders = PdfBorders(
          bottom: PdfPen(PdfColor.fromCMYK(0, 0, 0, 200), width: 2),
        );
        row.cells[0].style.font = PdfStandardFont(PdfFontFamily.timesRoman, 14,
            style: PdfFontStyle.bold);

        row.cells[2].style.borders = PdfBorders(
            bottom: PdfPen(PdfColor.fromCMYK(0, 0, 0, 200), width: 2),
            right: PdfPen(PdfColor.fromCMYK(0, 0, 0, 200), width: 3));

        row.cells[2].style.font = PdfStandardFont(PdfFontFamily.timesRoman, 13,
            style: PdfFontStyle.bold);
        row.cells[2].style.textBrush = PdfSolidBrush(PdfColor(76, 175, 80));
        row.cells[2].value = totaleServ.toStringAsFixed(0) + ' ' + devise;
      } else {
        row.cells[0].columnSpan = 3;
        row.cells[0].style.borders = PdfBorders(
            bottom: PdfPens.transparent,
            top: PdfPens.transparent,
            left: PdfPens.transparent,
            right: PdfPen(PdfColor.fromCMYK(0, 0, 0, 200), width: 3));
      }
      if (i < payments.length) {
        row.cells[3].value = _formatDate(payments.elementAt(i).createdAt!);
        row.cells[4].value = payments.elementAt(i).name;
        row.cells[4].style.stringFormat = PdfStringFormat(
            alignment: PdfTextAlignment.center,
            textDirection: PdfTextDirection.rightToLeft);
        row.cells[5].value =
            payments.elementAt(i).amountDevise!.toStringAsFixed(0);
      } else if (i == payments.length) {
        // row.cells[3].style = PdfGridCellStyle(
        //   borders: PdfBorders(bottom: PdfPens.transparent),
        // );
        row.cells[3].columnSpan = 2;
        row.cells[3].value = 'Totale paiements : ';
        row.cells[3].style.borders = PdfBorders(
            bottom: PdfPen(PdfColor.fromCMYK(0, 0, 0, 200), width: 2));
        row.cells[3].style.font = PdfStandardFont(PdfFontFamily.timesRoman, 14,
            style: PdfFontStyle.bold);

        row.cells[5].value = totalePaie.toStringAsFixed(0) + ' ' + devise;
        row.cells[5].style.borders = PdfBorders(
            bottom: PdfPen(PdfColor.fromCMYK(0, 0, 0, 200), width: 2));
        row.cells[5].style.font = PdfStandardFont(PdfFontFamily.timesRoman, 13,
            style: PdfFontStyle.bold);
        row.cells[5].style.textBrush = PdfSolidBrush(PdfColor(255, 0, 0));
      } else {
        row.cells[3].columnSpan = 3;
        row.cells[3].style.borders = PdfBorders(
            bottom: PdfPens.transparent,
            top: PdfPens.transparent,
            right: PdfPens.transparent);
      }
    }
    double totale = totaleServ - totalePaie;
    row = grid.rows.add();
    row.cells[0].value = 'Totale : ';
    row.cells[0].style.font =
        PdfStandardFont(PdfFontFamily.timesRoman, 16, style: PdfFontStyle.bold);
    row.cells[0].style.borders = PdfBorders(right: PdfPens.transparent);
    row.cells[1].value = totale.toStringAsFixed(0) + ' ' + devise;
    row.cells[1].columnSpan = 5;
    row.cells[1].style = PdfGridCellStyle(
        borders: PdfBorders(left: PdfPens.transparent),
        format: PdfStringFormat(characterSpacing: 1.5),
        textBrush:
            totale.isNegative ? PdfSolidBrush(PdfColor(255, 0, 0)) : null,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 16,
            style: PdfFontStyle.bold));

// Set grid format.
    grid.style.cellPadding = PdfPaddings(left: 5, top: 5);
// Draw table in the PDF page.
    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, 0, page.getClientSize().width, page.getClientSize().height));
// Save the document.
    final List<int> bytes = document.save();
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.pdf';
    final File file = File(filePath);
    await file.writeAsBytes(bytes);
// Dispose the document.
    document.dispose();
    return file;
  }
}
