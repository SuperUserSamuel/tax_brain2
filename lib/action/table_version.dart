import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'get_taxes.dart';

/// ================= ENUMS & HELPERS =================

enum TransactionCategory { airtime, food, rent, transfer, income, other }

TransactionCategory classifyTransaction(String narration, String type) {
  final text = narration.toLowerCase();
  if (type == "credit") return TransactionCategory.income;
  if (text.contains("airtime")) return TransactionCategory.airtime;
  if (text.contains("food")) return TransactionCategory.food;
  if (text.contains("rent")) return TransactionCategory.rent;
  if (text.contains("transfer")) return TransactionCategory.transfer;
  return TransactionCategory.other;
}

bool isTaxEligible(TransactionCategory c) =>
    c == TransactionCategory.income;

String categoryLabel(TransactionCategory c) =>
    c.toString().split('.').last.toUpperCase();

double calculateTax(double income) {
  if (income <= 3000) return income * 0.07;
  if (income <= 10000) {
    return (3000 * 0.07) + ((income - 3000) * 0.11);
  }
  return (3000 * 0.07) +
      (7000 * 0.11) +
      ((income - 10000) * 0.18);
}

/// ================= MODEL =================

class BankTransaction {
  final String id;
  final String type;
  final double amount;
  final String narration;
  final DateTime date;
  final TransactionCategory category;

  BankTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.narration,
    required this.date,
    required this.category,
  });

  factory BankTransaction.fromJson(Map<String, dynamic> json) {
    return BankTransaction(
      id: json['id'],
      type: json['type'],
      amount: (json['amount'] as num).toDouble(),
      narration: json['narration'],
      date: DateTime.parse(json['date']),
      category:
      classifyTransaction(json['narration'], json['type']),
    );
  }
}

/// ================= MAIN PAGE =================

class SmartTransactionsTablePage extends StatefulWidget {
  const SmartTransactionsTablePage({super.key});

  @override
  State<SmartTransactionsTablePage> createState() =>
      _SmartTransactionsTablePageState();
}

class _SmartTransactionsTablePageState
    extends State<SmartTransactionsTablePage> {
  DateTimeRange? range;
  late List<BankTransaction> allTransactions;

  @override
  void initState() {
    super.initState();
    allTransactions =
        sampleApiResponse.map(BankTransaction.fromJson).toList();
  }

  List<BankTransaction> get filtered {
    if (range == null) return allTransactions;
    return allTransactions.where((tx) {
      return tx.date.isAfter(range!.start) &&
          tx.date.isBefore(range!.end);
    }).toList();
  }

  Map<String, List<BankTransaction>> groupByMonth(
      List<BankTransaction> txs) {
    final map = <String, List<BankTransaction>>{};
    for (final tx in txs) {
      final key = DateFormat('MMMM yyyy').format(tx.date);
      map.putIfAbsent(key, () => []).add(tx);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = groupByMonth(filtered);

    final credits =
    filtered.where((e) => e.type == "credit").toList();
    final debits =
    filtered.where((e) => e.type == "debit").toList();

    final income =
    credits.fold(0.0, (s, e) => s + e.amount);
    final taxableIncome = credits
        .where((e) => isTaxEligible(e.category))
        .fold(0.0, (s, e) => s + e.amount);
    final expenses =
    debits.fold(0.0, (s, e) => s + e.amount);
    final tax = calculateTax(taxableIncome);
    final net = income - tax;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text("Smart Transactions"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _summary(
            credits.length,
            debits.length,
            taxableIncome,
            tax,
            net,
          ),
          const SizedBox(height: 16),
          _dateFilter(),
          const SizedBox(height: 16),
          _chart(income, expenses, tax),
          const SizedBox(height: 24),
          ...grouped.entries.map(
                (e) => _monthTable(e.key, e.value),
          ),
        ],
      ),
    );
  }

  /// ================= SUMMARY =================

  Widget _summary(
      int creditCount,
      int debitCount,
      double taxable,
      double tax,
      double net,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Summary",
              style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _row("Credits", creditCount.toString()),
          _row("Debits", debitCount.toString()),
          _row("Taxable Income", "₦${taxable.toStringAsFixed(0)}"),
          _row("Estimated Tax", "₦${tax.toStringAsFixed(0)}"),
          const Divider(),
          _row("Net Income", "₦${net.toStringAsFixed(0)}",
              bold: true),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text("Export Summary to PDF"),
            onPressed: () => _exportPdf(
                creditCount, debitCount, taxable, tax, net),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value,
              style:
              TextStyle(fontWeight: bold ? FontWeight.bold : null)),
        ],
      ),
    );
  }

  /// ================= TABLE =================

  Widget _monthTable(
      String month, List<BankTransaction> txs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(month,
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12)),
          child: Table(
            border: TableBorder.all(color: Colors.grey.shade300),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(4),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(2),
            },
            children: [
              _headerRow(),
              ...txs.map(_dataRow),
            ],
          ),
        ),
      ],
    );
  }

  TableRow _headerRow() {
    return  TableRow(
      decoration: BoxDecoration(color: Color(0xFFF0F0F0)),
      children: [
        _cell("Date", bold: true),
        _cell("Narration", bold: true),
        _cell("Type", bold: true),
        _cell("Category", bold: true),
        _cell("Amount", bold: true),
      ],
    );
  }

  TableRow _dataRow(BankTransaction tx) {
    final isCredit = tx.type == "credit";
    return TableRow(
      children: [
        _cell(DateFormat.yMd().format(tx.date)),
        _cell(tx.narration),
        _cell(tx.type.toUpperCase(),
            color: isCredit ? Colors.green : Colors.red),
        _cell(categoryLabel(tx.category)),
        _cell(
          "${isCredit ? '+' : '-'}₦${tx.amount.toStringAsFixed(0)}",
          color: isCredit ? Colors.green : Colors.red,
        ),
      ],
    );
  }

  static Widget _cell(String text,
      {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 12,
            fontWeight: bold ? FontWeight.bold : null,
            color: color),
      ),
    );
  }

  /// ================= OTHER UI =================

  Widget _dateFilter() {
    return InkWell(
      onTap: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null) setState(() => range = picked);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.green.withOpacity(0.08),
        ),
        child: const Row(
          children: [
            Icon(Icons.calendar_month),
            SizedBox(width: 10),
            Text("Filter by date"),
            Spacer(),
            Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _chart(double income, double expense, double tax) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            barGroups: [
              BarChartGroupData(
                  x: 0, barRods: [BarChartRodData(toY: income)]),
              BarChartGroupData(
                  x: 1, barRods: [BarChartRodData(toY: expense)]),
              BarChartGroupData(
                  x: 2, barRods: [BarChartRodData(toY: tax)]),
            ],
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) =>
                      Text(["Income", "Expense", "Tax"][v.toInt()]),
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
          ),
        ),
      ),
    );
  }

  /// ================= PDF =================

  Future<void> _exportPdf(
      int credits,
      int debits,
      double taxable,
      double tax,
      double net,
      ) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Transaction Summary",
                style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 12),
            pw.Text("Credits: $credits"),
            pw.Text("Debits: $debits"),
            pw.Text("Taxable Income: ₦${taxable.toStringAsFixed(0)}"),
            pw.Text("Estimated Tax: ₦${tax.toStringAsFixed(0)}"),
            pw.Divider(),
            pw.Text("Net Income: ₦${net.toStringAsFixed(0)}",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (_) async => pdf.save());
  }
}


