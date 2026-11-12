import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Modern architectural house emblem with rising financial/prediction bars
/// and a smart spark dot, representing NyumbaSmart's household wallet & insights.
class NyumbaSmartLogo extends StatelessWidget {
  final double size;
  final Color houseColor;
  final Color eyeColor;

  const NyumbaSmartLogo({
    super.key,
    this.size = 68,
    this.houseColor = Colors.white,
    this.eyeColor = const Color(0xFF116340),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _NyumbaSmartEmblemPainter(
          houseColor: houseColor,
          barColor: eyeColor,
        ),
      ),
    );
  }
}

class _NyumbaSmartEmblemPainter extends CustomPainter {
  final Color houseColor;
  final Color barColor;

  const _NyumbaSmartEmblemPainter({
    required this.houseColor,
    required this.barColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final housePaint = Paint()
      ..color = houseColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Clean modern architectural house silhouette with pitched roof & rounded eaves
    final housePath = Path()
      ..moveTo(w * 0.46, h * 0.14)
      ..quadraticBezierTo(w * 0.50, h * 0.10, w * 0.54, h * 0.14)
      ..lineTo(w * 0.89, h * 0.41)
      ..quadraticBezierTo(w * 0.92, h * 0.44, w * 0.87, h * 0.46)
      ..lineTo(w * 0.82, h * 0.46)
      ..lineTo(w * 0.82, h * 0.79)
      ..quadraticBezierTo(w * 0.82, h * 0.88, w * 0.73, h * 0.88)
      ..lineTo(w * 0.27, h * 0.88)
      ..quadraticBezierTo(w * 0.18, h * 0.88, w * 0.18, h * 0.79)
      ..lineTo(w * 0.18, h * 0.46)
      ..lineTo(w * 0.13, h * 0.46)
      ..quadraticBezierTo(w * 0.08, h * 0.44, w * 0.11, h * 0.41)
      ..close();

    canvas.drawPath(housePath, housePaint);

    // Three ascending rounded finance / prediction bars inside the house
    final barPaint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final barWidth = w * 0.105;
    final barRadius = Radius.circular(barWidth * 0.48);
    final bottomY = h * 0.77;

    // Short bar (left)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(w * 0.285, h * 0.60, w * 0.285 + barWidth, bottomY),
        barRadius,
      ),
      barPaint,
    );

    // Medium bar (center)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(w * 0.447, h * 0.50, w * 0.447 + barWidth, bottomY),
        barRadius,
      ),
      barPaint,
    );

    // Tall bar (right - highlighted emerald mint)
    final tallBarPaint = Paint()
      ..color = const Color(0xFF1F9A64)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(w * 0.61, h * 0.39, w * 0.61 + barWidth, bottomY),
        barRadius,
      ),
      tallBarPaint,
    );

    // Subtle smart insight dot above left bar
    canvas.drawCircle(
      Offset(w * 0.338, h * 0.47),
      w * 0.042,
      tallBarPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _NyumbaSmartEmblemPainter oldDelegate) =>
      oldDelegate.houseColor != houseColor || oldDelegate.barColor != barColor;
}

/// Global subtle layered-wave background in our green palette (#F7F8F4, #E4F3EA, #D0EAD9)
/// so every screen in the application shares the organic wave aesthetic.
class NyumbaAppWaveBackground extends StatelessWidget {
  final Widget child;

  const NyumbaAppWaveBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: isDark ? AppColors.darkBackground : AppColors.background,
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _AppSoftGreenWavesPainter(isDark: isDark),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _AppSoftGreenWavesPainter extends CustomPainter {
  final bool isDark;

  const _AppSoftGreenWavesPainter({this.isDark = false});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final outerRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, w, h * 0.91),
      bottomLeft: const Radius.circular(48),
      bottomRight: const Radius.circular(48),
    );

    canvas.save();
    canvas.clipRRect(outerRect);

    // 1. Base gradient (Soft Green in Light Mode, Deep Forest Emerald in Dark Mode)
    final basePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? const [
                Color(0xFF0E1F18),
                Color(0xFF0C1A14),
                Color(0xFF0A1510),
              ]
            : const [
                Color(0xFFE4F3EA),
                Color(0xFFD2ECDC),
                Color(0xFFC5E5D2),
              ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), basePaint);

    // 2. Top-right to mid-left S-curve organic wave
    final midWavePaint = Paint()
      ..color = isDark
          ? const Color(0xFF1D8C5C).withValues(alpha: 0.14)
          : AppColors.primaryGreen.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    final darkWavePath = Path()
      ..moveTo(w * 0.34, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h * 0.29)
      ..cubicTo(
        w * 0.72,
        h * 0.31,
        w * 0.45,
        h * 0.35,
        0,
        h * 0.36,
      )
      ..lineTo(0, h * 0.32)
      ..cubicTo(
        w * 0.22,
        h * 0.25,
        w * 0.21,
        h * 0.08,
        w * 0.34,
        0,
      )
      ..close();
    canvas.drawPath(darkWavePath, midWavePaint);

    // 3. Center rounded wave pocket (matching reference image's middle band)
    final pocketPaint = Paint()
      ..color = isDark
          ? const Color(0xFF239E69).withValues(alpha: 0.16)
          : AppColors.primaryGreen.withValues(alpha: 0.17)
      ..style = PaintingStyle.fill;

    final pocketPath = Path()
      ..moveTo(0, h * 0.33)
      ..cubicTo(
        w * 0.35,
        h * 0.28,
        w * 0.68,
        h * 0.31,
        w,
        h * 0.26,
      )
      ..lineTo(w, h * 0.46)
      ..quadraticBezierTo(
        w * 0.96,
        h * 0.52,
        w * 0.80,
        h * 0.52,
      )
      ..lineTo(w * 0.20, h * 0.52)
      ..quadraticBezierTo(
        w * 0.04,
        h * 0.52,
        0,
        h * 0.46,
      )
      ..close();
    canvas.drawPath(pocketPath, pocketPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AppSoftGreenWavesPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

/// 1:1 Pixel-Faithful Match of the Uploaded "Smart Home" Login Reference Screen,
/// rendered in our Green Palette (#1F9362, #167D52, #116340, #FFFFFF).
class NyumbaAuthWaveLayout extends StatelessWidget {
  final String titleTop;
  final String titleBottom;
  final String subtitle;
  final Widget formContent;
  final Widget bottomActionButton;
  final Widget? topLeading;

  const NyumbaAuthWaveLayout({
    super.key,
    this.titleTop = 'Nyumba',
    this.titleBottom = 'Smart',
    required this.subtitle,
    required this.formContent,
    required this.bottomActionButton,
    this.topLeading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    // 1. Pure white bottom dock area
                    const Positioned.fill(
                      child: ColoredBox(color: Colors.white),
                    ),

                    // 2. Layered Green Wave Canvas covering top down to half-way through
                    //    the bottom "Log In" pill button (bottom: 58), with large 58px rounded bottom corners.
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 58,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(58),
                          bottomRight: Radius.circular(58),
                        ),
                        child: CustomPaint(
                          painter: _RichGreenHeroWavesPainter(),
                        ),
                      ),
                    ),

                    // 3. Foreground content aligned cleanly and scrollable when needed
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (topLeading != null)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: topLeading!,
                              )
                            else
                              const SizedBox(height: 24),

                            // Top Smiling House Icon
                            const Center(
                              child: NyumbaSmartLogo(size: 62),
                            ),
                            const SizedBox(height: 12),

                            // Stacked 2-line Title ("Nyumba\nSmart")
                            Text(
                              '$titleTop\n$titleBottom',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                height: 0.98,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 2-line Subtitle sitting inside the darker green wave pocket
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                subtitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.80),
                                  fontSize: 13,
                                  height: 1.35,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            const Spacer(flex: 2),

                            // Pill-shaped Inputs + Google Sign-In + links
                            formContent,

                            const SizedBox(height: 18),
                            const Spacer(flex: 1),

                            // Large White Pill Button ("Log In") straddling the bottom curve
                            Center(
                              child: SizedBox(
                                width: double.infinity,
                                height: 62,
                                child: bottomActionButton,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RichGreenHeroWavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Base vibrant green (#1C8E5D -> #167D52) matching the lighter outer zones in the reference image
    final basePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1F9562),
          Color(0xFF178255),
          AppColors.primaryGreen,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), basePaint);

    // 2. Upper-right & center-left deep forest green organic wave (#126843)
    //    Sweeps from top-center around the house icon down to the left edge
    final upperDarkWavePaint = Paint()
      ..color = const Color(0xFF126843)
      ..style = PaintingStyle.fill;

    final upperDarkWavePath = Path()
      ..moveTo(w * 0.38, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h * 0.30)
      ..cubicTo(
        w * 0.72,
        h * 0.33,
        w * 0.42,
        h * 0.37,
        0,
        h * 0.39,
      )
      ..lineTo(0, h * 0.35)
      ..cubicTo(
        w * 0.22,
        h * 0.29,
        w * 0.21,
        h * 0.16,
        w * 0.25,
        h * 0.08,
      )
      ..quadraticBezierTo(
        w * 0.28,
        h * 0.02,
        w * 0.38,
        0,
      )
      ..close();
    canvas.drawPath(upperDarkWavePath, upperDarkWavePaint);

    // 3. Deeper green rounded-bottom pocket (#0F5C3B) behind the subtitle,
    //    ending at ~53% of the green canvas with smooth rounded left & right corners
    final pocketPaint = Paint()
      ..color = const Color(0xFF0F5C3B)
      ..style = PaintingStyle.fill;

    final pocketPath = Path()
      ..moveTo(0, h * 0.37)
      ..cubicTo(
        w * 0.34,
        h * 0.32,
        w * 0.66,
        h * 0.33,
        w,
        h * 0.29,
      )
      ..lineTo(w, h * 0.47)
      ..quadraticBezierTo(
        w * 0.97,
        h * 0.54,
        w * 0.80,
        h * 0.54,
      )
      ..lineTo(w * 0.20, h * 0.54)
      ..quadraticBezierTo(
        w * 0.03,
        h * 0.54,
        0,
        h * 0.47,
      )
      ..close();
    canvas.drawPath(pocketPath, pocketPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Pill-shaped white-outlined input decoration matching the "User" and "Password"
/// fields in the reference design.
InputDecoration nyumbaPillAuthInputDecoration({
  required String hintText,
  Widget? prefixIcon,
}) {
  return InputDecoration(
    hintText: hintText,
    prefixIcon: prefixIcon,
    filled: true,
    fillColor: Colors.white.withValues(alpha: 0.06),
    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    hintStyle: TextStyle(
      color: Colors.white.withValues(alpha: 0.90),
      fontSize: 17,
      fontWeight: FontWeight.w500,
    ),
    errorStyle: const TextStyle(
      color: Color(0xFFFFD4D4),
      fontSize: 11.5,
      fontWeight: FontWeight.w600,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(32),
      borderSide: const BorderSide(color: Colors.white, width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(32),
      borderSide: const BorderSide(color: Colors.white, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(32),
      borderSide: const BorderSide(color: Colors.white, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(32),
      borderSide: const BorderSide(color: Color(0xFFFFB4B4), width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(32),
      borderSide: const BorderSide(color: Color(0xFFFFB4B4), width: 2.0),
    ),
  );
}
