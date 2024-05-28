import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_health/models/appointment.dart';
import 'package:e_health/models/doctor.dart';
import 'package:e_health/providers/user_provider.dart';
import 'package:e_health/widget/appointment_card.dart';
import 'package:e_health/widget/doctor_card.dart';
import 'package:e_health/utils/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.openAnotherTab});
  final Function(int i) openAnotherTab;
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<QueryDocumentSnapshot> _doctorsList = [];
  List<QueryDocumentSnapshot> _appointment = [];

  bool _isLoading = true;
  late QuerySnapshot newQuerySnapshot;

  Future<void> _loadData() async {
    newQuerySnapshot = await FirebaseFirestore.instance
        .collection('doctors')
        .orderBy('date_join')
        .limit(4)
        .get();
    _doctorsList = newQuerySnapshot.docs;

    newQuerySnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('status', isEqualTo: 'ongoing')
        .limit(1)
        .get();
    _appointment = newQuerySnapshot.docs;
    setState(() {
      _isLoading = false;
    });
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await _loadData();
    setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _userData = ref.watch(userProvider);
    print(_userData['image_url']);
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Config.primaryColor,
            ),
          )
        : SmartRefresher(
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 15, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: .0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(_userData['name'],
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontSize: 20)),
                          ),
                          InkWell(
                            onTap: () {
                              widget.openAnotherTab(3);
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  _userData['image_url'].trim() != ''
                                      ? NetworkImage(_userData['image_url'])
                                      : const AssetImage('assets/profile.jpg'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Config.spaceBig,
                    Row(
                      children: [
                        Text(
                          "My Appointment",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            widget.openAnotherTab(2);
                          },
                          child: Text(
                            "See all",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Config.primaryColor.withOpacity(0.75)),
                          ),
                        )
                      ],
                    ),
                    Config.spaceSmall,
                    _appointment.isEmpty
                        ? Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'No Appointment yet...',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Config.primaryColor
                                            .withOpacity(0.75)),
                              ),
                            ),
                          )
                        : AppointmentCard(
                            appointment: Appointment(
                                rating: double.parse(
                                    _appointment[0]['rating'] ?? '0.0'),
                                id: _appointment[0].id,
                                doctor: {..._appointment[0]['doctor']},
                                schedule:
                                    DateTime.parse(_appointment[0]['schedule']),
                                status: getStatusFromString(
                                    _appointment[0]['status']),
                                userId: _appointment[0]['userId']),
                            showActions: true,
                          ),
                    Config.spaceBig,
                    Row(
                      children: [
                        Text(
                          "Top Doctors",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            widget.openAnotherTab(1);
                          },
                          child: Text(
                            "See all",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Config.primaryColor.withOpacity(0.75)),
                          ),
                        )
                      ],
                    ),
                    Config.spaceSmall,
                    ..._doctorsList.map<Widget>((value) {
                      print(value.data());
                      return DoctorCard(
                        doctor: Doctor(
                            id: value.id,
                            name: value['name'],
                            description: value['description'],
                            category: getCategoryFromString(value['category']),
                            dateJoin: DateTime.parse(
                              value['date_join'],
                            ),
                            rating: value['rating'],
                            imageUrl: value['image_url']),
                      );
                    })
                  ],
                ),
              ),
            ),
          );
  }
}
