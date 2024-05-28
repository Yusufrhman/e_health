import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_health/models/appointment.dart';
import 'package:e_health/utils/config.dart';
import 'package:e_health/widget/appointment_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  List<QueryDocumentSnapshot> _appointmentsList = [];
  bool _isLoading = true;
  late QuerySnapshot newQuerySnapshot;
  var _currentIndex = 0;
  Future<void> _loadAppointments(AppointmentStatus status) async {
    newQuerySnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('status', isEqualTo: status.name)
        // .orderBy('schedule')
        .get();
    _appointmentsList = newQuerySnapshot.docs;
    _appointmentsList.sort((a, b) => (a['schedule']).compareTo(b['schedule']));
    _appointmentsList = _appointmentsList.reversed.toList();
    setState(() {
      _isLoading = false;
    });
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    AppointmentStatus status = AppointmentStatus.ongoing;

    if (_currentIndex == 0) {
      status = AppointmentStatus.ongoing;
    }
    if (_currentIndex == 1) {
      status = AppointmentStatus.completed;
    }
    if (_currentIndex == 2) {
      status = AppointmentStatus.canceled;
    }
    await _loadAppointments(status);
    setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    _loadAppointments(AppointmentStatus.ongoing);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: _currentIndex,
      length: 3,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Config.backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Config.backgroundColor,
          scrolledUnderElevation: 0,
          toolbarHeight: 50,
          title: Text(
            'My Appointment',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Config.primaryColor),
          ),
          bottom: TabBar(
            dividerHeight: 0,
            indicatorColor: Config.primaryColor,
            labelColor: Config.primaryColor,
            unselectedLabelColor: Config.primaryColor.withOpacity(0.35),
            labelStyle: Theme.of(context).textTheme.bodyMedium,
            onTap: (index) {
              if (index == 0) {
                _loadAppointments(AppointmentStatus.ongoing);
                _currentIndex = 0;
                setState(() {});
              }
              if (index == 1) {
                _loadAppointments(AppointmentStatus.completed);
                _currentIndex = 1;

                setState(() {});
              }
              if (index == 2) {
                _loadAppointments(AppointmentStatus.canceled);
                _currentIndex = 2;

                setState(() {});
              }
            },
            tabs: const [
              Tab(
                text: 'on going',
              ),
              Tab(
                text: 'completed',
              ),
              Tab(
                text: 'canceled',
              ),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Config.primaryColor,
                ),
              )
            : _appointmentsList.isEmpty
                ? Center(
                    child: Text(
                      'No Appointment yet...',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Config.primaryColor.withOpacity(0.75)),
                    ),
                  )
                : SafeArea(
                    bottom: false,
                    child: SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: false,
                      header: const WaterDropHeader(
                        complete: SizedBox(),
                        waterDropColor: Config.primaryColor,
                      ),
                      footer: CustomFooter(
                        builder: (BuildContext context, LoadStatus? mode) {
                          Widget body;
                          if (mode == LoadStatus.idle) {
                            body = Text("pull up load");
                          } else if (mode == LoadStatus.loading) {
                            body = CupertinoActivityIndicator();
                          } else if (mode == LoadStatus.failed) {
                            body = Text("Load Failed!Click retry!");
                          } else if (mode == LoadStatus.canLoading) {
                            body = Text("release to load more");
                          } else {
                            body = Text("No more Data");
                          }
                          return Container(
                            height: 55.0,
                            child: Center(child: body),
                          );
                        },
                      ),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                          itemCount: _appointmentsList.length,
                          itemBuilder: (context, index) {
                            var appointment = _appointmentsList[index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15, top: 15),
                              child: AppointmentCard(
                                appointment: Appointment(
                                    id: appointment.id,
                                    doctor: {...appointment['doctor']},
                                    rating: double.parse(
                                        appointment['rating'] ?? "0.0"),
                                    schedule:
                                        DateTime.parse(appointment['schedule']),
                                    status: getStatusFromString(
                                        appointment['status']),
                                    userId: appointment['userId']),
                                showActions: true,
                              ),
                            );
                          }),
                    ),
                  ),
      ),
    );
  }
}
