import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import '../service/models/categorizer.dart';
import '../service/models/transaction.dart';
import 'convert_pdf.dart';
import 'get_taxes.dart';




/// ================= MAIN PAGE =================
class SmartTransactionsTablePage extends StatefulWidget {
  const SmartTransactionsTablePage({super.key});

  @override
  State<SmartTransactionsTablePage> createState() =>
      _SmartTransactionsTablePageState();
}

class _SmartTransactionsTablePageState
    extends State<SmartTransactionsTablePage> {
  DateTimeRange? range;
  late List<BankTransaction> allTransactions;

  // Filter states
  String narrationQuery = '';
  String? typeFilter; // null = all, "credit", "debit"
  Set<String> taxableTransactionIds = {}; // Track which transactions are marked taxable
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    allTransactions =
        sampleApiResponse.map(BankTransaction.fromJson).toList();

    // Initialize taxable transactions based on category
    taxableTransactionIds = allTransactions
        .where((tx) => tx.type == "credit" && isTaxEligible(tx.category))
        .map((tx) => tx.id)
        .toSet();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BankTransaction> get filtered {
    var result = allTransactions;

    // Filter by date range
    if (range != null) {
      result = result.where((tx) {
        return tx.date.isAfter(range!.start) &&
            tx.date.isBefore(range!.end);
      }).toList();
    }

    // Filter by narration
    if (narrationQuery.isNotEmpty) {
      result = result.where((tx) {
        return tx.narration.toLowerCase().contains(narrationQuery.toLowerCase());
      }).toList();
    }

    // Filter by type (credit/debit)
    if (typeFilter != null) {
      result = result.where((tx) => tx.type == typeFilter).toList();
    }

    return result;
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

  void _toggleTaxable(String transactionId) {
    setState(() {
      if (taxableTransactionIds.contains(transactionId)) {
        taxableTransactionIds.remove(transactionId);
      } else {
        taxableTransactionIds.add(transactionId);
      }
    });
  }

  void _clearFilters() {
    setState(() {
      range = null;
      narrationQuery = '';
      typeFilter = null;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final grouped = groupByMonth(filtered);

    final credits = filtered.where((e) => e.type == "credit").toList();
    final debits = filtered.where((e) => e.type == "debit").toList();

    final income = credits.fold(0.0, (s, e) => s + e.amount);

    // Calculate taxable income based on user selection
    final taxableIncome = credits
        .where((e) => taxableTransactionIds.contains(e.id))
        .fold(0.0, (s, e) => s + e.amount);

    final expenses = debits.fold(0.0, (s, e) => s + e.amount);
    final tax = calculateTax(taxableIncome);
    final net = income - tax;

    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Tax Breakdown'),
      ),
      backgroundColor: const Color(0xFFF6F7F9),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Smart Tax Breakdown',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
    
          // Filter Section
          _buildFilterSection(),
    
          const SizedBox(height: 24),
    
          // Active Filters Display
          if (range != null || narrationQuery.isNotEmpty || typeFilter != null)
            _buildActiveFilters(),
    
          const SizedBox(height: 16),
    
          // Tables by month
          ...grouped.entries.map(
                (e) => _monthTable(e.key, e.value),
          ),
    
          const SizedBox(height: 16),
          _summary(
            grouped,
            credits.length,
            debits.length,
            taxableIncome,
            tax,
            net,
          ),
        ],
      ),
    );
  }

  /// ================= FILTER SECTION =================

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (range != null || narrationQuery.isNotEmpty || typeFilter != null)
                TextButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.clear_all, size: 18),
                  label: const Text('Clear All'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Search by narration
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by narration...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: narrationQuery.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    narrationQuery = '';
                  });
                },
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            onChanged: (value) {
              setState(() {
                narrationQuery = value;
              });
            },
          ),

          const SizedBox(height: 16),

          // Date range filter
          _dateFilter(),

          const SizedBox(height: 16),

          // Type filter (Credit/Debit)
          const Text(
            'Transaction Type',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _filterChip(
                label: 'All',
                selected: typeFilter == null,
                onSelected: () => setState(() => typeFilter = null),
              ),
              _filterChip(
                label: 'Credit Only',
                selected: typeFilter == 'credit',
                onSelected: () => setState(() => typeFilter = 'credit'),
                color: Colors.green,
              ),
              _filterChip(
                label: 'Debit Only',
                selected: typeFilter == 'debit',
                onSelected: () => setState(() => typeFilter = 'debit'),
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required bool selected,
    required VoidCallback onSelected,
    Color? color,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: (color ?? Colors.blue).withOpacity(0.2),
      checkmarkColor: color ?? Colors.blue,
      backgroundColor: Colors.grey.shade100,
      labelStyle: TextStyle(
        color: selected ? (color ?? Colors.blue) : Colors.grey.shade700,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_list, size: 16, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                'Active Filters:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (range != null)
                _activeFilterChip(
                  label: '${DateFormat.yMd().format(range!.start)} - ${DateFormat.yMd().format(range!.end)}',
                  onRemove: () => setState(() => range = null),
                ),
              if (narrationQuery.isNotEmpty)
                _activeFilterChip(
                  label: 'Search: "$narrationQuery"',
                  onRemove: () => setState(() {
                    narrationQuery = '';
                    _searchController.clear();
                  }),
                ),
              if (typeFilter != null)
                _activeFilterChip(
                  label: '${typeFilter!.toUpperCase()} only',
                  onRemove: () => setState(() => typeFilter = null),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _activeFilterChip({
    required String label,
    required VoidCallback onRemove,
  }) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 11),
      ),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onRemove,
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.blue.shade200),
    );
  }

  /// ================= SUMMARY =================

  Widget _summary(
  Map<String, List<BankTransaction>> grouped,
      int creditCount,
      int debitCount,
      double taxable,
      double tax,
      double net,
      ) {
    final taxableCount = taxableTransactionIds.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Summary",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _row("Credits", creditCount.toString()),
          _row("Debits", debitCount.toString()),
          _row("Taxable Transactions", taxableCount.toString()),
          _row("Taxable Income", "₦${taxable.toStringAsFixed(0)}"),
          _row("Estimated Tax", "₦${tax.toStringAsFixed(0)}"),
          const Divider(),
          _row("Net Income", "₦${net.toStringAsFixed(0)}", bold: true),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text("Export Summary to PDF"),
            onPressed: () => _exportPdfs(grouped: grouped, creditCount: creditCount, debitCount: debitCount, taxableIncome: taxable, tax: tax, net: net),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
          ),
        ],
      ),
    );
  }

  /// ================= TABLE =================

  Widget _monthTable(String month, List<BankTransaction> txs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                month,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${txs.length} transaction${txs.length != 1 ? 's' : ''}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - 32,
              ),
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                  border: TableBorder.all(color: Colors.grey.shade300),
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  columnWidths: const {
                    0: FixedColumnWidth(80),   // Taxable checkbox
                    1: FixedColumnWidth(100),  // Date
                    2: FixedColumnWidth(250),  // Narration
                    3: FixedColumnWidth(100),  // Type
                    4: FixedColumnWidth(150),  // Category
                    5: FixedColumnWidth(120),  // Amount
                  },
                  children: [
                    _headerRow(),
                    ...txs.map(_dataRow),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  TableRow _headerRow() {
    return const TableRow(
      decoration: BoxDecoration(color: Color(0xFFF0F0F0)),
      children: [
        _HeaderCell("Taxable"),
        _HeaderCell("Date"),
        _HeaderCell("Narration"),
        _HeaderCell("Type"),
        _HeaderCell("Category"),
        _HeaderCell("Amount"),
      ],
    );
  }

  TableRow _dataRow(BankTransaction tx) {
    final isCredit = tx.type == "credit";
    final isTaxable = taxableTransactionIds.contains(tx.id);

    return TableRow(
      children: [
        // Taxable checkbox (only for credits)
        Padding(
          padding: const EdgeInsets.all(8),
          child: isCredit
              ? Checkbox(
            value: isTaxable,
            onChanged: (_) => _toggleTaxable(tx.id),
            activeColor: Colors.green,
          )
              : const SizedBox(),
        ),
        _cell(DateFormat.yMd().format(tx.date)),
        _cell(tx.narration),
        _cell(
          tx.type.toUpperCase(),
          color: isCredit ? Colors.green : Colors.red,
        ),
        _cell(categoryLabel(tx.category.name)),
        _cell(
          "${isCredit ? '+' : '-'}₦${tx.amount.toStringAsFixed(0)}",
          color: isCredit ? Colors.green : Colors.red,
        ),
      ],
    );
  }

  static Widget _cell(String text, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: bold ? FontWeight.bold : null,
          color: color,
        ),
      ),
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
          borderRadius: BorderRadius.circular(12),
          color: range != null
              ? Colors.green.withOpacity(0.15)
              : Colors.grey.shade100,
          border: Border.all(
            color: range != null ? Colors.green : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month,
              color: range != null ? Colors.green : Colors.grey.shade700,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                range != null
                    ? "${DateFormat.yMd().format(range!.start)} - ${DateFormat.yMd().format(range!.end)}"
                    : "Filter by date range",
                style: TextStyle(
                  color: range != null ? Colors.green : Colors.grey.shade700,
                  fontWeight: range != null ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: range != null ? Colors.green : Colors.grey.shade700,
            ),
          ],
        ),
      ),
    );
  }



  Future<void> _exportPdfs({
    required Map<String, List<BankTransaction>> grouped,
    required int creditCount,
    required int debitCount,
    required double taxableIncome,
    required double tax,
    required double net,
  }) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );


      await TransactionPdfGenerator.generateTransactionsPdf(
        groupedTransactions: grouped,
        creditCount: creditCount,
        debitCount: debitCount,
        taxableIncome: taxableIncome,
        tax: tax,
        netIncome: net,
        taxableTransactionIds: taxableTransactionIds,
        dateRange: range,
      );

      // Close loading indicator
      if (mounted) {
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF generated successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // Close loading indicator
      if (mounted) {
        Navigator.of(context).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate PDF: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

// Helper widget for table headers
class _HeaderCell extends StatelessWidget {
  final String text;

  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}




