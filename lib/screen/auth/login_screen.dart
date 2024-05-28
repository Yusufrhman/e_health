
import 'package:e_health/screen/auth/forgot_password_screen.dart';
import 'package:e_health/screen/auth/login_checker.dart';
import 'package:e_health/screen/auth/signup_screen.dart';
import 'package:e_health/utils/config.dart';
import 'package:e_health/widget/button/large_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool flag = true;
  final _formKey = GlobalKey<FormState>();
  final _firebaseAuth = FirebaseAuth.instance;

  String _enteredEmail = '';
  String _enteredPassword = '';

  bool _isLoading = false;
  void _login() async {
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
     await _firebaseAuth.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        if (!mounted) {
          return;
        }
        
        if (!mounted) {
          return;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginChecker(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message!),
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
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome',
                    style: Theme.of(context).textTheme.titleLarge!,
                  ),
                  Config.spaceSmall,
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sign in to your account!',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
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
                              hintStyle: Theme.of(context).textTheme.bodyMedium,
                              contentPadding: const EdgeInsets.all(16.0),
                              hintText: 'Email Address',
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
                              hintStyle: Theme.of(context).textTheme.bodyMedium,
                              contentPadding: const EdgeInsets.all(16.0),
                              hintText: 'Password',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPasswordScreen()));
                              },
                              style: const ButtonStyle(
                                minimumSize: WidgetStatePropertyAll(
                                  Size(0, 0),
                                ),
                              ),
                              child: Text(
                                'Forgot Your Password?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Config.primaryColor),
                              ),
                            ),
                          ],
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
                                  _login();
                                },
                                label: 'Log In',
                                backgroundColor: Config.primaryColor,
                              ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Dont have an account? Signup instead',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Config.primaryColor
                                          .withOpacity(0.75)),
                            ),
                          ),
                        ),
                      ],
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
