import 'package:ethio_football/core/Presentation/constants/colors.dart';
import 'package:ethio_football/core/Presentation/constants/text_styles.dart';
import 'package:flutter/material.dart';

class LeaguePreferenceTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const LeaguePreferenceTab({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? kAccentColor : Colors.transparent,
                width: 3.0,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? kPrimaryTextColor : kSecondaryTextColor,
              fontWeight: FontWeight.bold,
              fontSize: kTabFontSize(context),
            ),
          ),
        ),
      ),
    );
  }
}
