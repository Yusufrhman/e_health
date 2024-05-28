import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_health/models/appointment.dart';
import 'package:e_health/screen/doctor/time_picker.dart';

import 'package:e_health/utils/config.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';

class AppointmentDetailScreen extends StatefulWidget {
  const AppointmentDetailScreen({super.key, required this.appointment});
  final Appointment appointment;
  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  final EasyInfiniteDateTimelineController _controller =
      EasyInfiniteDateTimelineController();
  DateTime? _pickedDate;
  bool _timeIsPicked = true;
  bool _isLoading = false;

  final controller = GroupButtonController();
  DateTime now = DateTime.now();

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
  void _giveRating(rating) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(widget.appointment.id)
          .update(
        {'rating': rating.toString()},
      );
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(widget.appointment.doctor['id'])
          .update(
        {
          'rating': FieldValue.arrayUnion([rating.toString()])
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
        _isLoading = false;
      });
    }
  }

  void _showRatingConfirm(rating) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Rate this doctor',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        content: Text(
          "Give this doctor a rate of $rating stars",
          style: Theme.of(context).textTheme.bodyMedium,
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
                  backgroundColor: WidgetStatePropertyAll(Colors.amber),
                  foregroundColor:
                      WidgetStatePropertyAll(Config.backgroundColor),
                  padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
              onPressed: () async {
                _giveRating(rating);
              },
              child: const Text("Confirm"),
            ),
          ),
        ],
      ),
    );
  }

  void _showRescheduleConfirm() {
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
          'Reschedule Appointment?',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reschedule appointment with ${widget.appointment.doctor['name']}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                "at ${DateFormat('M/d/y h:mm').format(_pickedDate!)}",
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
                _reschedule();
              },
              child: const Text("Confirm"),
            ),
          ),
        ],
      ),
    );
  }

  void _reschedule() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(widget.appointment.id)
          .update(
        {
          'schedule': _pickedDate!.toIso8601String(),
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
        _isLoading = false;
      });
    }
  }

  void _showConfirmCancel() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Appointment?',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        content: Text(
          "You can't undo this action",
          style: Theme.of(context).textTheme.bodyMedium,
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
                  backgroundColor: WidgetStatePropertyAll(Colors.red),
                  foregroundColor:
                      WidgetStatePropertyAll(Config.backgroundColor),
                  padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
              onPressed: () async {
                _cancel();
              },
              child: const Text("Confirm"),
            ),
          ),
        ],
      ),
    );
  }

  void _cancel() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(widget.appointment.id)
          .update(
        {
          'status': 'canceled',
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
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _pickedDate = widget.appointment.schedule;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          'Appointment Details',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Config.primaryColor),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Config.primaryColor,
              ),
            )
          : SafeArea(
              bottom: false,
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                                widget.appointment.doctor['image_url']),
                          ),
                          Config.spaceHorizontalMedium,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  widget.appointment.doctor['name'],
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
                                widget.appointment.doctor['category'],
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
                      Config.spaceSmall,
                      // Config.spaceSmall,
                      // Text(
                      //   "Booking Code: ",
                      //   overflow: TextOverflow.ellipsis,
                      //   style: Theme.of(context)
                      //       .textTheme
                      //       .bodyLarge!
                      //       .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                      // ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       '0001',
                      //       style: Theme.of(context).textTheme.bodyLarge,
                      //     )
                      //   ],
                      // ),
                      Config.spaceSmall,
                      Text(
                        "Status ",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      widget.appointment.status.name == 'ongoing'
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color.fromARGB(255, 185, 218, 245),
                              ),
                              child: Center(
                                child: Text(
                                  widget.appointment.status.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: const Color.fromARGB(
                                            255, 0, 69, 125),
                                      ),
                                ),
                              ),
                            )
                          : widget.appointment.status.name == 'completed'
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color.fromARGB(
                                        255, 210, 247, 239),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.appointment.status.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Config.primaryColor,
                                          ),
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color.fromARGB(255, 241, 200, 200),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.appointment.status.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color:
                                                Color.fromARGB(255, 115, 1, 1),
                                          ),
                                    ),
                                  ),
                                ),
                      Config.spaceSmall,
                      Text(
                        "Schedule",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat('dd MMMM yyyy, HH:mm').format(_pickedDate!),
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontSize: 18),
                      ),
                      Config.spaceBig,
                      widget.appointment.status.name != 'ongoing'
                          ? widget.appointment.status.name == 'completed'
                              ? Text(
                                  "Rating",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                )
                              : SizedBox()
                          : Text(
                              "Reschedule",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                            ),
                      Config.spaceSmall,
                      widget.appointment.status.name != 'ongoing'
                          ? widget.appointment.status.name == 'completed'
                              ? RatingBar.builder(
                                  ignoreGestures:
                                      widget.appointment.rating > 0.0,
                                  initialRating: widget.appointment.rating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    _showRatingConfirm(rating);
                                  },
                                )
                              : SizedBox()
                          : EasyInfiniteDateTimeLine(
                              dayProps: const EasyDayProps(
                                  height: 70,
                                  todayHighlightStyle:
                                      TodayHighlightStyle.none),
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
                      widget.appointment.status.name != 'ongoing'
                          ? SizedBox()
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: timeSlots.map(
                                  (time) {
                                    List<String> parts = time.split(':');
                                    int hour = int.parse(parts[0]);
                                    int minute = int.parse(parts[1]);
                                    DateTime buttonTime = DateTime(
                                        _pickedDate!.year,
                                        _pickedDate!.month,
                                        _pickedDate!.day,
                                        hour,
                                        minute);
                                    bool isDisabled = buttonTime.isBefore(now);
                                    bool isActive = buttonTime
                                        .isAtSameMomentAs(_pickedDate!);
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
                            ),
                      Config.spaceMedium,
                      widget.appointment.status.name != 'ongoing'
                          ? SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    _showConfirmCancel();
                                  },
                                  style: const ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                    ),
                                    backgroundColor: WidgetStatePropertyAll(
                                      Color.fromARGB(255, 248, 219, 218),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel Appointment',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: const Color.fromARGB(
                                                255, 159, 11, 0)),
                                  ),
                                ),
                                Config.spaceHorizontalMedium,
                                TextButton(
                                  onPressed: () {
                                    _showRescheduleConfirm();
                                  },
                                  style: const ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                    ),
                                    backgroundColor: WidgetStatePropertyAll(
                                      Color.fromARGB(255, 218, 236, 248),
                                    ),
                                  ),
                                  child: Text(
                                    'Reschedule',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: const Color.fromARGB(
                                                255, 0, 35, 96)),
                                  ),
                                ),
                              ],
                            )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
