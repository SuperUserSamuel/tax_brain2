import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/adaptiveForms.dart';
import '../../widgets/social_media_buttons.dart';

class AdaptiveLoginScreen extends StatefulWidget {
  const AdaptiveLoginScreen({super.key});

  @override
  State<AdaptiveLoginScreen> createState() => _AdaptiveLoginScreenState();
}

class _AdaptiveLoginScreenState extends State<AdaptiveLoginScreen>
    with SingleTickerProviderStateMixin {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  String? emailError;
  String? passError;
  String? confirmError;

  bool obscurePass = true;
  bool obscureConfirm = true;

  late AnimationController shakeCtrl;
  late Animation<double> shakeAnim;

  @override
  void initState() {
    super.initState();
    emailCtrl.addListener(_validate);
    passCtrl.addListener(_validate);

    shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: 0), weight: 1),
    ]).animate(shakeCtrl);
  }

  @override
  void dispose() {
    shakeCtrl.dispose();
    super.dispose();
  }

  void _validate() {
    setState(() {
      emailError =
      emailCtrl.text.contains('@') ? null : 'Enter a valid email';

      passError =
      passCtrl.text.length >= 6 ? null : 'Password too short';

    });
  }

  bool get isValid =>
      emailError == null &&
          passError == null &&
          confirmError == null &&
          emailCtrl.text.isNotEmpty &&
          passCtrl.text.isNotEmpty;


  void _submit() {
    if (!isValid) {
      shakeCtrl.forward(from: 0);
      HapticFeedback.mediumImpact();
    } else {
      // TODO: submit signup
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Platform.isIOS;

    final content = AnimatedBuilder(
      animation: shakeAnim,
      builder: (_, child) => Transform.translate(
        offset: Offset(shakeAnim.value, 0),
        child: child,
      ),
      child: _form(context, isIOS),
    );

    return isIOS
        ? Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body:  SafeArea(child: content),
    )
        : Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(child: content),
    );
  }

  // ───────────────────────── UI ─────────────────────────

  Widget _form(BuildContext context, bool isIOS) => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField  (
          isIOS:  isIOS,
          controller: emailCtrl,
          label: "Email",
          placeholder: "you@email.com",
        ),

        const SizedBox(height: 16),


        CustomTextField (
          isIOS:  isIOS,
          controller: passCtrl,
          label: "Password",
          placeholder: "••••••••",
          obscure: obscurePass,
          onToggleVisibility : () => setState(() => obscurePass = !obscurePass),
        ),


        const SizedBox(height: 24),

        _continueButton(isIOS),

        const SizedBox(height: 32),

        _divider(),

        const SizedBox(height: 24),

        SocialSignInButton(
            text: 'Continue with Google',
            logoPath: 'assets/google.svg',
            buttonColor: Colors.white,
            onPressed: (){},
            textColor: Colors.black),
        const SizedBox(height: 20),

        SocialSignInButton(
          text: 'Continue with Apple',
          logoPath: 'assets/apple.svg',
          buttonColor: Colors.black,
          onPressed: (){},
        ),
      ],
    ),
  );



  Widget _continueButton(bool isIOS) => SizedBox(
    width: double.infinity,
    height: 52,
    child: isIOS
        ? CupertinoButton(
      borderRadius: BorderRadius.circular(26),
      color:  const Color(0xFFB7E589),
      onPressed:  _submit,
      child: const Text("Continue"),
    )
        : ElevatedButton(
      onPressed: _submit,
      style: ElevatedButton.styleFrom(
        backgroundColor: isValid
            ? const Color(0xFFB7E589)
            : Colors.grey.shade400,
      ),
      child: const Text("Continue"),
    ),
  );

  Widget _divider() => Row(
    children: const [
      Expanded(child: Divider()),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text("OR"),
      ),
      Expanded(child: Divider()),
    ],
  );
}

enum PasswordStrength { weak, medium, strong }
