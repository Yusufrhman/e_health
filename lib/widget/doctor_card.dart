import 'package:e_health/models/doctor.dart';
import 'package:e_health/screen/doctor/doctor_screen.dart';
import 'package:e_health/utils/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key, required this.doctor});
  final Doctor doctor;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Ink(
        height: MediaQuery.of(context).size.height * 0.125,
        decoration: const BoxDecoration(
          // boxShadow: [
          //   BoxShadow(
          //     color: Config.primaryColor.withOpacity(0.2),
          //     spreadRadius: 1,
          //     blurRadius: 20,
          //     offset: const Offset(1, 2),
          //   ),
          // ],
          // gradient:  LinearGradient(
          //   colors: [
          //     Color.fromARGB(255, 238, 248, 246),
          //     Config.backgroundColor
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(18),
          ),
        ),
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(18),
          ),
          splashColor: const Color.fromARGB(255, 202, 242, 234),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DoctorScreen(
                  doctor: doctor,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  child: Image.network(
                    doctor.imageUrl,
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.1,
                    fit: BoxFit.cover,
                  ),
                ),
                Config.spaceHorizontalBig,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        doctor.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: const Color.fromARGB(255, 3, 123, 99)),
                      ),
                    ),
                    Text(
                      doctor.category.name,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color.fromARGB(255, 3, 162, 130)),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    Text(
                      doctor.ratingAverage.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      ' (${doctor.rating.length.toString()})',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.grey),
                    )
                  ],
                ),
                Config.spaceHorizontalMedium
              ],
            ),
          ),
        ),
      ),
    );
  }
}
