import 'dart:ffi';

enum DoctorCategory {
  general,
  cardiology,
  respirations,
  dermatology,
  gynecology,
  dental
}

class Doctor {
  Doctor({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.dateJoin,
    required this.imageUrl,
    required this.rating,
  });
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<dynamic> rating;
  final DoctorCategory category;
  final DateTime dateJoin;

  double get ratingAverage {
    if (rating.isEmpty) return 0.0;
    List<double> ratings = rating.map((value) {
      if (value is double) return value;
      return double.tryParse(value.toString()) ?? 0.0;
    }).toList();
    double sum = ratings.reduce((a, b) => a + b);
    return sum / ratings.length;
  }

  int get yearExperience {
    final currentYear = DateTime.now().year;
    final joinYear = dateJoin.year;
    return currentYear - joinYear;
  }
}

DoctorCategory getCategoryFromString(String str) {
  try {
    return DoctorCategory.values.firstWhere((e) => e.name == str);
  } catch (e) {
    throw Exception("Invalid category string: $str");
  }
}
