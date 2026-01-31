

import 'package:flutter/material.dart';
import 'package:tax_calculator/home/profile.dart';
import 'package:tax_calculator/home/transaction.dart';

import '../action/connect_users.dart';
import '../action/get_taxes.dart';
import '../action/table_version.dart';
import '../action/tax_calc.dart';
import '../utils/navigate.dart';
import 'income_report.dart';


class WiseAppShell extends StatefulWidget {
  const WiseAppShell({super.key});

  @override
  State<WiseAppShell> createState() => _WiseAppShellState();
}

class _WiseAppShellState extends State<WiseAppShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    WiseAccountScreen(),
    AdvancedTaxCalculatorScreen(),
    IncomeDashboardPage(data: {
      "event": "mono.events.account_income",
      "data": {
        "account": "682dd53b74682beb490a0ed6",
        "app": "62da7b4b342c3aab5dd2a2c4",
        "business": "60cc8fa5ba177218c5c6a11d",
        "account_name": "JOHN DOE",
        "account_number": "2000000041",
        "income_summary": {
          "total_income": 0,
          "employer": ""
        },
        "income_streams": [
          {
            "income_type": "WAGES",
            "frequency": "VARIABLE",
            "monthly_average": 10300,
            "average_income_amount": 3166,
            "currency": "",
            "stability": 0.32,
            "first_income_date": "2025-05-03",
            "last_income_date": "2025-05-03",
            "last_income_amount": 1700,
            "last_income_description": "cip cr transfer from jane doe",
            "periods_with_income": 1,
            "number_of_incomes": 3,
            "number_of_months": 1
          },
          {
            "income_type": "WAGES",
            "frequency": "MONTHLY",
            "monthly_average": 3000,
            "average_income_amount": 3000,
            "currency": "",
            "stability": 1,
            "first_income_date": "2025-03-27",
            "last_income_date": "2025-04-22",
            "last_income_amount": 3000,
            "last_income_description": "cip cr subscriptions",
            "periods_with_income": 2,
            "number_of_incomes": 2,
            "number_of_months": 2
          }
        ],
        "income_source_type": "BANK",
        "first_transaction_date": "2024-09-30",
        "last_transaction_date": "2025-05-03",
        "period": "7 months",
        "number_of_income_streams": 2,
        "total_income": 11300,
        "annual_income": 11300,
        "monthly_income": 6130,
        "aggregated_monthly_average": 2133,
        "aggregated_monthly_average_regular": 1350,
        "aggregated_monthly_average_irregular": 10300,
        "total_regular_income_amount": 3000,
        "total_irregular_income_amount": 10300
      }
    }
      ,),

    SmartTransactionsTablePage()
    //SmartTransactionsPage()
    //ManageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green.shade800,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: "Card",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_upward),
            label: "Send",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.people),
          //   label: "Recipients",
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: "Manage",
          ),
        ],
      ),
    );
  }
}





class WiseAccountScreen extends StatelessWidget {
  const WiseAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              _topBar(context),
              const SizedBox(height: 24),
              const Text(
                "Account",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),
              _currencyCards(),
              const SizedBox(height: 30),
              _transactionsHeader(),
              const SizedBox(height: 12),
              _transactionItem(
                icon: Icons.arrow_upward,
                title: "For your Wise card",
                subtitle: "Paid · Today",
                amount: "9 SGD",
              ),
              const SizedBox(height: 12),
              _transactionItem(
                icon: Icons.add,
                title: "To your SGD balance",
                subtitle: "Added · Today",
                amount: "24 SGD",
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // 🔝 Top bar
  Widget _topBar(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xFFEFEFEF),
          child: Text(
            "YX",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: (){
                AppNavigation.push(context,
                    MonoConnectWidget()
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFB7F397),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Earn \$115",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.notifications_none),
          ],
        ),
      ],
    );
  }

  // 🔘 Filters
  Widget _filters() {
    return Row(
      children: [
        _filterChip("All", selected: true),
        const SizedBox(width: 10),
        _filterChip("Interest"),
      ],
    );
  }

  Widget _filterChip(String text, {bool selected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: selected ? Colors.green.shade800 : Colors.grey.shade300,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.green.shade800 : Colors.black54,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // 💳 Currency cards
  Widget _currencyCards() {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          _CurrencyCard(
            flag: "🇸🇬",
            amount: "15.00",
            currency: "Singapore Dollar",
            highlighted: true,
          ),
          SizedBox(width: 16),
          _CurrencyCard(
            flag: "🇦🇺",
            amount: "0.00",
            currency: "Australian Dollar",
          ),
        ],
      ),
    );
  }

  // 📄 Transactions
  Widget _transactionsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "Transactions",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "See all",
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _transactionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFFF1F1F1),
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
        Text(
          amount,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

}

// 💳 Currency Card Widget
class _CurrencyCard extends StatelessWidget {
  final String flag;
  final String amount;
  final String currency;
  final bool highlighted;

  const _CurrencyCard({
    required this.flag,
    required this.amount,
    required this.currency,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFFF2F2EF) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(flag, style: const TextStyle(fontSize: 28)),
          const Spacer(),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            currency,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}


class WiseAccountScreen2 extends StatelessWidget {
  const WiseAccountScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              // 👈 keep everything you already had here
              WiseAccountScreen()
            ],
          ),
        ),
      ),
    );
  }
}

