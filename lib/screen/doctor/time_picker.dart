import 'package:e_health/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class TimePicker extends StatefulWidget {
  TimePicker(
      {super.key,
      required this.time,
      required this.onSelectTime,
      this.isActive = false,
      this.disabled = false});
  final Function(DateTime value) onSelectTime;
  final DateTime time;
  bool isActive;
  bool disabled;

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  DateFormat timeFormatter = DateFormat('HH:mm');
  Color foregroundColor = const Color.fromARGB(255, 0, 29, 24);

  @override
  Widget build(BuildContext context) {
    if (widget.isActive) {
      foregroundColor = Config.backgroundColor;
    } else {
      foregroundColor = const Color.fromARGB(255, 0, 29, 24);
    }
    return !widget.disabled
        ? TextButton(
            onPressed: () {
              widget.onSelectTime(widget.time);
            },
            style: !widget.isActive
                ? ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 0.2,
                            color: Color.fromARGB(255, 188, 188, 188)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    minimumSize: const WidgetStatePropertyAll(Size(0, 0)),
                    padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                    foregroundColor: const WidgetStatePropertyAll(
                        Color.fromARGB(255, 29, 30, 30)),
                    backgroundColor:
                        const WidgetStatePropertyAll(Config.backgroundColor),
                  )
                : ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 0.2,
                            color: Color.fromARGB(255, 188, 188, 188)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    minimumSize: const WidgetStatePropertyAll(Size(0, 0)),
                    padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                    foregroundColor:
                        const WidgetStatePropertyAll(Config.backgroundColor),
                    backgroundColor:
                        const WidgetStatePropertyAll(Config.primaryColor),
                  ),
            child: Text(
              timeFormatter.format(widget.time),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold, color: foregroundColor),
            ),
          )
        : TextButton(
            onPressed: () {},
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  side: const BorderSide(
                      width: 0.2, color: Color.fromARGB(255, 188, 188, 188)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              minimumSize: const WidgetStatePropertyAll(Size(0, 0)),
              padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
              foregroundColor: const WidgetStatePropertyAll(
                  Color.fromARGB(255, 166, 166, 166)),
              backgroundColor: const WidgetStatePropertyAll(
                  Color.fromARGB(255, 236, 236, 236)),
            ),
            child: Text(
              timeFormatter.format(widget.time),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(),
            ),
          );
  }
}
