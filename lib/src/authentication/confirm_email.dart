import 'dart:io';

import 'package:flutter/material.dart';

import '../../widgets/adaptiveForms.dart';

class ConfirmEmail extends StatefulWidget {
  const ConfirmEmail({super.key});

  @override
  State<ConfirmEmail> createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmail> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isIOS = Platform.isIOS;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close button
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: IconButton(
              //     icon: const Icon(Icons.close, size: 28),
              //     onPressed: () => Navigator.pop(context),
              //   ),
              // ),
              const SizedBox(height: 10),

              // Title
              const Text(
                'Enter your email address',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Email TextField
              CustomTextField  (
                isIOS:  isIOS,
                controller: _emailController,
                label: "Email",
                placeholder: "you@email.com",
              ),

              const Spacer(),

              // Terms and Privacy Text
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black54, fontSize: 13),
                      children: [
                        const TextSpan(text: 'By registering, you accept our '),
                        TextSpan(
                          text: 'Terms of Use',
                          style: const TextStyle(
                            color: const Color(0xFF9FE870),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: const TextStyle(
                            color: const Color(0xFF9FE870),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Add continue logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9FE870),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Bottom footer
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: const [
              //     Icon(Icons.money, size: 18, color: Colors.black),
              //     SizedBox(width: 6),
              //     Text(
              //       'Wise',
              //       style: TextStyle(fontWeight: FontWeight.w600),
              //     ),
              //     SizedBox(width: 8),
              //     Text(
              //       'curated by Mobbin',
              //       style: TextStyle(color: Colors.grey, fontSize: 13),
              //     ),
              //   ],
              // ),

            ],
          ),
        ),
      ),
    );
  }
}
