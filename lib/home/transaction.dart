import 'package:flutter/material.dart';

import '../widgets/transaction_tile.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   foregroundColor: Colors.black,
        //   title: const Text(
        //     "Transactions",
        //     style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: const [
            TransactionTile(
              icon: Icons.arrow_upward,
              title: "For your Wise card",
              subtitle: "Paid · Today",
              amount: "9 SGD",
            ),
            SizedBox(height: 12),
            TransactionTile(
              icon: Icons.add,
              title: "To your SGD balance",
              subtitle: "Added · Today",
              amount: "24 SGD",
            ),
          ],
        ),
      ),
    );
  }
}
