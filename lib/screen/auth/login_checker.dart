import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_health/providers/user_provider.dart';
import 'package:e_health/screen/auth/login_screen.dart';
import 'package:e_health/screen/main_menu.dart';

import 'package:e_health/utils/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginChecker extends ConsumerStatefulWidget {
  const LoginChecker({super.key});

  @override
  ConsumerState<LoginChecker> createState() => _LoginCheckerState();
}

class _LoginCheckerState extends ConsumerState<LoginChecker> {
  Future<void> _saveUserDataIntoProvider(userid) async {
    var userData =
        await FirebaseFirestore.instance.collection('users').doc(userid).get();
    ref.read(userProvider.notifier).setUser(
          name: userData.data()!['name'],
          email: userData.data()!['email'],
          gender: userData.data()!['gender'],
          phone: userData.data()!['phone'],
          birthDate: DateTime.parse(userData.data()!['birth_date']),
          imageUrl: userData.data()!['image_url'],
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          final userProviderData = ref.watch(userProvider);
          if (userProviderData.isEmpty) {
            _saveUserDataIntoProvider(snapshot.data!.uid);
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Config.primaryColor,
                ),
              ),
            );
          } else if (userProviderData['user_category'] == 1) {
            return const MainMenu();
          } else {
            return const MainMenu();
          }
        }

        return const LoginScreen();
      },
    );
  }
}
