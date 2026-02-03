import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../service/models/income.dart';

class IncomeDashboardPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const IncomeDashboardPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final income = data['data'];
    final streams = (income['income_streams'] as List)
        .map((e) => IncomeStream.fromJson(e))
        .toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Income Insights'),
      ),
       body: ListView(
         padding: const EdgeInsets.all(16),
         children: [

           const SizedBox(height: 20),
           _overviewCards(income),
           const SizedBox(height: 20),
           // _cashflowChart(streams),
           // const SizedBox(height: 20),
           const Text(
             "Income Streams",
             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
           ),
           const SizedBox(height: 12),
           ...streams.map(_incomeStreamCard),

           monthlyTaxReport(double.parse(income['total_income'].toString())),
           const SizedBox(height: 20),
         incomeExpenseTaxChart(income: double.parse(income['total_income'].toString()), expenses: 9000.toDouble()),
           const SizedBox(height: 20),
         ],
       ),
     );
  }

  Widget _overviewCards(Map<String, dynamic> income) {
    Widget card(String title, num value, Color color) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: color)),
              const SizedBox(height: 6),
              Text(
                NumberFormat.currency(symbol: "₦").format(value),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        card("Monthly", income['monthly_income'], Colors.green),
        const SizedBox(width: 10),
        card("Annual", income['annual_income'], Colors.blue),
        const SizedBox(width: 10),
        card("Total", income['total_income'], Colors.orange),
      ],
    );
  }


  Widget _cashflowChart(List<IncomeStream> streams) {
    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Cashflow Overview",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BarChart(
              BarChartData(
                barGroups: streams
                    .asMap()
                    .entries
                    .map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.monthlyAverage,
                        borderRadius: BorderRadius.circular(6),
                      )
                    ],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        return Text(streams[value.toInt()].frequency);
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _incomeStreamCard(IncomeStream stream) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stream.type,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Chip(
                label: Text(stream.frequency),
              )
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Monthly Avg: ₦${stream.monthlyAverage.toStringAsFixed(0)}",
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: stream.stability,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation(
              stream.stability > 0.7 ? Colors.green : Colors.orange,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Stability ${(stream.stability * 100).toStringAsFixed(0)}%",
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            stream.lastDescription,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }


  Widget monthlyTaxReport(double income) {
    final tax = calculateTax(income);
    final net = income - tax;

    Widget row(String label, double value, {bool bold = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(fontWeight: bold ? FontWeight.bold : null)),
            Text("₦${value.toStringAsFixed(2)}",
                style: TextStyle(fontWeight: bold ? FontWeight.bold : null)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.green.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Monthly Tax Report",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          row("Gross Income", income),
          row("Estimated Tax", tax),
          const Divider(),
          row("Net Income", net, bold: true),
        ],
      ),
    );
  }


  Widget incomeExpenseTaxChart({
    required double income,
    required double expenses,
  }) {
    final tax = calculateTax(income);

    return Container(
      height: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.03),
      ),
      child: BarChart(
        BarChartData(
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(toY: income),
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(toY: expenses),
            ]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(toY: tax),
            ]),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text("Income");
                    case 1:
                      return const Text("Expenses");
                    case 2:
                      return const Text("Tax");
                    default:
                      return const SizedBox();
                  }
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }


  double calculateTax(double monthlyIncome) {
    double tax = 0;

    if (monthlyIncome <= 3000) {
      tax = monthlyIncome * 0.07;
    } else if (monthlyIncome <= 10000) {
      tax = (3000 * 0.07) + ((monthlyIncome - 3000) * 0.11);
    } else {
      tax = (3000 * 0.07) +
          (7000 * 0.11) +
          ((monthlyIncome - 10000) * 0.18);
    }

    return tax;
  }
}

