import 'package:pdf/widgets.dart' as pw;

import '../service/models/transaction.dart';

Future<pw.Document> buildTaxPdf(
    List<MonthlyTaxReport> reports,
    ) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Text(
          "Annual Tax Report",
          style: pw.TextStyle(
            fontSize: 22,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 20),
        ...reports.map((r) => pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 12),
          child: pw.Text(
            "${r.month} - Tax: ₦${r.tax.toStringAsFixed(2)}",
          ),
        )),
      ],
    ),
  );

  return pdf;
}