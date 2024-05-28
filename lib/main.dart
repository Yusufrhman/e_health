import 'package:e_health/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme.copyWith(
                  titleLarge: const TextStyle(
                    color: Color.fromARGB(255, 0, 34, 27),
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                  titleMedium: const TextStyle(
                    color: Color.fromARGB(255, 0, 34, 27),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  titleSmall: const TextStyle(
                    color: Color.fromARGB(255, 0, 34, 27),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  bodyLarge: const TextStyle(
                    color: Color.fromARGB(255, 0, 34, 27),
                    fontSize: 20,
                  ),
                  bodyMedium: const TextStyle(
                    color: Color.fromARGB(255, 0, 34, 27),
                    fontSize: 16,
                  ),
                  bodySmall: const TextStyle(
                    color: Color.fromARGB(255, 0, 34, 27),
                    fontSize: 14,
                  ),
                ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
