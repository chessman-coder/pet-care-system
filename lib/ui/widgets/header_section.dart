import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final double iconSize;
  final Color iconColor;
  final TextStyle? titleStyle;

  const HeaderSection({
    super.key,
    required this.icon,
    required this.title,
    this.iconSize = 22,
    this.iconColor = Colors.black,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: titleStyle ??
              const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
        ),
      ],
    );
  }
}
