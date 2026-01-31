

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Card Screen"));
  }
}

class SendScreen extends StatelessWidget {
  const SendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Send Screen"));
  }
}

class RecipientsScreen extends StatelessWidget {
  const RecipientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Recipients Screen"));
  }
}





class ManageScreen extends StatelessWidget {
  const ManageScreen({super.key});

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
        //     "Manage",
        //     style: TextStyle(fontWeight: FontWeight.bold),
        //   ),
        // ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _profileCard(),
            const SizedBox(height: 30),
            _sectionTitle("Account"),
            _settingsTile(
              icon: Icons.credit_card,
              title: "Cards",
              subtitle: "Manage your cards",
              onTap: () {},
            ),
            _settingsTile(
              icon: Icons.lock_outline,
              title: "Security",
              subtitle: "PIN, biometrics & devices",
              onTap: () {},
            ),
            _settingsTile(
              icon: Icons.tune,
              title: "Limits",
              subtitle: "Spending & transfer limits",
              onTap: () {},
            ),
            const SizedBox(height: 30),
            _sectionTitle("Preferences"),
            _settingsTile(
              icon: Icons.language,
              title: "Language",
              subtitle: "English",
              onTap: () {},
            ),
            _settingsTile(
              icon: Icons.notifications_none,
              title: "Notifications",
              subtitle: "Manage alerts",
              onTap: () {},
            ),
            _settingsTile(
              icon: Icons.dark_mode_outlined,
              title: "Appearance",
              subtitle: "Light mode",
              onTap: () {},
            ),
            const SizedBox(height: 30),
            _sectionTitle("Support"),
            _settingsTile(
              icon: Icons.help_outline,
              title: "Help",
              subtitle: "Get support",
              onTap: () {},
            ),
            _settingsTile(
              icon: Icons.info_outline,
              title: "About",
              subtitle: "App version & legal",
              onTap: () {},
            ),
            const SizedBox(height: 30),
            _logoutTile(),
          ],
        ),
      ),
    );
  }

  // 👤 Profile Card
  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F8F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.green,
            child: Text(
              "YX",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Yusuf X",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Personal account",
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  // 📌 Section Title
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ⚙️ Settings Tile
  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFF1F1F1),
        child: Icon(icon, color: Colors.black),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  // 🚪 Logout
  Widget _logoutTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        backgroundColor: Color(0xFFFFEBEE),
        child: Icon(Icons.logout, color: Colors.red),
      ),
      title: const Text(
        "Log out",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        // TODO: Hook to auth logout
      },
    );
  }
}
