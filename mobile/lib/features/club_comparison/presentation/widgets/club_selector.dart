/// Widget for displaying and selecting a club in the comparison interface.
/// Shows the selected club name and provides a tap handler for club selection.
import 'package:flutter/material.dart';

class ClubSelector extends StatelessWidget {
  final String label;
  final String selectedClub;
  final VoidCallback? onTap;

  const ClubSelector({
    super.key,
    required this.label,
    required this.selectedClub,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.filter_list, color: Colors.white, size: 16),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              selectedClub,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
