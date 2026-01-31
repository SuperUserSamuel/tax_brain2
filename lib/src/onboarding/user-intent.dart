import 'package:flutter/material.dart';

class PostVerificationOptionsScreen extends StatelessWidget {
  const PostVerificationOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black.withOpacity(0.15)),
              ),
              child: Center(
                child: Icon(Icons.close, color: Colors.black.withOpacity(0.7)),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What would you like to\ndo now?",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Don’t worry, you can come back to the other options later.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 28),

            // List Items
            _OptionItem(
              icon: Icons.attach_money_outlined,
              title: "Send money abroad",
              subtitle: "Make faster, cheaper money transfers.",
              onTap: () {},
            ),
            _OptionItem(
              icon: Icons.credit_card_outlined,
              title: "Order a card to spend abroad",
              subtitle: "Spend in multiple currencies.",
              onTap: () {},
            ),
            _OptionItem(
              icon: Icons.account_balance_outlined,
              title: "Get local account details",
              subtitle: "Receive payments or income.",
              onTap: () {},
            ),
            _OptionItem(
              icon: Icons.wallet_outlined,
              title: "Hold many currencies in one place",
              subtitle: "Open a balance in 50+ currencies.",
              onTap: () {},
            ),

            const Spacer(),

            Center(
              child: GestureDetector(
                onTap: () {},
                child: const Text(
                  "Decide later",
                  style: TextStyle(
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                    color: Color(0xFF2E4300),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(icon, color: Colors.black87),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6)),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.black54),
    );
  }
}
