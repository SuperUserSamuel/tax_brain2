

import 'package:flutter/material.dart';

import '../action/connect_users.dart';
import '../action/table_version.dart';
import '../action/tax_calc.dart';
import '../src/tax_education.dart';
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
appBar: AppBar(
  centerTitle: true,
  title: Text('Home'),

),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _GreetingSection(),
          const SizedBox(height: 20),
          _TaxSummaryCard(),
          const SizedBox(height: 32),
          _PrimaryActions(),
          const SizedBox(height: 32),
          _ToolsSection(),

          const SizedBox(height: 32),
          _EducationCard(),
        ],
      ),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Tax Brain',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        SizedBox(height: 4),
        Text(
          'Let’s take care of your taxes',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _TaxSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estimated tax for this year',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 12),
          const Text(
            '₦ 1,240,500',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Based on available data',
            style: TextStyle(color: Colors.black45),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                AppNavigation.push(context,
                    SmartTransactionsTablePage()
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9FE870),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: const Text(
                'File Tax',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _PrimaryActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Get started',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        _ActionCard(
          icon: Icons.edit_note,
          title: 'Calculate manually',
          subtitle: 'Enter income and expenses yourself',
          onTap: () {
            AppNavigation.push(context,  AdvancedTaxCalculatorScreen(),);
          },
        ),
        _ActionCard(
          icon: Icons.account_balance,
          title: 'Use bank statement',
          subtitle: 'Automatically analyse your transactions',
          onTap: () {
            AppNavigation.push(context, SmartTransactionsTablePage());
          },
        ),
      ],
    );
  }
}


// class _TaxEducation extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Get started',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 16),
//         _ActionCard(
//           icon: Icons.edit_note,
//           title: 'Tax Education',
//           subtitle: 'Get knowledge about the new tax law',
//           onTap: () {
//             AppNavigation.push(context,  TaxEducationScreen(),);
//           },
//         ),
//
//       ],
//     );
//   }
// }


class _ToolsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tools & reports',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        _ActionCard(
          icon: Icons.bar_chart,
          title: 'Tax reports',
          subtitle: 'Monthly and yearly summaries',
          onTap: () {
            AppNavigation.push(context,  IncomeDashboardPage(data: {
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
              ,),);
          },
        ),
        _ActionCard(
          icon: Icons.picture_as_pdf,
          title: 'Tax Education',
          subtitle: 'Get knowledge about the new tax law',
          onTap: () {
            AppNavigation.push(context,  TaxEducationScreen(),);
          },
        ),
      ],
    );
  }
}


class _EducationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline, color: Color(0xFF1B5E20)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'We never file taxes for you. You stay in full control of your data.',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}


class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}


