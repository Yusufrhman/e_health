import 'package:age_calculator/age_calculator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class UserNotifier extends StateNotifier<Map<String, dynamic>> {
  UserNotifier() : super({});

  void setUser({
    required String name,
    required String email,
    String? gender,
    String? phone,
    DateTime? birthDate,
    String? imageUrl,
  }) {
    state = {
      'name': name,
      'email': email,
      'gender': gender ?? "-",
      'phone': phone ?? "-",
      'birth_date': birthDate,
      'formatted_birth_date': DateFormat('yMd').format(birthDate!),
      'age': AgeCalculator.age(birthDate).years.toString(),
      'image_url': imageUrl ?? "",
    };
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, Map<String, dynamic>>((ref) {
  return UserNotifier();
});
