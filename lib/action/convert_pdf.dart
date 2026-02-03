import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../service/models/transaction.dart';

class TransactionPdfGenerator {
  /// Generate and export PDF with transactions and summary
  static Future<void> generateTransactionsPdf({
    required Map<String, List<BankTransaction>> groupedTransactions,
    required int creditCount,
    required int debitCount,
    required double taxableIncome,
    required double tax,
    required double netIncome,
    required Set<String> taxableTransactionIds,
    DateTimeRange? dateRange,
  }) async {
    final pdf = pw.Document();

    // Add cover page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => _buildCoverPage(dateRange),
      ),
    );

    // Add summary page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => _buildSummaryPage(
          creditCount,
          debitCount,
          taxableIncome,
          tax,
          netIncome,
          taxableTransactionIds.length,
          dateRange,
        ),
      ),
    );

    // Add transaction tables for each month
    for (final entry in groupedTransactions.entries) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => [
            _buildMonthHeader(entry.key, entry.value.length),
            pw.SizedBox(height: 20),
            _buildTransactionTable(entry.value, taxableTransactionIds),
          ],
        ),
      );
    }

    // Preview and print or save
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'transaction_report_${DateFormat('yyyy-MM-dd').format(DateTime.now())}.pdf',
    );
  }

  /// Build cover page
  static pw.Widget _buildCoverPage(DateTimeRange? dateRange) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        gradient: pw.LinearGradient(
          colors: [
            PdfColor.fromHex('#4CAF50'),
            PdfColor.fromHex('#2E7D32'),
          ],
          begin: pw.Alignment.topLeft,
          end: pw.Alignment.bottomRight,
        ),
      ),
      child: pw.Center(
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(
              'Transaction Report',
              style: pw.TextStyle(
                fontSize: 48,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Smart Tax Breakdown',
              style: pw.TextStyle(
                fontSize: 24,
                color: PdfColors.white,
              ),
            ),
            pw.SizedBox(height: 40),
            if (dateRange != null) ...[
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(
                  '${DateFormat('MMM dd, yyyy').format(dateRange.start)} - ${DateFormat('MMM dd, yyyy').format(dateRange.end)}',
                  style: pw.TextStyle(
                    fontSize: 20,
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ] else ...[
              pw.Text(
                'All Transactions',
                style: pw.TextStyle(
                  fontSize: 20,
                  color: PdfColors.white,
                ),
              ),
            ],
            pw.Spacer(),
            pw.Text(
              'Generated on ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}',
              style: pw.TextStyle(
                fontSize: 14,
                color: PdfColors.white,
              ),
            ),
            pw.SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Build summary page
  static pw.Widget _buildSummaryPage(
      int creditCount,
      int debitCount,
      double taxableIncome,
      double tax,
      double netIncome,
      int taxableCount,
      DateTimeRange? dateRange,
      ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(40),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header
          pw.Text(
            'Financial Summary',
            style: pw.TextStyle(
              fontSize: 32,
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromHex('#2E7D32'),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Divider(thickness: 2, color: PdfColor.fromHex('#4CAF50')),
          pw.SizedBox(height: 30),

          // Date Range
          if (dateRange != null) ...[
            _buildInfoRow(
              'Period',
              '${DateFormat('MMM dd, yyyy').format(dateRange.start)} - ${DateFormat('MMM dd, yyyy').format(dateRange.end)}',
              isHighlight: true,
            ),
            pw.SizedBox(height: 20),
          ],

          // Transaction Counts
          pw.Text(
            'Transaction Overview',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow('Total Credits', creditCount.toString()),
          _buildInfoRow('Total Debits', debitCount.toString()),
          _buildInfoRow('Taxable Transactions', taxableCount.toString()),
          pw.SizedBox(height: 30),

          // Financial Summary
          pw.Text(
            'Financial Breakdown',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow(
            'Taxable Income',
            '₦${_formatAmount(taxableIncome)}',
            color: PdfColor.fromHex('#4CAF50'),
          ),
          _buildInfoRow(
            'Estimated Tax',
            '₦${_formatAmount(tax)}',
            color: PdfColor.fromHex('#F44336'),
          ),
          pw.Divider(thickness: 1.5),
          _buildInfoRow(
            'Net Income',
            '₦${_formatAmount(netIncome)}',
            isHighlight: true,
            color: PdfColor.fromHex('#2E7D32'),
          ),
          pw.Spacer(),

          // Footer note
          pw.Container(
            padding: const pw.EdgeInsets.all(15),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#FFF9C4'),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              children: [
                pw.Icon(
                  pw.IconData(0xe88e), // info icon
                  size: 20,
                  color: PdfColor.fromHex('#F57F17'),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Text(
                    'This is an automated report. Tax calculations are estimates and should be verified with a tax professional.',
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColor.fromHex('#F57F17'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build month header
  static pw.Widget _buildMonthHeader(String month, int transactionCount) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          month,
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromHex('#2E7D32'),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: pw.BoxDecoration(
            color: PdfColor.fromHex('#E8F5E9'),
            borderRadius: pw.BorderRadius.circular(20),
          ),
          child: pw.Text(
            '$transactionCount transaction${transactionCount != 1 ? 's' : ''}',
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColor.fromHex('#2E7D32'),
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Build transaction table
  static pw.Widget _buildTransactionTable(
      List<BankTransaction> transactions,
      Set<String> taxableTransactionIds,
      ) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FixedColumnWidth(60),  // Taxable
        1: const pw.FixedColumnWidth(80),  // Date
        2: const pw.FlexColumnWidth(3),    // Narration
        3: const pw.FixedColumnWidth(60),  // Type
        4: const pw.FixedColumnWidth(100), // Category
        5: const pw.FixedColumnWidth(90),  // Amount
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: pw.BoxDecoration(
            color: PdfColor.fromHex('#F0F0F0'),
          ),
          children: [
            _buildTableHeader('Taxable'),
            _buildTableHeader('Date'),
            _buildTableHeader('Narration'),
            _buildTableHeader('Type'),
            _buildTableHeader('Category'),
            _buildTableHeader('Amount'),
          ],
        ),
        // Data rows
        ...transactions.map((tx) => _buildTableRow(tx, taxableTransactionIds)),
      ],
    );
  }

  /// Build table header cell
  static pw.Widget _buildTableHeader(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  /// Build table data row
  static pw.TableRow _buildTableRow(
      BankTransaction tx,
      Set<String> taxableTransactionIds,
      ) {
    final isCredit = tx.type == 'credit';
    final isTaxable = taxableTransactionIds.contains(tx.id);
    final color = isCredit ? PdfColor.fromHex('#4CAF50') : PdfColor.fromHex('#F44336');

    return pw.TableRow(
      decoration: pw.BoxDecoration(
        color: isTaxable
            ? PdfColor.fromHex('#E8F5E9')
            : null,
      ),
      children: [
        _buildTableCell(
          isCredit
              ? (isTaxable ? '✓' : '○')
              : '-',
          align: pw.TextAlign.center,
        ),
        _buildTableCell(DateFormat.yMd().format(tx.date)),
        _buildTableCell(tx.narration),
        _buildTableCell(
          tx.type.toUpperCase(),
          color: color,
          fontWeight: pw.FontWeight.bold,
        ),
        _buildTableCell(categoryLabel(tx.category.name)),
        _buildTableCell(
          '${isCredit ? '+' : '-'}₦${_formatAmount(tx.amount)}',
          color: color,
          fontWeight: pw.FontWeight.bold,
          align: pw.TextAlign.right,
        ),
      ],
    );
  }

  /// Build table cell
  static pw.Widget _buildTableCell(
      String text, {
        PdfColor? color,
        pw.FontWeight? fontWeight,
        pw.TextAlign align = pw.TextAlign.left,
      }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          color: color,
          fontWeight: fontWeight,
        ),
        textAlign: align,
      ),
    );
  }

  /// Build info row for summary
  static pw.Widget _buildInfoRow(
      String label,
      String value, {
        bool isHighlight = false,
        PdfColor? color,
      }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: isHighlight ? 18 : 14,
              fontWeight: isHighlight ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: isHighlight ? 18 : 14,
              fontWeight: isHighlight ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Format amount with thousand separators
  static String _formatAmount(double amount) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return formatter.format(amount);
  }
}


String categoryLabel(String category) => category;