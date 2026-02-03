
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tax_calculator/utils/navigate.dart';

import '../../home/home.dart';

import '../../home/user-intent_page.dart';
import '../authentication/login.dart';
import '../authentication/signup.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToEnd() {
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: _nextPage,
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            _nextPage();
          }
        },
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: const [
                OnboardingScreen1(),
                OnboardingScreen2(),
                OnboardingScreen3(),
              ],
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Progress bar
                    LinearProgressIndicator(
                      value: (_currentPage + 1) / 3,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF5A6B4A),
                      ),
                      minHeight: 4,
                    ),
                    const SizedBox(height: 16),
                    // Skip button
                    if (_currentPage < 2)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _skipToEnd,
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen1 extends StatefulWidget {
  const OnboardingScreen1({super.key});

  @override
  State<OnboardingScreen1> createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        // Animated illustration section
        Expanded(
          flex: 3,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: [
                  // Coin 1 (top left)
                  Positioned(
                    top: 50 + _floatAnimation.value,
                    left: 80,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: _buildCoin(30),
                    ),
                  ),

                  // Coin 2 (left)
                  Positioned(
                    top: 120 - _floatAnimation.value * 0.5,
                    left: 130,
                    child: Opacity(
                      opacity: _fadeAnimation.value * 0.8,
                      child: _buildCoin(35),
                    ),
                  ),

                  // Coin 3 (top right)
                  Positioned(
                    top: 100 + _floatAnimation.value * 0.7,
                    right: 80,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: _buildCoin(28),
                    ),
                  ),

                  // Red/Orange Vase (left)
                  Positioned(
                    bottom: 100,
                    left: 30,
                    child: Transform.translate(
                      offset: Offset(0, -_floatAnimation.value * 0.3),
                      child: _buildVase(
                        120,
                        160,
                        [
                          Colors.red,
                          Colors.orange.shade400,
                          Colors.pink.shade300,
                        ],
                      ),
                    ),
                  ),

                  // Yellow Vase (center)
                  Positioned(
                    bottom: 120,
                    left: MediaQuery.of(context).size.width / 2 - 45,
                    child: Transform.translate(
                      offset: Offset(0, _floatAnimation.value * 0.4),
                      child: _buildVase(
                        90,
                        130,
                        [
                          Colors.amber.shade400,
                          Colors.yellow.shade600,
                          Colors.orange.shade300,
                        ],
                      ),
                    ),
                  ),

                  // Green/Blue Vase (right)
                  Positioned(
                    bottom: 100,
                    right: 40,
                    child: Transform.translate(
                      offset: Offset(0, -_floatAnimation.value * 0.5),
                      child: _buildVase(
                        100,
                        140,
                        [
                          Colors.teal.shade300,
                          Colors.blue.shade400,
                          Colors.green.shade300,
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // Text content
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '175 COUNTRIES. 50 CURRENCIES. ONE ACCOUNT.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 40),

                const SizedBox(height: 60),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      AppNavigation.push(context,
                         // WiseAppShell()
                          WiseAccountScreen()
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9FE870),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Footer
        // const OnboardingFooter(),
      ],
    );
  }

  Widget _buildCoin(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.shade300,
            Colors.yellow.shade700,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '₦',
          style: TextStyle(
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
            color: Colors.yellow.shade900,
          ),
        ),
      ),
    );
  }

  Widget _buildVase(double width, double height, List<Color> colors) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(3, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Vase neck/opening
          Positioned(
            top: 0,
            left: width * 0.3,
            right: width * 0.3,
            child: Container(
              height: height * 0.15,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _cardAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _cardAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        // Animated illustration section
        Expanded(
          flex: 3,
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Rotating globe
                    Transform.rotate(
                      angle: _rotationAnimation.value * 2 * 3.14159,
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.green.shade300,
                              Colors.blue.shade300,
                              Colors.brown.shade200,
                              Colors.yellow.shade200,
                            ],
                            stops: const [0.0, 0.3, 0.6, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Wise card overlaying the globe
                    Transform.translate(
                      offset: Offset(_cardAnimation.value, -_cardAnimation.value),
                      child: Transform.rotate(
                        angle: -0.05,
                        child: Container(
                          width: 340,
                          height: 215,
                          decoration: BoxDecoration(
                            color: const Color(0xFF9FE870),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 45,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            color: Colors.amber.shade200,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 17.5,
                                                decoration: BoxDecoration(
                                                  color: Colors.amber.shade300,
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(4),
                                                    topRight: Radius.circular(4),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Icon(
                                          Icons.contactless,
                                          size: 32,
                                          color: Colors.black.withOpacity(0.7),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                          child: const Icon(
                                            Icons.bolt,
                                            color: Color(0xFF9FE870),
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Text(
                                          'wise',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        // Text content
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'PAY YOUR WAY WORLDWIDE WITH A UNIVERSAL CARD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 100),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      AppNavigation.push(context,
                          WiseAccountScreen()
                          //WiseOnboardingScreen()
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9FE870),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Footer
       // const OnboardingFooter(),
      ],
    );
  }
}

// class OnboardingFooter extends StatelessWidget {
//   const OnboardingFooter({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: const Color(0xFF9FE870),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Icon(
//               Icons.bolt,
//               color: Colors.black,
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 8),
//           const Text(
//             'Wise',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(width: 80),
//           const Text(
//             'curated by',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(width: 8),
//           const Text(
//             'Mobbin',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class OnboardingScreen3 extends StatefulWidget {
  const OnboardingScreen3({super.key});

  @override
  State<OnboardingScreen3> createState() => _OnboardingScreen3State();
}

class _OnboardingScreen3State extends State<OnboardingScreen3>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _coinAnimation1;
  late Animation<Offset> _coinAnimation2;
  late Animation<Offset> _coinAnimation3;
  late Animation<Offset> _coinAnimation4;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    // Coins orbiting around the globe
    _coinAnimation1 = Tween<Offset>(
      begin: const Offset(-80, 0),
      end: const Offset(-80, 0),
    ).animate(_controller);

    _coinAnimation2 = Tween<Offset>(
      begin: const Offset(-50, -50),
      end: const Offset(-50, -50),
    ).animate(_controller);

    _coinAnimation3 = Tween<Offset>(
      begin: const Offset(60, -30),
      end: const Offset(60, -30),
    ).animate(_controller);

    _coinAnimation4 = Tween<Offset>(
      begin: const Offset(80, 20),
      end: const Offset(80, 20),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset _getOrbitPosition(double angle, double radiusX, double radiusY) {
    return Offset(
      radiusX * math.cos(angle),
      radiusY * math.sin(angle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        // Animated illustration section
        Expanded(
          flex: 3,
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final angle = _rotationAnimation.value * 2 * math.pi;

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Central globe
                    Transform.rotate(
                      angle: angle * 0.5,
                      child: Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.cyan.shade300,
                              Colors.blue.shade400,
                              Colors.green.shade400,
                              Colors.teal.shade300,
                            ],
                            stops: const [0.0, 0.3, 0.6, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Orbiting coins
                    ..._buildOrbitingCoins(angle),
                  ],
                );
              },
            ),
          ),
        ),

        // Text content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Text(
                'ONE ACCOUNT FOR ALL THE MONEY IN THE WORLD',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 40),

              // Action buttons
              // Row(
              //   children: [
              //     Expanded(
              //       child: SizedBox(
              //         height: 56,
              //         child: ElevatedButton(
              //           onPressed: () {
              //             AppNavigation.push(context, AdaptiveLoginScreen());
              //           },
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: const Color(0xFF9FE870),
              //             foregroundColor: Colors.black,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(28),
              //             ),
              //             elevation: 0,
              //           ),
              //           child: const Text(
              //             'Log in',
              //             style: TextStyle(
              //               fontSize: 18,
              //               fontWeight: FontWeight.w600,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 16),
              //     Expanded(
              //       child: SizedBox(
              //         height: 56,
              //         child: ElevatedButton(
              //           onPressed: () {
              //             AppNavigation.push(context, AdaptiveSignupScreen());
              //           },
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: const Color(0xFF9FE870),
              //             foregroundColor: Colors.black,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(28),
              //             ),
              //             elevation: 0,
              //           ),
              //           child: const Text(
              //             'Register',
              //             style: TextStyle(
              //               fontSize: 18,
              //               fontWeight: FontWeight.w600,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    AppNavigation.pushReplacement (context,
                      //  WiseAppShell()
                        WiseAccountScreen()
                    );


                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9FE870),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Get started',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Sign in with Apple button
              // SizedBox(
              //   width: double.infinity,
              //   height: 56,
              //   child: ElevatedButton(
              //     onPressed: () {},
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.black,
              //       foregroundColor: Colors.white,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(28),
              //       ),
              //       elevation: 0,
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: const [
              //         Icon(Icons.apple, size: 24),
              //         SizedBox(width: 8),
              //         Text(
              //           'Sign in with Apple',
              //           style: TextStyle(
              //             fontSize: 18,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),



              const SizedBox(height: 40),
            ],
          ),
        ),

        // Footer
       // const OnboardingFooter(),
      ],
    );
  }

  List<Widget> _buildOrbitingCoins(double angle) {
    final coins = <Widget>[];

    // Create 5 coins orbiting at different positions
    for (int i = 0; i < 5; i++) {
      final coinAngle = angle + (i * 2 * math.pi / 5);
      final position = _getOrbitPosition(coinAngle, 160, 120);

      coins.add(
        Transform.translate(
          offset: position,
          child: _buildCoin(45 + (i % 2) * 10),
        ),
      );
    }

    return coins;
  }

  Widget _buildCoin(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.shade300,
            Colors.orange.shade600,
            Colors.brown.shade400,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          Container(
            width: size * 0.9,
            height: size * 0.9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.orange.shade900,
                width: 2,
              ),
            ),
          ),
          // Currency symbol
          Text(
            '₦',
            style: TextStyle(
              fontSize: size * 0.5,
              fontWeight: FontWeight.bold,
              color: Colors.brown.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
