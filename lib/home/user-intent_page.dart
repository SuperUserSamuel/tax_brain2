import 'package:flutter/material.dart';

class WiseOnboardingScreen extends StatelessWidget {
  const WiseOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close button
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF1F1F1),
                  ),
                  child: const Icon(Icons.close, color: Colors.black),
                ),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 24),

              // Title
              Text(
                'What would you like to\ndo now?',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                "Don’t worry, you can come back to the other options later.",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 32),

              // Options
              _OptionTile(
                icon: Icons.payments_outlined,
                title: 'Send money abroad',
                subtitle: 'Make faster, cheaper money transfers.',
                onTap: () {},
              ),
              _OptionTile(
                icon: Icons.credit_card_outlined,
                title: 'Order a card to spend abroad',
                subtitle: 'Spend in multiple currencies.',
                onTap: () {},
              ),
              _OptionTile(
                icon: Icons.account_balance_outlined,
                title: 'Get local account details',
                subtitle: 'Receive payments or income.',
                onTap: () {},
              ),
              _OptionTile(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Hold many currencies in one place',
                subtitle: 'Open a balance in 50+ currencies.',
                onTap: () {},
              ),

              const Spacer(),

              // Decide later
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Decide later',
                    style: TextStyle(
                      color: Color(0xFF1B5E20),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable option tile
class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF1F1F1),
              ),
              child: Icon(icon, color: Colors.black),
            ),

            const SizedBox(width: 16),

            // Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
}
