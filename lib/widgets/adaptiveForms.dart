import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomTextField extends StatelessWidget {
  final bool isIOS;
  final TextEditingController controller;
  final String label;
  final String placeholder;
  final bool obscure;
  final VoidCallback? onToggleVisibility;

  const CustomTextField({
    super.key,
    required this.isIOS,
    required this.controller,
    required this.label,
    required this.placeholder,
    this.obscure = false,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    // Logic for the suffix icon (eye icon for passwords)
    final Widget? suffix = onToggleVisibility == null
        ? null
        : isIOS
        ? CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onToggleVisibility,
      child: Icon(
        obscure ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
        size: 20,
      ),
    )
        : IconButton(
      icon: Icon(
        obscure ? Icons.visibility_off : Icons.visibility,
      ),
      onPressed: onToggleVisibility,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 6),
        isIOS
            ? CupertinoTextField(
          controller: controller,
          placeholder: placeholder,
          obscureText: obscure,
          suffix: suffix,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: CupertinoColors.activeGreen),
            borderRadius: BorderRadius.circular(12),
          ),
        )
            : TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: placeholder,
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}