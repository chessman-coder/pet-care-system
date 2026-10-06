import 'package:flutter/material.dart';
import 'package:pet_care/models/pet.dart';
import 'package:pet_care/ui/widgets/placeholder_image.dart';

class PetCard extends StatelessWidget {
  final Pet? pet;
  final String? image;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Color backgroundColor;
  final double borderRadius;

  const PetCard({
    super.key,
    this.pet,
    this.image,
    this.onTap,
    this.onDelete,
    this.backgroundColor = Colors.white,
    this.borderRadius = 20.0,
  });

  String get _displayName => pet?.name ?? "Pet's name";

  String get _displaySubtitle {
    final petBreed = pet?.breed ?? 'Breed';
    final petAge = pet?.age ?? 2;
    final ageText = petAge.toString().endsWith('yrs')
        ? '$petAge'
        : '${petAge}yrs';
    return '$petBreed , $ageText';
  }

  Widget _buildAvatar() {
    return const PlaceholderImage(
      size: 46,
      borderRadius: 12,
      backgroundColor: Colors.transparent,
      icon: Icons.image_rounded,
      iconColor: Colors.black87,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 14.0,
            ),
            child: Row(
              children: [
                _buildAvatar(),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _displaySubtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          height: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (onDelete == null) {
      return cardContent;
    }

    return Dismissible(
      key: ValueKey('dismiss_${pet?.id ?? pet?.name}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: const Text(
              'Delete Pet',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text('Are you sure you want to delete $_displayName?'),
            actionsPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4D4F),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Delete',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFF4D4F),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        alignment: Alignment.centerRight,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
          ],
        ),
      ),
      onDismissed: (direction) {
        onDelete?.call();
      },
      child: cardContent,
    );
  }
}
