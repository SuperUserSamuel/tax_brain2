



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


//
//
//
// class MonthlyTaxReportScreen extends StatelessWidget {
//   final List<MonthlyTaxReport> reports;
//
//   const MonthlyTaxReportScreen({super.key, required this.reports});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Monthly Tax Report")),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(20),
//         itemCount: reports.length,
//         itemBuilder: (_, i) {
//           final r = reports[i];
//           return Container(
//             margin: const EdgeInsets.only(bottom: 14),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF2F8F5),
//               borderRadius: BorderRadius.circular(18),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(r.month,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 8),
//                 Text("Income: ₦${r.income.toStringAsFixed(2)}"),
//                 Text("Expenses: ₦${r.expenses.toStringAsFixed(2)}"),
//                 Text(
//                   "Tax: ₦${r.tax.toStringAsFixed(2)}",
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
