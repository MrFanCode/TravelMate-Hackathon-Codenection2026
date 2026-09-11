import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// The diagonal red/navy/parchment stripe used at the top of every
/// screen — TravelMate's signature "airmail envelope" motif.
class AirmailStripe extends StatelessWidget {
  final double height;
  const AirmailStripe({super.key, this.height = 8});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _AirmailPainter()),
    );
  }
}

class _AirmailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const stripeWidth = 16.0;
    final colors = [AppColors.rust, AppColors.paper, AppColors.ink, AppColors.paper];
    final paint = Paint();
    // Draw repeating diagonal stripes by tiling angled rectangles.
    double x = -size.height;
    int i = 0;
    while (x < size.width + size.height) {
      paint.color = colors[i % colors.length];
      final path = Path()
        ..moveTo(x, size.height)
        ..lineTo(x + size.height, 0)
        ..lineTo(x + size.height + stripeWidth, 0)
        ..lineTo(x + stripeWidth, size.height)
        ..close();
      canvas.drawPath(path, paint);
      x += stripeWidth;
      i++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
