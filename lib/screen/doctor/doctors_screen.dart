import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_health/models/doctor.dart';

import 'package:e_health/utils/config.dart';
import 'package:e_health/widget/doctor_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  List<QueryDocumentSnapshot> _doctorsList = [];
  bool _isLoading = true;
  late QuerySnapshot newQuerySnapshot;
  final TextEditingController _controller = TextEditingController();
  String searchQuery = '';

  Future<void> _loadDoctors(String searchQuery) async {
    newQuerySnapshot =
        await FirebaseFirestore.instance.collection('doctors').get();
    _doctorsList = newQuerySnapshot.docs;
    if (searchQuery.isNotEmpty || searchQuery.trim() == '') {
      setState(() {
        _doctorsList = _doctorsList.where((document) {
          var data = document.data() as Map<String, dynamic>;
          var value = data['name'] as String;
          return value.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _loadDoctors(searchQuery);
    super.initState();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await _loadDoctors(searchQuery);
    setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Config.primaryColor,
        ),
      );
    }
    return Column(
      children: [
        Container(
          color: Config.backgroundColor,
          padding: const EdgeInsets.only(top: 15.0, right: 15, left: 15),
          child: TextField(
            controller: _controller,
            cursorColor: Config.primaryColor,
            textAlignVertical: TextAlignVertical.center,
            onChanged: (value) {
              setState(() {
                _loadDoctors(value);
              });
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16.0),
              hintText: 'Search Doctors...',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.grey),
              labelStyle: Theme.of(context).textTheme.bodySmall,
              prefixIcon: const Icon(
                Icons.search_rounded,
                size: 25,
              ),
              prefixIconColor: const Color.fromARGB(255, 136, 136, 136),
              border: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Config.primaryColor, width: 0),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Config.primaryColor, width: 0),
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Config.primaryColor, width: 0),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: Padding(
        //     padding:
        //         const EdgeInsets.only(right: 15, left: 15, bottom: 15, top: 15),
        //     child: Row(
        //       children: [
        //         CategoryButton(
        //           icon: FontAwesomeIcons.userDoctor,
        //           label: 'General',
        //         ),
        //         Config.spaceHorizontalSmall,
        //         CategoryButton(
        //           isActive: false,
        //           icon: FontAwesomeIcons.heartPulse,
        //           label: 'Cardiology',
        //         ),
        //         Config.spaceHorizontalSmall,
        //         CategoryButton(
        //           isActive: false,
        //           icon: FontAwesomeIcons.lungs,
        //           label: 'Respirations',
        //         ),
        //         Config.spaceHorizontalSmall,
        //         CategoryButton(
        //           isActive: false,
        //           icon: FontAwesomeIcons.hand,
        //           label: 'Dermatology',
        //         ),
        //         Config.spaceHorizontalSmall,
        //         CategoryButton(
        //           isActive: false,
        //           icon: FontAwesomeIcons.personPregnant,
        //           label: 'Gynecology',
        //         ),
        //         Config.spaceHorizontalSmall,
        //         CategoryButton(
        //           icon: FontAwesomeIcons.teeth,
        //           label: 'Dental',
        //           isActive: false,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        _doctorsList.isEmpty
            ? Text(
                'no doctors found..',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Config.primaryColor.withOpacity(0.75)),
              )
            : Expanded(
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
                    padding: EdgeInsets.only(top: 20),
                    itemCount: _doctorsList.length,
                    itemBuilder: (context, index) {
                      if (_isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (_doctorsList.isEmpty) {
                        return const Center(child: Text('No data available'));
                      }
                      final doctor = _doctorsList[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: DoctorCard(
                          doctor: Doctor(
                              id: doctor.id,
                              name: doctor['name'],
                              description: doctor['description'],
                              category:
                                  getCategoryFromString(doctor['category']),
                              dateJoin: DateTime.parse(doctor['date_join']),
                              rating: doctor['rating'],
                              imageUrl: doctor['image_url']),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ],
    );
  }
}
