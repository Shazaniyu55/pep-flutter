import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pep/widget/bottomrectangularbtn.dart';
import 'package:provider/provider.dart';

import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
    _bootstrap();
  }

  /// Loads saved auth state, then routes to the right place. A minimum delay
  /// keeps the logo on screen long enough that it doesn't just flash on fast
  /// devices.
  Future<void> _bootstrap() async {
    final auth = context.read<AuthProvider>();

    await Future.wait([
      auth.loadFromStorage(),
      Future.delayed(const Duration(milliseconds: 2800)),
    ]);

    if (!mounted) return;

    if (!auth.isAuthenticated) {
      context.go(AppRoutes.login);
    } else if (auth.isDriver) {
      context.go(AppRoutes.driverHome);
    } else {
      context.go(AppRoutes.riderHome);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:  [
                Image.asset('images/logo.png', width: 200,height: 200,),
                SizedBox(height: 12),
                Text(
                  'PEP',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)
                ),
                Text(
                  'Move more,eat better, and feel great- one friendly day at a time',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)
                ),
                SizedBox(height: 48),
                BottomRectangularBtn(onTapFunc: () {  },btnTitle: 'Get Started', svgName: "arrow-right", color: Colors.white, buttonTextColor: Colors.black,),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}



