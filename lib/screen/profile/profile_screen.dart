import 'package:e_health/providers/user_provider.dart';
import 'package:e_health/screen/auth/login_checker.dart';
import 'package:e_health/screen/profile/edit_profile_screen.dart';
import 'package:e_health/utils/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  void _showChangePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Change Your Password?',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        content: Text(
          'We will send the password change link to your email',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            style: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Config.primaryColor),
              padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          Ink(
            child: TextButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Config.backgroundColor),
                foregroundColor: WidgetStatePropertyAll(Config.primaryColor),
                padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
              ),
              onPressed: () {},
              child: const Text("Send"),
            ),
          ),
        ],
      ),
    );
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final _userData = ref.watch(userProvider);

    return SmartRefresher(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                // gradient: LinearGradient(
                //   colors: [Config.primaryColor, Color.fromARGB(255, 63, 226, 193)],
                // ),
                color: Config.primaryColor,
              ),
              child: Column(
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {},
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: _userData['image_url'].trim() != ''
                            ? NetworkImage(
                                _userData['image_url'],
                              )
                            : const AssetImage('assets/profile.jpg'),
                      ),
                    ),
                  ),
                  Config.spaceSmall,
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Center(
                      child: Text(
                        _userData['name'],
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 20, color: Config.backgroundColor),
                      ),
                    ),
                  ),
                  Config.spaceSmall,
                  Center(
                    child: Text(
                      '${_userData['age']} Years old',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Config.backgroundColor),
                    ),
                  ),
                ],
              ),
            ),
            Config.spaceSmall,
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.edit,
                          size: 15,
                          color: Config.primaryColor,
                        ),
                        Config.spaceHorizontalSmall,
                        Text(
                          'edit',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Config.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Email',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(_userData['email'],
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium!),
                      ],
                    ),
                    const Divider(
                      color: Config.backgroundColor,
                      thickness: 3,
                    ),
                    Config.spaceSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date of birth',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(_userData['formatted_birth_date'],
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium!),
                      ],
                    ),
                    const Divider(
                      color: Config.backgroundColor,
                      thickness: 3,
                    ),
                    Config.spaceSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Gender',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(_userData['gender'],
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium!),
                      ],
                    ),
                    const Divider(
                      color: Config.backgroundColor,
                      thickness: 3,
                    ),
                    Config.spaceSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Phone Number',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(_userData['phone'],
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium!),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Config.spaceMedium,
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Ink(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    _showChangePassword();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: Color.fromARGB(255, 213, 248, 241)),
                            child: const Icon(
                              Icons.lock_reset_rounded,
                              color: Config.primaryColor,
                            )),
                        Config.spaceHorizontalMedium,
                        Text(
                          'Reset Password',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Ink(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    _userData.clear();
                    if (!mounted) {
                      return;
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginChecker(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: Color.fromARGB(255, 238, 200, 200)),
                            child: const Icon(
                              Icons.logout,
                              color: Color.fromARGB(255, 160, 22, 22),
                            )),
                        Config.spaceHorizontalMedium,
                        Text(
                          'Log out',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
