import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFilterBar extends StatelessWidget {
  final DateTimeRange? range;
  final VoidCallback onPick;

  const DateFilterBar({super.key, this.range, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPick,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.green.withOpacity(0.08),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month),
            const SizedBox(width: 10),
            Text(
              range == null
                  ? "Filter by date"
                  : "${DateFormat.yMMMd().format(range!.start)} - ${DateFormat.yMMMd().format(range!.end)}",
            ),
            const Spacer(),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
