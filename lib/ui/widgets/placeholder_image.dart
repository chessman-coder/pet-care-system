import 'package:flutter/material.dart';

class PlaceholderImage extends StatelessWidget {
  final double size;
  final double borderRadius;
  final Color? backgroundColor;
  final IconData icon;
  final Color iconColor;

  const PlaceholderImage({
    super.key,
    required this.size,
    this.borderRadius = 8.0,
    this.backgroundColor,
    this.icon = Icons.image,
    this.iconColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        icon,
        size: size,
        color: iconColor,
      ),
    );
  }
}
