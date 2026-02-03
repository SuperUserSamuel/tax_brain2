import '../../action/get_taxes.dart';

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

String categoryLabelForTransact(TransactionCategory c) =>
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



