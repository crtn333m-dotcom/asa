import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'canvas_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late AnimationController _treeCtrl;
  late Animation<double> _fade, _tree;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _treeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _tree = CurvedAnimation(parent: _treeCtrl, curve: Curves.elasticOut);
    _fadeCtrl.forward();
    Future.delayed(const Duration(milliseconds: 300), () => _treeCtrl.forward());
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _treeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D0700), Color(0xFF1A0F00), Color(0xFF2C1A00)],
          ),
        ),
        child: FadeTransition(
          opacity: _fade,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // دائرة خلفية
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height),
                painter: _BackgroundCircles(),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // شجرة متحركة
                  ScaleTransition(
                    scale: _tree,
                    child: const _SplashTree(),
                  ),
                  const SizedBox(height: 28),

                  // العنوان
                  const Text(
                    'سلالتي',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 52,
                      color: Color(0xFFC9A84C),
                      letterSpacing: 3,
                      shadows: [
                        Shadow(blurRadius: 30, color: Color(0x80C9A84C)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    'ارسم شجرة عائلتك بأناقة',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 17,
                      color: Color(0xB3C9A84C),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),

                  const Text(
                    'كل جذع يحمل قصة، كل غصن يمتد بحياة',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0x66C9A84C),
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 60),

                  // زر البدء
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const CanvasScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFC9A84C), Color(0xFFE8C96A), Color(0xFFC9A84C)],
                        ),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x66C9A84C),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Text(
                        'ابدأ مشروعاً جديداً',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: Color(0xFF1A0F00),
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // اسم المصمم
              const Positioned(
                bottom: 28,
                child: Text(
                  'تصميم: حسين الدخيل',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0x59C9A84C),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackgroundCircles extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final p = Paint()..color = const Color(0xFFC9A84C).withOpacity(0.05)
      ..style = PaintingStyle.stroke..strokeWidth = 1;
    for (final r in [200.0, 160.0, 120.0]) {
      canvas.drawCircle(Offset(cx, cy), r, p);
    }
    p.strokeWidth = 0.5;
    for (int i = 0; i < 16; i++) {
      final angle = i * 2 * math.pi / 16;
      canvas.drawLine(
        Offset(cx + 120 * math.cos(angle), cy + 120 * math.sin(angle)),
        Offset(cx + 200 * math.cos(angle), cy + 200 * math.sin(angle)),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _SplashTree extends StatelessWidget {
  const _SplashTree();
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(120, 160),
      painter: _SplashTreePainter(),
    );
  }
}

class _SplashTreePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final trunkPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF5C3D1E), Color(0xFF8B6914), Color(0xFF5C3D1E)],
      ).createShader(Rect.fromLTWH(50, 0, 20, size.height))
      ..style = PaintingStyle.fill;
    final trunkPath = Path()
      ..moveTo(52, size.height)
      ..quadraticBezierTo(56, size.height * 0.6, 58, 80)
      ..lineTo(62, 80)
      ..quadraticBezierTo(64, size.height * 0.6, 68, size.height)
      ..close();
    canvas.drawPath(trunkPath, trunkPaint);

    final bp = Paint()..color = const Color(0xFF8B6914)
      ..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;

    final branches = [
      [60.0, 120.0, 15.0, 80.0],
      [60.0, 110.0, 100.0, 65.0],
      [60.0, 100.0, 20.0, 55.0],
      [60.0, 95.0, 105.0, 50.0],
    ];
    for (final b in branches) {
      canvas.drawLine(Offset(b[0], b[1]), Offset(b[2], b[3]), bp);
    }

    final leafColors = [
      const Color(0xFF2D6A4F), const Color(0xFF40916C), const Color(0xFF52B788)
    ];
    final leafPositions = [
      [15.0,80], [10.0,72], [22.0,68],
      [100.0,65], [108.0,57], [95.0,55],
      [20.0,55], [12.0,47], [28.0,45],
      [105.0,50], [112.0,42], [98.0,40],
    ];
    for (int i = 0; i < leafPositions.length; i++) {
      final lp = Paint()..color = leafColors[i % 3]..style = PaintingStyle.fill;
      canvas.save();
      canvas.translate(leafPositions[i][0], leafPositions[i][1]);
      canvas.rotate(i * 30 * math.pi / 180);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 16, height: 10), lp);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
