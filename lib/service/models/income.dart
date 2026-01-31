class IncomeStream {
  final String type;
  final String frequency;
  final double monthlyAverage;
  final double stability;
  final String lastDescription;

  IncomeStream({
    required this.type,
    required this.frequency,
    required this.monthlyAverage,
    required this.stability,
    required this.lastDescription,
  });

  factory IncomeStream.fromJson(Map<String, dynamic> json) {
    return IncomeStream(
      type: json['income_type'],
      frequency: json['frequency'],
      monthlyAverage: (json['monthly_average'] ?? 0).toDouble(),
      stability: (json['stability'] ?? 0).toDouble(),
      lastDescription: json['last_income_description'] ?? '',
    );
  }
}


enum IncomeCategory { salary, freelance, business }

IncomeCategory detectIncomeCategory(String frequency, String description) {
  final desc = description.toLowerCase();

  if (frequency == "MONTHLY" && desc.contains("salary")) {
    return IncomeCategory.salary;
  }

  if (desc.contains("transfer") || desc.contains("freelance")) {
    return IncomeCategory.freelance;
  }

  return IncomeCategory.business;
}



String categoryLabel(IncomeCategory c) {
  switch (c) {
    case IncomeCategory.salary:
      return "Salary";
    case IncomeCategory.freelance:
      return "Freelance";
    case IncomeCategory.business:
      return "Business";
  }
}


class Expense {
  final String category;
  final double amount;

  Expense(this.category, this.amount);
}