import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_health/models/doctor.dart';

import 'package:e_health/screen/doctor/time_picker.dart';
import 'package:e_health/widget/doctor_detail.dart';
import 'package:e_health/utils/config.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key, required this.doctor});
  final Doctor doctor;
  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  final EasyInfiniteDateTimelineController _controller =
      EasyInfiniteDateTimelineController();
  DateTime _pickedDate = DateTime.now();
  bool _timeIsPicked = false;
  bool _isloading = false;
  final controller = GroupButtonController();
  List<String> timeSlots = [
    '12:00',
    "12:30",
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
  ];

  void makeAppointment() async {
    setState(() {
      _isloading = true;
    });
    try {
      await FirebaseFirestore.instance.collection('appointments').add(
        {
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'doctorId': widget.doctor.id,
          'doctor': {
            'id': widget.doctor.id,
            'name': widget.doctor.name,
            'image_url': widget.doctor.imageUrl,
            'category': widget.doctor.category.name
          },
          'status': 'ongoing',
          'schedule': _pickedDate.toIso8601String(),
          'rating': '0.0'
        },
      );
      if (!mounted) {
        return;
      }
      Navigator.pop(context);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          content: Text(
            'Success',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Config.backgroundColor),
          ),
        ),
      );
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  }

  void _showBookConfirm() {
    ScaffoldMessenger.of(context).clearSnackBars();
    if (!_timeIsPicked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please pick a valid schedule'),
          showCloseIcon: true,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Make Appointment?',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Make appointment with ${widget.doctor.name}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                "at ${DateFormat('M/d/y h:mm').format(_pickedDate)}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            style: const ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No, thanks",
                style: Theme.of(context).textTheme.bodyMedium!),
          ),
          Ink(
            child: TextButton(
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Config.primaryColor),
                  foregroundColor:
                      WidgetStatePropertyAll(Config.backgroundColor),
                  padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
              onPressed: () async {
                makeAppointment();
              },
              child: const Text("Confirm"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Scaffold(
      backgroundColor: Config.backgroundColor,
      appBar: AppBar(
        leading: IconButton.filledTonal(
            onPressed: () {
              Navigator.pop(context);
            },
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Config.primaryColor),
            ),
            color: Colors.white,
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        backgroundColor: Config.backgroundColor,
        scrolledUnderElevation: 0,
        toolbarHeight: 50,
        title: Text(
          'Doctor Details',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Config.primaryColor),
        ),
      ),
      body: _isloading
          ? const Center(
              child: CircularProgressIndicator(
                color: Config.primaryColor,
              ),
            )
          : SafeArea(
              maintainBottomViewPadding: true,
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20, top: 15, bottom: 100),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                NetworkImage(widget.doctor.imageUrl),
                          ),
                          Config.spaceHorizontalMedium,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  widget.doctor.name,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: const Color.fromARGB(
                                              255, 3, 123, 99),
                                          fontSize: 18),
                                ),
                              ),
                              Text(
                                widget.doctor.category.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: const Color.fromARGB(
                                            255, 3, 162, 130)),
                              ),
                            ],
                          )
                        ],
                      ),
                      const Divider(
                        color: Config.primaryColor,
                      ),
                      Config.spaceSmall,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DoctorDetail(
                            icon: Icons.people,
                            title: widget.doctor.rating.length.toString(),
                            label: 'patient',
                          ),
                          Config.spaceHorizontalBig,
                          DoctorDetail(
                            icon: Icons.work_history_rounded,
                            title: widget.doctor.yearExperience.toString(),
                            label: 'Years Exp.',
                          ),
                          Config.spaceHorizontalBig,
                          DoctorDetail(
                            icon: Icons.star_rounded,
                            title: widget.doctor.ratingAverage.toString(),
                            label: 'Rating',
                          ),
                        ],
                      ),
                      Config.spaceSmall,
                      Text(
                        "About",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Config.spaceSmall,
                      ReadMoreText(
                        widget.doctor.description,
                        trimLines: 2,
                        trimMode: TrimMode.Line,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: const Color.fromARGB(255, 95, 95, 95),
                            ),
                        moreStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Config.primaryColor,
                                ),
                        lessStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Config.primaryColor,
                                ),
                        textAlign: TextAlign.justify,
                        trimExpandedText: ' Show less',
                      ),
                      Config.spaceSmall,
                      Text(
                        "Schedules",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Config.spaceSmall,
                      EasyInfiniteDateTimeLine(
                        dayProps: const EasyDayProps(
                            height: 70,
                            todayHighlightStyle: TodayHighlightStyle.none),
                        activeColor: Config.primaryColor,
                        showTimelineHeader: false,
                        controller: _controller,
                        firstDate: DateTime.now(),
                        focusDate: _pickedDate,
                        lastDate: DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day + 7),
                        onDateChange: (selectedDate) {
                          setState(
                            () {
                              _pickedDate = selectedDate;
                              _timeIsPicked = false;
                            },
                          );
                        },
                      ),
                      Config.spaceSmall,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: timeSlots.map(
                            (time) {
                              List<String> parts = time.split(':');
                              int hour = int.parse(parts[0]);
                              int minute = int.parse(parts[1]);
                              DateTime buttonTime = DateTime(
                                  _pickedDate.year,
                                  _pickedDate.month,
                                  _pickedDate.day,
                                  hour,
                                  minute);
                              bool isDisabled = buttonTime.isBefore(now);
                              bool isActive =
                                  buttonTime.isAtSameMomentAs(_pickedDate);
                              return Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: TimePicker(
                                  time: buttonTime,
                                  isActive: isActive,
                                  onSelectTime: (value) {
                                    setState(() {
                                      _pickedDate = value;
                                      _timeIsPicked = true;
                                    });
                                  },
                                  disabled: isDisabled,
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Config.primaryColor,
          boxShadow: [
            BoxShadow(
              color: Config.primaryColor.withOpacity(0.4),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.125,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        child: InkWell(
          onTap: () {
            _showBookConfirm();
          },
          child: Container(
            decoration: const BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [
                //     Color.fromARGB(255, 166, 250, 233),
                //     Config.backgroundColor
                //   ],
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                // ),
                color: Config.backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Center(
              child: Text(
                'Book Appointment',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold, color: Config.primaryColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
