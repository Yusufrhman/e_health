import 'package:e_health/utils/config.dart';
import 'package:flutter/material.dart';

class LargeButton extends StatefulWidget {
  const LargeButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.backgroundColor = Config.backgroundColor,
    this.foregroundColor = Config.primaryColor,
  });
  final Function() onPressed;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  State<LargeButton> createState() => _LargeButtonState();
}

class _LargeButtonState extends State<LargeButton> {
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        side: const WidgetStatePropertyAll(
          BorderSide(color: Colors.grey),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(200),
          ),
        ),
        fixedSize: WidgetStatePropertyAll(
          Size.fromWidth(MediaQuery.of(context).size.width),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 20),
        ),
        backgroundColor: WidgetStatePropertyAll(
          widget.backgroundColor,
        ),
      ),
      onPressed: widget.onPressed,
      child: Text(
        widget.label,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
