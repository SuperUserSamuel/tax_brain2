// Reusable components
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialSignInButton extends StatelessWidget {
  final String text;
  final String logoPath;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color? textColor;

  const SocialSignInButton({
    super.key,
    required this.text,
    required this.logoPath,
    required this.onPressed,
    required this.buttonColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (logoPath.isNotEmpty)
            SvgPicture.asset(
              logoPath,
              height: 24,
              width: 24,
            ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
          ),
        ],
      ),
    );
  }
}
