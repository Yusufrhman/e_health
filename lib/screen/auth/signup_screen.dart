import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:e_health/screen/auth/login_screen.dart';
import 'package:e_health/utils/config.dart';
import 'package:e_health/widget/button/large_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool flag = true;
  bool flagConfirm = true;
  final _formKey = GlobalKey<FormState>();
  final _firebaseAuth = FirebaseAuth.instance;
  String _enteredEmail = '';
  String _enteredName = '';
  String _enteredPassword = '';
  bool _isLoading = false;

  void _signUp() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      final userCredentials =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: _enteredEmail, password: _enteredPassword);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set(
        {
          'name': _enteredName,
          'email': _enteredEmail,
          'phone': '',
          'image_url': '',
          'birth_date': DateTime.now().toString(),
          'gender': 'male'
        },
      );
      await FirebaseAuth.instance.signOut();
      if (!mounted) {
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } on FirebaseAuthException catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Authentication failed!"),
            content: const Text("Please sake sure a valid input entered"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text("ok"),
              )
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome',
                    style: Theme.of(context).textTheme.titleLarge!,
                  ),
                  Config.spaceSmall,
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          'You can eazily signup and connect to the doctor near you!',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Config.spaceSmall,
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Masukkan Nama dengan benar!";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredName = newValue!;
                          },
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Config.primaryColor,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16.0),
                            hintText: 'Name',
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            labelText: 'Name',
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            alignLabelWithHint: true,
                            prefixIcon:
                                const Icon(Icons.person_outline_rounded),
                            prefixIconColor: Config.primaryColor,
                            border: Config.outlinedBorder,
                            focusedBorder: Config.focusBorder,
                          ),
                        ),
                        Config.spaceSmall,
                        TextFormField(
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains("@")) {
                              return "Masukkan email dengan benar!";
                            }
                            return null;
                          },
                          onSaved: (value) => _enteredEmail = value!,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Config.primaryColor,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              hintText: 'Email Address',
                              hintStyle: Theme.of(context).textTheme.bodyMedium,
                              labelText: 'Email',
                              labelStyle:
                                  Theme.of(context).textTheme.bodyMedium,
                              alignLabelWithHint: true,
                              prefixIcon: const Icon(Icons.email_outlined),
                              prefixIconColor: Config.primaryColor,
                              border: Config.outlinedBorder,
                              focusedBorder: Config.focusBorder),
                        ),
                        Config.spaceSmall,
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return "Kata sandi harus minimal 6 karakter!";
                            }
                            _enteredPassword = value;
                            return null;
                          },
                          onSaved: (value) => _enteredPassword = value!,
                          keyboardType: TextInputType.visiblePassword,
                          cursorColor: Config.primaryColor,
                          obscureText: flag ? true : false,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              hintText: 'Password',
                              hintStyle: Theme.of(context).textTheme.bodyMedium,
                              labelText: 'Password',
                              labelStyle:
                                  Theme.of(context).textTheme.bodyMedium,
                              alignLabelWithHint: true,
                              prefixIcon:
                                  const Icon(Icons.lock_outline_rounded),
                              prefixIconColor: Config.primaryColor,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    flag = !flag;
                                  });
                                },
                                icon: Icon(
                                  flag
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Config.primaryColor.withOpacity(0.5),
                                ),
                              ),
                              border: Config.outlinedBorder,
                              focusedBorder: Config.focusBorder),
                        ),
                        Config.spaceSmall,
                        TextFormField(
                          validator: (value) {
                            if (value != _enteredPassword) {
                              return "Kata Sandi tidak cocok!";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          cursorColor: Config.primaryColor,
                          obscureText: flagConfirm ? true : false,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16.0),
                            hintText: 'Confirm Password',
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            labelText: 'Confirm Password',
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            alignLabelWithHint: true,
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            prefixIconColor: Config.primaryColor,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  flagConfirm = !flagConfirm;
                                });
                              },
                              icon: Icon(
                                flagConfirm
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Config.primaryColor.withOpacity(0.5),
                              ),
                            ),
                            border: Config.outlinedBorder,
                            focusedBorder: Config.focusBorder,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Config.spaceSmall,
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Config.primaryColor,
                          ),
                        )
                      : LargeButton(
                          onPressed: () {
                            _signUp();
                          },
                          label: 'Sign Up',
                          backgroundColor: Config.primaryColor,
                        ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Already have an account? Login instead',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Config.primaryColor.withOpacity(0.75)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
