import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_vgv_app/core/theme/app_colors.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({required this.imageUrl, required this.size, super.key});

  final String imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular((size / 2).r),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: size.w,
        height: size.w,
        fit: BoxFit.cover,
        placeholder: (_, _) => Container(
          width: size.w,
          height: size.w,
          color: AppColors.skeletonBase,
        ),
        errorWidget: (_, _, _) => Container(
          width: size.w,
          height: size.w,
          color: AppColors.skeletonBase,
          child: Icon(
            Icons.person,
            size: (size / 2).r,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
