import 'package:e_health/utils/config.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoryButton extends StatelessWidget {
  CategoryButton(
      {super.key,
      required this.icon,
      required this.label,
      this.isActive = true});
  final IconData icon;
  final String label;
  bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: !isActive
            ? const LinearGradient(
                colors: [
                  Color.fromARGB(255, 217, 247, 251),
                  Color.fromARGB(255, 243, 248, 250)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [
                  Config.primaryColor,
                  Color.fromARGB(255, 66, 220, 189)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(200),
      ),
      child: TextButton.icon(
        onPressed: () {},
        label: Text(label),
        icon: Icon(icon),
        style: ButtonStyle(
          shadowColor: !isActive
              ? WidgetStatePropertyAll(
                  Color.fromARGB(255, 184, 255, 241).withOpacity(0.5))
              : WidgetStatePropertyAll(Config.primaryColor.withOpacity(0.5)),
          elevation: !isActive
              ? const WidgetStatePropertyAll(2.0)
              : const WidgetStatePropertyAll(5.0),
          padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 20)),
          foregroundColor: !isActive
              ? WidgetStatePropertyAll(Config.primaryColor)
              : WidgetStatePropertyAll(Config.backgroundColor),
          side: const WidgetStatePropertyAll(BorderSide(
            color: Config.backgroundColor,
            width: 1,
          )),
          textStyle: WidgetStatePropertyAll(
            Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
          ),
          minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
          iconSize: const WidgetStatePropertyAll(20),
        ),
      ),
    );
  }
}
