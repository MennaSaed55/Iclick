import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

class MemberMarkerWidget extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final String role;
  final VoidCallback onTap;

  const MemberMarkerWidget({
    super.key,
    required this.name,
    this.avatarUrl,
    required this.role,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.cBlack,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cBlack.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              name,
              style: TextStyle(
                color: AppColors.cWhite,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.cDarkPurple.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 22.r,
              backgroundColor: AppColors.cWhite,
              child: CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.cGrey6,
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'M',
                  style: TextStyle(
                    color: AppColors.cDarkPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
          CustomPaint(
            size: Size(12.w, 8.h),
            painter: _TrianglePainter(color: AppColors.cDarkPurple),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
