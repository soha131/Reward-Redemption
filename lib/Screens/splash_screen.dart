import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import 'package:reward_redemption/Screens/rewards_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.7, curve: Curves.elasticOut)),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.easeOut)),
    );

    _controller.forward().then((_) {
      // تأخير قصير قبل الانتقال إلى الشاشة التالية (مثل RewardsListScreen)
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 800),
              pageBuilder: (_, __, ___) => RewardsScreen(), // استبدلي بـ الشاشة الرئيسية
              transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50, // خلفية فاتحة تتناسب مع الثيم الأخضر لإعادة التدوير
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade300, Colors.teal.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // لوجو أو أيقونة الشركة (يمكن استبدالها بصورة حقيقية إذا كان لديكِ لوجو)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.teal.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.recycling, // أيقونة تتناسب مع إعادة التدوير والذكاء الاصطناعي
                            size: 80,
                            color: Colors.teal.shade700,
                          ),
                        ),
                        const SizedBox(height: 40),
                        // اسم الشركة مع تأثير حديث
                        Text(
                          'Drop Me',
                          style: GoogleFonts.poppins( // أو TextStyle(fontFamily: 'Poppins', ...)
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade900,
                            letterSpacing: 2,
                            shadows: [
                              Shadow(
                                color: Colors.teal.withOpacity(0.4),
                                offset: const Offset(0, 4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // وصف الشركة مع تحريك خفيف
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'We make recycling smart, simple, and rewarding.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins( // أو TextStyle(fontFamily: 'Poppins', ...)
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.teal.shade800,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // مؤشر تحميل حديث (دائرة دوارة مع لمسة خضراء)
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade700),
                          strokeWidth: 5,
                          backgroundColor: Colors.teal.shade100,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}