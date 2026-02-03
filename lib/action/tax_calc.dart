import 'package:flutter/material.dart';
import 'dart:math';

class AdvancedTaxCalculatorScreen extends StatefulWidget {
  const AdvancedTaxCalculatorScreen({super.key});

  @override
  State<AdvancedTaxCalculatorScreen> createState() =>
      _AdvancedTaxCalculatorScreenState();
}

class _AdvancedTaxCalculatorScreenState
    extends State<AdvancedTaxCalculatorScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _incomeController = TextEditingController();

  bool isYearly = true;
  double taxRate = 15;

  final List<_SavedCalculation> savedCalculations = [];

  double get income =>
      double.tryParse(_incomeController.text) ?? 0;

  double get adjustedIncome =>
      isYearly ? income : income * 12;

  double get taxAmount =>
      adjustedIncome * (taxRate / 100);

  double get netIncome =>
      adjustedIncome - taxAmount;

  void saveCalculation() {
    if (income == 0) return;

    setState(() {
      savedCalculations.insert(
        0,
        _SavedCalculation(
          income: adjustedIncome,
          taxRate: taxRate,
          tax: taxAmount,
          net: netIncome,
          date: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Tax Calculator",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const SizedBox(height: 10),
          Opacity(
              opacity: 0.6,
              child: Text('Manually calculate your taxes here in accorrdance with the new tax law formula', style: TextStyle(
                fontSize: 14
              ))),
          const SizedBox(height: 30),
          _incomeInput(),
          // const SizedBox(height: 20),
          // _periodToggle(),
          // const SizedBox(height: 20),
          // _taxSlider(),
          const SizedBox(height: 30),
          _animatedChart(),
          const SizedBox(height: 30),
          _summaryCard(),
          const SizedBox(height: 20),
          _saveButton(),
          if (savedCalculations.isNotEmpty) ...[
            const SizedBox(height: 30),
            _savedCalculations(),
          ]
        ],
      ),
    );
  }

  // 💰 Income Input
  Widget _incomeInput() {
    return TextField(
      controller: _incomeController,
      keyboardType: TextInputType.number,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        labelText: "Income",
        prefixText: "\₦ ",
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // 📅 Monthly / Yearly Toggle
  // Widget _periodToggle() {
  //   return Row(
  //     children: [
  //       _toggleButton("Monthly", !isYearly, () {
  //         setState(() => isYearly = false);
  //       }),
  //       const SizedBox(width: 12),
  //       _toggleButton("Yearly", isYearly, () {
  //         setState(() => isYearly = true);
  //       }),
  //     ],
  //   );
  // }

  Widget _toggleButton(
      String text, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.green.shade100 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? Colors.green.shade800 : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  // 🎚️ Tax Slider
  // Widget _taxSlider() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text("Tax Rate: ${taxRate.toStringAsFixed(0)}%",
  //           style: const TextStyle(fontWeight: FontWeight.w600)),
  //       Slider(
  //         value: taxRate,
  //         min: 0,
  //         max: 50,
  //         divisions: 50,
  //         activeColor: Colors.green,
  //         onChanged: (value) {
  //           setState(() => taxRate = value);
  //         },
  //       ),
  //     ],
  //   );
  // }

  // 📊 Animated Bar Chart
  Widget _animatedChart() {
    final maxValue = max(adjustedIncome, max(taxAmount, netIncome));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _chartBar("Income", adjustedIncome, maxValue, Colors.blue),
        _chartBar("Tax", taxAmount, maxValue, Colors.red),
        _chartBar("Net", netIncome, maxValue, Colors.green),
      ],
    );
  }

  Widget _chartBar(
      String label, double value, double max, Color color) {
    final height = max == 0 ? 0 : (value / max) * 140;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 30,
          height: height.ceilToDouble(),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  // 📊 Summary Card
  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F8F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _summaryRow("Tax Amount", taxAmount),
          const Divider(height: 24),
          _summaryRow("Net Income", netIncome, highlight: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double value,
      {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight:
                highlight ? FontWeight.bold : FontWeight.w500)),
        Text(
          "\₦${value.toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: highlight ? Colors.green.shade800 : Colors.black,
          ),
        ),
      ],
    );
  }

  // 💾 Save Button
  Widget _saveButton() {
    return
      SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: saveCalculation,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9FE870),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Use Smart Calculator',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );

  }

  // 📜 Saved Calculations
  Widget _savedCalculations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Saved Calculations",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...savedCalculations.map((e) => ListTile(
          title: Text(
              "\$${e.income.toStringAsFixed(0)} @ ${e.taxRate}%"),
          subtitle:
          Text("Tax: \$${e.tax.toStringAsFixed(2)}"),
          trailing:
          Text("\$${e.net.toStringAsFixed(2)}"),
        )),
      ],
    );
  }
}

// 🧾 Model
class _SavedCalculation {
  final double income;
  final double taxRate;
  final double tax;
  final double net;
  final DateTime date;

  _SavedCalculation({
    required this.income,
    required this.taxRate,
    required this.tax,
    required this.net,
    required this.date,
  });
}
