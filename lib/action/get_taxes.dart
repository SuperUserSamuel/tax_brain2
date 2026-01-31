import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../service/models/transaction.dart';


/// ================= ENUMS & HELPERS =================

enum TransactionCategory {
  airtime,
  food,
  rent,
  transfer,
  income,
  other,
}

TransactionCategory classifyTransaction(String narration, String type) {
  final text = narration.toLowerCase();

  if (type == "credit") return TransactionCategory.income;
  if (text.contains("airtime")) return TransactionCategory.airtime;
  if (text.contains("food") || text.contains("restaurant")) {
    return TransactionCategory.food;
  }
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

class SmartTransactionsPage extends StatefulWidget {
  const SmartTransactionsPage({super.key});

  @override
  State<SmartTransactionsPage> createState() =>
      _SmartTransactionsPageState();
}

class _SmartTransactionsPageState
    extends State<SmartTransactionsPage> {
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

    final totalIncome =
    credits.fold(0.0, (s, e) => s + e.amount);
    final totalExpense =
    debits.fold(0.0, (s, e) => s + e.amount);
    final taxableIncome = credits
        .where((e) => isTaxEligible(e.category))
        .fold(0.0, (s, e) => s + e.amount);

    final tax = calculateTax(taxableIncome);
    final net = totalIncome - tax;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text("Smart Transactions"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _summarySection(
            credits.length,
            debits.length,
            taxableIncome,
            tax,
            net,
          ),
          const SizedBox(height: 16),
          _dateFilter(),
          const SizedBox(height: 16),
          _chart(totalIncome, totalExpense, tax),
          const SizedBox(height: 24),
          ...grouped.entries.map(
                (e) => _monthSection(e.key, e.value),
          ),
        ],
      ),
    );
  }

  /// ================= SUMMARY =================

  Widget _summarySection(
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
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Summary",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _summaryRow("Credits", creditCount.toString()),
          _summaryRow("Debits", debitCount.toString()),
          _summaryRow(
              "Taxable Income", "₦${taxable.toStringAsFixed(0)}"),
          _summaryRow(
              "Estimated Tax", "₦${tax.toStringAsFixed(0)}"),
          const Divider(),
          _summaryRow("Net Income",
              "₦${net.toStringAsFixed(0)}",
              bold: true),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () => _exportPdf(
                creditCount, debitCount, taxable, tax, net),
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text("Export Summary to PDF"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          )
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value,
      {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style:
            TextStyle(fontWeight: bold ? FontWeight.bold : null),
          ),
        ],
      ),
    );
  }

  /// ================= PDF EXPORT =================

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
            pw.SizedBox(height: 16),
            pw.Text("Credits: $credits"),
            pw.Text("Debits: $debits"),
            pw.Text("Taxable Income: ₦${taxable.toStringAsFixed(0)}"),
            pw.Text("Estimated Tax: ₦${tax.toStringAsFixed(0)}"),
            pw.Divider(),
            pw.Text("Net Income: ₦${net.toStringAsFixed(0)}",
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) async => pdf.save(),
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
        child: Row(
          children: const [
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
        height: 240,
        child: BarChart(
          BarChartData(
            barGroups: [
              BarChartGroupData(
                  x: 0,
                  barRods: [BarChartRodData(toY: income)]),
              BarChartGroupData(
                  x: 1,
                  barRods: [BarChartRodData(toY: expense)]),
              BarChartGroupData(
                  x: 2,
                  barRods: [BarChartRodData(toY: tax)]),
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

  Widget _monthSection(
      String month, List<BankTransaction> txs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(month,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ),
        ...txs.map(_transactionTile),
      ],
    );
  }

  Widget _transactionTile(BankTransaction tx) {
    final isCredit = tx.type == "credit";
    final color = isCredit ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(
                isCredit
                    ? Icons.arrow_downward
                    : Icons.arrow_upward,
                color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.narration,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: [
                    _tag(categoryLabel(tx.category)),
                    if (isTaxEligible(tx.category))
                      _tag("TAXABLE",
                          color: Colors.orange),
                  ],
                ),
              ],
            ),
          ),
          Text(
            "${isCredit ? '+' : '-'}₦${tx.amount.toStringAsFixed(0)}",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _tag(String label, {Color color = Colors.black}) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10)),
      child: Text(label,
          style: TextStyle(fontSize: 11, color: color)),
    );
  }
}

/// ================= SAMPLE API DATA =================

final sampleApiResponse =
[
  {
    "id": "664f080293b88c7cb32d227f",
    "type": "debit",
    "amount": 20000,
    "narration": "Airtime ALAT MTN",
    "date": "2024-05-23T09:43:32.267Z"
  },
  {
    "id": "664f080293b88c7cb32d2280",
    "type": "credit",
    "amount": 20000,
    "narration": "ALAT NIP TRANSFER TO GLOBUS BANK",
    "date": "2024-05-14T12:07:45.767Z"
  },
  {
    "id": "664f080293b88c7cb32d2281",
    "type": "debit",
    "amount": 5500,
    "narration": "Netflix Subscription Payment",
    "date": "2024-05-24T10:15:20.123Z"
  },
  {
    "id": "664f080293b88c7cb32d2282",
    "type": "credit",
    "amount": 150000,
    "narration": "Salary Payment - Tech Solutions Ltd",
    "date": "2024-05-25T08:00:00.000Z"
  },
  {
    "id": "664f080293b88c7cb32d2283",
    "type": "debit",
    "amount": 1200,
    "narration": "Transfer Fee - NIP",
    "date": "2024-05-25T08:05:12.441Z"
  },
  {
    "id": "664f080293b88c7cb32d2284",
    "type": "debit",
    "amount": 45000,
    "narration": "Rent Contribution - Room 302",
    "date": "2024-05-26T14:22:10.882Z"
  },
  {
    "id": "664f080293b88c7cb32d2285",
    "type": "credit",
    "amount": 12500,
    "narration": "POS Cash Back Reward",
    "date": "2024-05-27T11:30:45.912Z"
  },
  {
    "id": "664f080293b88c7cb32d2286",
    "type": "debit",
    "amount": 8500,
    "narration": "DSTV Compact Payment",
    "date": "2024-05-28T09:12:33.111Z"
  },
  {
    "id": "664f080293b88c7cb32d2287",
    "type": "debit",
    "amount": 3200,
    "narration": "Bolt Ride - Victoria Island",
    "date": "2024-05-28T18:45:19.267Z"
  },
  {
    "id": "664f080293b88c7cb32d2288",
    "type": "credit",
    "amount": 5000,
    "narration": "Refund - Jumia Order #9912",
    "date": "2024-05-29T13:10:05.551Z"
  },
  {
    "id": "664f080293b88c7cb32d2289",
    "type": "debit",
    "amount": 15000,
    "narration": "Eko Electricity - Prepaid Meter",
    "date": "2024-05-30T07:55:40.333Z"
  },
  {
    "id": "664f080293b88c7cb32d2290",
    "type": "debit",
    "amount": 2500,
    "narration": "Data Bundle Purchase - GLO",
    "date": "2024-05-31T20:18:12.000Z"
  },
  {
    "id": "664f080293b88c7cb32d2291",
    "type": "credit",
    "amount": 10000,
    "narration": "Transfer from Mom",
    "date": "2024-06-01T09:00:22.467Z"
  },
  {
    "id": "664f080293b88c7cb32d2292",
    "type": "debit",
    "amount": 7200,
    "narration": "Grocery Shopping - Shoprite",
    "date": "2024-06-02T16:34:55.121Z"
  },
  {
    "id": "664f080293b88c7cb32d2293",
    "type": "debit",
    "amount": 50000,
    "narration": "Fixed Deposit Investment",
    "date": "2024-06-03T10:05:00.000Z"
  },
  {
    "id": "664f080293b88c7cb32d2294",
    "type": "credit",
    "amount": 3500,
    "narration": "Inter-account Interest Accrual",
    "date": "2024-06-03T23:59:59.999Z"
  },
  {
    "id": "664f080293b88c7cb32d2295",
    "type": "debit",
    "amount": 18000,
    "narration": "Gym Monthly Membership",
    "date": "2024-06-04T06:30:15.267Z"
  },
  {
    "id": "664f080293b88c7cb32d2296",
    "type": "debit",
    "amount": 4000,
    "narration": "Cinema Tickets - Filmhouse",
    "date": "2024-06-04T19:20:00.881Z"
  },
  {
    "id": "664f080293b88c7cb32d2297",
    "type": "credit",
    "amount": 60000,
    "narration": "Consultancy Fee - Freelance Project",
    "date": "2024-06-05T12:00:33.412Z"
  },
  {
    "id": "664f080293b88c7cb32d2298",
    "type": "debit",
    "amount": 1500,
    "narration": "Maintenance Charge - Account SMS",
    "date": "2024-06-05T14:45:00.000Z"
  },
  {
    "id": "664f080293b88c7cb32d2299",
    "type": "debit",
    "amount": 22000,
    "narration": "Fuel Purchase - TotalEnergies",
    "date": "2024-06-06T08:15:22.333Z"
  },
  {
    "id": "664f080293b88c7cb32d2300",
    "type": "credit",
    "amount": 25000,
    "narration": "Birthday Gift - Uncle Sam",
    "date": "2024-06-07T10:30:00.777Z"
  }
];





class MonthlyTaxReportScreen extends StatelessWidget {
  final List<MonthlyTaxReport> reports;

  const MonthlyTaxReportScreen({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monthly Tax Report")),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: reports.length,
        itemBuilder: (_, i) {
          final r = reports[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F8F5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.month,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Income: ₦${r.income.toStringAsFixed(2)}"),
                Text("Expenses: ₦${r.expenses.toStringAsFixed(2)}"),
                Text(
                  "Tax: ₦${r.tax.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
