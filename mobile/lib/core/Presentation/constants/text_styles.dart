import 'package:flutter/material.dart';

// ------------------------------------
// FONT SIZES
// ------------------------------------

// Use a reference screen width to calculate proportional font sizes.
// A common reference is 400.0, but you can adjust this value.
const double kReferenceScreenWidth = 400.0;

/// A helper function to get a responsive font size based on screen width.
double getResponsiveFontSize(BuildContext context, double baseSize) {
  final screenWidth = MediaQuery.of(context).size.width;
  return baseSize * (screenWidth / kReferenceScreenWidth);
}

// Main title font size (e.g., "CHOOSE CLUBS")
double kTitleFontSize(BuildContext context) =>
    getResponsiveFontSize(context, 20.0);

// Tab button font size (e.g., "Ethiopian Premier League")
double kTabFontSize(BuildContext context) =>
    getResponsiveFontSize(context, 13.0);

// Tab button font size (e.g., "Ethiopian Premier League")
double kSearchBarText(BuildContext context) =>
    getResponsiveFontSize(context, 15.0);

// Club name font size (e.g., "St George FC")
double kClubNameFontSize(BuildContext context) =>
    getResponsiveFontSize(context, 16.0);

// Club description text font size
double kDescriptionFontSize(BuildContext context) =>
    getResponsiveFontSize(context, 12.0);

// Button text font size (e.g., "Follow")
double kButtonFontSize(BuildContext context) =>
    getResponsiveFontSize(context, 16.0);
