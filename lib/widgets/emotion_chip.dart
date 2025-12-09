import 'package:flutter/material.dart';
import 'package:sentir/models/emotion.dart';
import 'package:sentir/theme.dart';

class EmotionChip extends StatelessWidget {
  final Emotion emotion;
  final bool isSelected;
  final VoidCallback? onTap;

  const EmotionChip({
    super.key,
    required this.emotion,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? emotion.color : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: emotion.color,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              emotion.icon,
              size: 18,
              color: isSelected ? AppColors.pureWhite : emotion.color,
            ),
            const SizedBox(width: 8),
            Text(
              emotion.name,
              style: TextStyle(
                color: isSelected ? AppColors.pureWhite : emotion.color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
