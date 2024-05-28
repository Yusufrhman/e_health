import 'package:e_health/models/appointment.dart';
import 'package:e_health/screen/appointment/appointment_detail_screen.dart';
import 'package:e_health/utils/config.dart';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppointmentCard extends StatelessWidget {
  AppointmentCard(
      {super.key, this.showActions = false, required this.appointment});
  final Appointment appointment;
  bool showActions;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentDetailScreen(
              appointment: appointment,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 252, 252, 252),
          // boxShadow: [
          //   BoxShadow(
          //     color: Config.primaryColor.withOpacity(0.4),
          //     spreadRadius: 0,
          //     blurRadius: 20,
          //     offset: const Offset(0, 3),
          //   ),
          // ],
          border: Border.fromBorderSide(
            BorderSide(width: 1, color: Config.backgroundColor),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Image.network(
                    appointment.doctor['image_url'],
                    height: MediaQuery.of(context).size.height * 0.2 * 0.4,
                    width: MediaQuery.of(context).size.height * 0.2 * 0.4,
                    fit: BoxFit.cover,
                  ),
                ),
                Config.spaceHorizontalSmall,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        appointment.doctor['name'],
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Config.primaryColor),
                      ),
                    ),
                    Text(
                      appointment.doctor['category'],
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Config.primaryColor.withOpacity(0.7)),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  appointment.status.name,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: appointment.status.name == 'ongoing'
                          ? Colors.blue
                          : appointment.status.name == 'completed'
                              ? Config.primaryColor
                              : Colors.red),
                ),
                Config.spaceHorizontalSmall
              ],
            ),
            Config.spaceSmall,
            Container(
              height: MediaQuery.of(context).size.height * 0.075,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [
                //     Config.primaryColor,
                //     Color.fromARGB(255, 66, 220, 189)
                //   ],
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                // ),
                color: Config.primaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.date_range,
                    color: Config.backgroundColor,
                  ),
                  Config.spaceHorizontalSmall,
                  Text(
                    appointment.formattedDate,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Config.backgroundColor),
                  ),
                  Config.spaceHorizontalBig,
                  const Icon(
                    Icons.alarm,
                    color: Config.backgroundColor,
                  ),
                  Config.spaceHorizontalSmall,
                  Text(
                    '${appointment.formattedTime}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Config.backgroundColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
