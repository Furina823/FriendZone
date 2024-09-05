import 'package:flutter/material.dart';

class FilterModel {
  final String selectedGender;
  final RangeValues ageRange;
  final RangeValues compatibilityRange;
  final String selectedState;

  FilterModel({
    required this.selectedGender,
    required this.ageRange,
    required this.compatibilityRange,
    required this.selectedState,
  });

  // Add getters for the properties
  int get ageRangeMin => ageRange.start.toInt();
  int get ageRangeMax => ageRange.end.toInt();
  int get compatibilityRangeMin => compatibilityRange.start.toInt();
  int get compatibilityRangeMax => compatibilityRange.end.toInt();
}
