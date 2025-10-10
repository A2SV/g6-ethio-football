import 'package:flutter/material.dart';

class TeamLogo extends StatelessWidget {
  final String logoUrl;
  final String teamName;
  final double size;

  const TeamLogo({
    super.key,
    required this.logoUrl,
    required this.teamName,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    // Check if logo URL is valid
    if (logoUrl.isEmpty || logoUrl == 'null' || !logoUrl.startsWith('http')) {
      return Icon(
        Icons.sports_soccer,
        size: size,
        color: const Color(0xFF666666),
      );
    }

    return Image.network(
      logoUrl,
      width: size,
      height: size,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Icon(
          Icons.sports_soccer,
          size: size,
          color: const Color(0xFF666666),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // Silently handle logo loading errors
        return Icon(
          Icons.sports_soccer,
          size: size,
          color: const Color(0xFF666666),
        );
      },
    );
  }
}
