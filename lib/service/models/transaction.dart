import 'categorizer.dart';

class TaxBracket {
  final double upTo;
  final double rate;

  TaxBracket(this.upTo, this.rate);
}

// class TaxCalculator {
//   static const double taxRate = 0.075; // 7.5%
//
//   static double calculateTax(List<BankTransaction> txs) {
//     final taxable = txs
//         .where((t) => t.isDebit)
//         .fold<double>(0, (sum, t) => sum + t.amount);
//
//     return taxable * taxRate;
//   }
// }


class ProgressiveTaxCalculator {


  static final List<TaxBracket> brackets = [
    TaxBracket(300000, 0.07),
    TaxBracket(600000, 0.11),
    TaxBracket(1100000, 0.15),
    TaxBracket(double.infinity, 0.19),
  ];

  static double calculate(double income) {
    double tax = 0;
    double remaining = income;
    double lastLimit = 0;

    for (final bracket in brackets) {
      final taxable =
      (bracket.upTo - lastLimit).clamp(0, remaining);

      tax += taxable * bracket.rate;
      remaining -= taxable;
      lastLimit = bracket.upTo;

      if (remaining <= 0) break;
    }

    return tax;
  }
}



class MonthlyTaxReport {
  final String month;
  final double income;
  final double expenses;
  final double taxableIncome;
  final double tax;

  MonthlyTaxReport({
    required this.month,
    required this.income,
    required this.expenses,
    required this.taxableIncome,
    required this.tax,
  });
}




//
//
// List<MonthlyTaxReport> generateMonthlyReports(
//     List<BankTransaction> txs,
//     ) {
//   final Map<String, List<BankTransaction>> grouped = {};
//
//   for (final tx in txs) {
//     final key = "${tx.date.year}-${tx.date.month}";
//     grouped.putIfAbsent(key, () => []).add(tx);
//   }
//
//   return grouped.entries.map((e) {
//     final income = e.value
//         .where((t) => !t.isDebit)
//         .fold(0.0, (s, t) => s + t.amount);
//
//     final expenses = e.value
//         .where((t) => t.isDebit)
//         .fold(0.0, (s, t) => s + t.amount);
//
//     final taxable = income - expenses;
//     final tax = ProgressiveTaxCalculator.calculate(taxable);
//
//     return MonthlyTaxReport(
//       month: e.key,
//       income: income,
//       expenses: expenses,
//       taxableIncome: taxable,
//       tax: tax,
//     );
//   }).toList();
// }
//





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
