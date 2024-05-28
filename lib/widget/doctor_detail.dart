import 'package:e_health/utils/config.dart';
import 'package:flutter/material.dart';

class DoctorDetail extends StatelessWidget {
  const DoctorDetail(
      {super.key,
      required this.icon,
      required this.title,
      required this.label});
  final String title, label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            color: Color.fromARGB(255, 192, 244, 234),
          ),
          child: Icon(
            icon,
            color: Config.primaryColor,
            size: 25,
          ),
        ),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: Config.primaryColor, fontSize: 20),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: const Color.fromARGB(247, 157, 156, 156),
              ),
        ),
      ],
    );
  }
}
