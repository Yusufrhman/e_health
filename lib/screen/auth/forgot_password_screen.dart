import 'package:e_health/utils/config.dart';
import 'package:e_health/widget/button/large_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _enteredEmail = '';
  void _showChangePasswordSent() async {
    bool isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _enteredEmail);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Success!',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        content: Text(
          'We have sent the password change link to your email',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            style: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Config.primaryColor),
              padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Forgot Password',
                style: Theme.of(context).textTheme.titleLarge!,
              ),
              Config.spaceSmall,
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'We will send the password change link to your email',
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
                          labelStyle: Theme.of(context).textTheme.bodyMedium,
                          alignLabelWithHint: true,
                          prefixIcon: const Icon(Icons.email_outlined),
                          prefixIconColor: Config.primaryColor,
                          border: Config.outlinedBorder,
                          focusedBorder: Config.focusBorder),
                    ),
                    Config.spaceSmall,
                    Config.spaceSmall,
                    _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Config.primaryColor,
                            ),
                          )
                        : LargeButton(
                            onPressed: () {
                              _showChangePasswordSent();
                            },
                            label: 'send',
                            backgroundColor: Config.primaryColor,
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
