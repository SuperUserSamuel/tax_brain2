

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';


class TaxEducationScreen extends StatelessWidget {
  const TaxEducationScreen({super.key});

  static const Color wiseGreen = Color(0xFF1B5E20);
  static const Color softGray = Color(0xFFF5F7F6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tax Education'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _IntroCard(),
          SizedBox(height: 18),
          _WhatChangedCard(),
          SizedBox(height: 18),
          _VideosSection(),
          SizedBox(height: 18),
          _VisualsSection(),
          SizedBox(height: 18),
          _ExamplesSection(),
          SizedBox(height: 18),
          _InteractiveCalculator(),
          SizedBox(height: 18),
          _FurtherResources(),
        ],
      ),
    );
  }
}

/// Intro - purpose + citations
class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Understanding the new Nigerian tax changes — simply.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Short, plain explanations, official resources, videos and worked examples. '
                'Keep this as a quick learning guide — laws may change, so always verify with the official revenue service or an accountant.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(Icons.link, size: 18),
              SizedBox(width: 8),
              Expanded(child: Text('Sources: Finance Act 2023, FIRS guidance, professional summaries.')),
            ],
          ),
        ],
      ),
    );
  }
}

/// What changed summary (short bullets) with citations
class _WhatChangedCard extends StatelessWidget {
  const _WhatChangedCard();

  @override
  Widget build(BuildContext context) {
    // Keep text short, link to sources (we show references below)
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('What changed (short)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 10),
          _bullet('Updated tax rules and reliefs: consolidated reliefs & rent relief adjustments.'),
          _bullet('PAYE remains the main way salary tax is collected — employers remit monthly.'),
          _bullet('New acts and reform proposals are consolidating multiple tax laws into a single tax act (ongoing reforms).'),
          const SizedBox(height: 8),
          const Text(
            'See official guidance and firm summaries for details (links at bottom).',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

/// Videos section - uses url_launcher
class _VideosSection extends StatelessWidget {
  const _VideosSection();

  // sample videos (replace IDs/urls with yours)
  static const List<Map<String, String>> videos = [
    {
      'title': 'FIRS: Tax Basics for Individuals',
      'url': 'https://www.youtube.com/watch?v=AAs7AKTRPc4',
    },
    {
      'title': 'How PAYE works — step by step',
      'url': 'https://www.youtube.com/watch?v=LtBQ91k81lk',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Quick videos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        ...videos.map((v) => _VideoCard(title: v['title']!, url: v['url']!)).toList(),
      ]),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final String title;
  final String url;
  const _VideoCard({required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    // Use YouTube thumbnail trick for a clean visual
    final id = Uri.parse(url).queryParameters['v'] ?? '';
    final thumb = id.isNotEmpty ? 'https://img.youtube.com/vi/$id/0.jpg' : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openUrl(url),
        child: Row(
          children: [
            if (thumb != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(thumb, width: 120, height: 70, fit: BoxFit.cover),
              )
            else
              Container(width: 120, height: 70, color: Colors.grey[200]),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
            const Icon(Icons.play_circle_fill, color: Color(0xFF1B5E20)),
          ],
        ),
      ),
    );
  }

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

/// Visuals: bracket bar and deductions flow
class _VisualsSection extends StatelessWidget {
  const _VisualsSection();

  @override
  Widget build(BuildContext context) {
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
        Text('Visual guides', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        SizedBox(height: 12),
        Text('Tax brackets (visual)', style: TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        _TaxBracketsBar(),
        SizedBox(height: 12),
        Text('How deductions reduce taxable income', style: TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 12),
        _DeductionsFlow(),
      ]),
    );
  }
}

/// Simple horizontal bar that shows rate bands visually
class _TaxBracketsBar extends StatelessWidget {
  const _TaxBracketsBar();

  // Use the common PAYE bands as an example. Keep these data-driven so you can update later.
  final List<Map<String, dynamic>> bands = const [
    {'max': 300000, 'rate': 7},
    {'max': 600000, 'rate': 11},
    {'max': 1100000, 'rate': 15},
    {'max': 1600000, 'rate': 19},
    {'max': 3200000, 'rate': 21},
    {'max': double.infinity, 'rate': 24},
  ];

  @override
  Widget build(BuildContext context) {
    // visual approximate widths based on band ranges
    final total = 3200000; // use the top threshold as baseline for width mapping
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: bands.map((b) {
            final max = b['max'] is double ? total : (b['max'] as int);
            final widthFactor = (max / total).clamp(0.03, 1.0);
            return Expanded(
              flex: (widthFactor * 1000).toInt(),
              child: Container(
                height: 24,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(child: Text('${b['rate']}%')),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        const Text('Bands are illustrative — check the latest rates in sources below.', style: TextStyle(color: Colors.black54)),
      ],
    );
  }
}

/// A small flowchart style explanation for deductions
class _DeductionsFlow extends StatelessWidget {
  const _DeductionsFlow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Color(0xFFF9FBF9), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Gross income → statutory deductions → taxable income', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Text('• Pension contributions (employee portion)'),
          Text('• Rent relief (where applicable)'),
          Text('• Other allowable deductions (per current guidance)'),
          SizedBox(height: 8),
          Text('Then apply PAYE bands to compute tax.'),
        ],
      ),
    );
  }
}

/// Examples: worked walkthroughs (employee & freelancer)
class _ExamplesSection extends StatelessWidget {
  const _ExamplesSection();

  @override
  Widget build(BuildContext context) {
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
        Text('Worked examples', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        SizedBox(height: 12),
        _WorkedExampleEmployee(),
        SizedBox(height: 12),
        _WorkedExampleFreelancer(),
      ]),
    );
  }
}

class _WorkedExampleEmployee extends StatelessWidget {
  const _WorkedExampleEmployee();

  @override
  Widget build(BuildContext context) {
    // Example: monthly salary 500,000 => yearly 6,000,000; pension employee 8%; rent relief 20% of rent capped
    final formatter = NumberFormat.currency(symbol: '₦', decimalDigits: 0);
    const monthly = 500000;
    const yearly = monthly * 12;
    final pension = (yearly * 0.08).round(); // 8%
    final afterPension = yearly - pension;
    const rent = 2000000; // yearly rent
    final rentRelief = (rent * 0.2).clamp(0, 500000).toInt();
    final taxable = afterPension - rentRelief;
    // Placeholder tax computed roughly (this should use real band logic; see interactive calculator)
    final roughTax = (taxable * 0.21).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Example: Salaried worker', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text('Monthly salary: ₦500,000 → Annual: ${formatter.format(yearly)}'),
        Text('Employee pension (8%): ${formatter.format(pension)}'),
        Text('Rent relief (20% of rent, capped at ₦500,000): ${formatter.format(rentRelief)}'),
        Text('Estimated taxable income: ${formatter.format(taxable)}'),
        const SizedBox(height: 6),
        Text('Estimated tax (illustrative): ${formatter.format(roughTax)} (use calculator for exact PAYE).', style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}

class _WorkedExampleFreelancer extends StatelessWidget {
  const _WorkedExampleFreelancer();

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '₦', decimalDigits: 0);
    const revenue = 3000000; // yearly
    const businessExpenses = 600000;
    final taxable = revenue - businessExpenses;
    final approxTax = (taxable * 0.15).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Example: Freelancer / small business (simplified)', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text('Revenue: ${formatter.format(revenue)}'),
        Text('Allowable business expenses (example): ${formatter.format(businessExpenses)}'),
        Text('Estimated taxable income: ${formatter.format(taxable)}'),
        Text('Estimated tax (illustrative): ${formatter.format(approxTax)}'),
        const SizedBox(height: 6),
        const Text('Freelancers must register, keep records and file annual returns.'),
      ],
    );
  }
}

/// Interactive PAYE calculator widget
class _InteractiveCalculator extends StatefulWidget {
  const _InteractiveCalculator();

  @override
  State<_InteractiveCalculator> createState() => _InteractiveCalculatorState();
}

class _InteractiveCalculatorState extends State<_InteractiveCalculator> {
  final salaryController = TextEditingController(text: '500000'); // monthly
  final pensionController = TextEditingController(text: '8'); // %
  final rentController = TextEditingController(text: '2000000'); // annual rent

  String result = '';

  @override
  void dispose() {
    salaryController.dispose();
    pensionController.dispose();
    rentController.dispose();
    super.dispose();
  }

  void _compute() {
    final monthly = double.tryParse(salaryController.text.replaceAll(',', '')) ?? 0;
    final yearly = (monthly * 12).round();
    final pensionRate = double.tryParse(pensionController.text) ?? 0;
    final pension = ((pensionRate / 100) * yearly).round();
    final rent = double.tryParse(rentController.text.replaceAll(',', ''))?.round() ?? 0;
    final rentRelief = (rent * 0.2).clamp(0, 500000).round();

    final taxable = yearly - pension - rentRelief;

    // Very simple banded tax compute (example using common bands).
    // IMPORTANT: keep these band values in one place and update with real law.
    final bands = <int>[300000, 300000, 500000, 500000, 1600000, 999999999];
    final rates = <double>[0.07, 0.11, 0.15, 0.19, 0.21, 0.24];

    var remaining = taxable;
    double tax = 0;
    for (var i = 0; i < bands.length; i++) {
      if (remaining <= 0) break;
      final bandAmount = bands[i];
      final amountInBand = remaining < bandAmount ? remaining : bandAmount;
      tax += amountInBand * rates[i];
      remaining -= amountInBand;
    }

    final monthlyTax = (tax / 12).round();

    final formatter = NumberFormat.currency(symbol: '₦', decimalDigits: 0);
    setState(() {
      result = 'Annual taxable: ${formatter.format(taxable)}\n'
          'Estimated annual tax: ${formatter.format(tax.round())}\nMonthly PAYE estimate: ${formatter.format(monthlyTax)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '₦', decimalDigits: 0);
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Interactive PAYE calculator', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        TextField(
          controller: salaryController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Monthly salary (₦)'),
        ),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
            child: TextField(
              controller: pensionController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Employee pension %'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: rentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Annual rent (₦)'),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20)),
          onPressed: _compute,
          child: const Text('Compute'),
        ),
        const SizedBox(height: 8),
        if (result.isNotEmpty) Text(result, style: const TextStyle(color: Colors.black87)),
        const SizedBox(height: 8),
        const Text('Note: calculator is illustrative. Use official forms or a professional for filing.',
            style: TextStyle(color: Colors.black54)),
      ]),
    );
  }
}

/// Further resources, official links and suggestion to consult professionals
class _FurtherResources extends StatelessWidget {
  const _FurtherResources();

  @override
  Widget build(BuildContext context) {
    return _card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Further reading & resources', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        _linkRow('Official Nigeria Revenue Service site', 'https://www.nrs.gov.ng/'),
        _linkRow('Finance Act highlights (firm summary)', 'https://www.ey.com/en_gl/technical/tax-alerts/nigeria---highlights-of-finance-act-2023'),
        _linkRow('FIRS guidance: PAYE computation (PDF)', 'https://fctirs.gov.ng/wp-content/uploads/Guideline-to-Personal-Income-Tax-Computation.pdf'),
        const SizedBox(height: 12),
        const Text('If you are unsure: consult a licensed tax practitioner or use an official tax clinic.', style: TextStyle(color: Colors.black54)),
      ]),
    );
  }

  Widget _linkRow(String title, String url) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          const Icon(Icons.open_in_new, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: const TextStyle(decoration: TextDecoration.underline))),
        ]),
      ),
    );
  }
}

/// small helper to keep card style consistent
Widget _card({required Widget child}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
      ],
      border: Border.all(color: Colors.black12),
    ),
    child: child,
  );
}
