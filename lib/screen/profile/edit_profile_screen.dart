import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_health/providers/user_provider.dart';
import 'package:e_health/screen/profile/profile_image_picker.dart';
import 'package:e_health/utils/config.dart';
import 'package:e_health/widget/button/large_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _enteredName = '';
  File? _selectedImage;
  bool _isLoading = false;

  String _enteredPhone = '';
  late DateTime _enteredBirthDate;
  late String _selectedGender;
  final _currentUser = FirebaseAuth.instance.currentUser!;

  void _updateProfile() async {
    final _userData = ref.watch(userProvider);
    bool isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child("${_currentUser.uid}.jpg");
    String imageUrl = _userData['image_url'];
    setState(() {
      _isLoading = true;
    });

    try {
      if (_selectedImage != null) {
        await storageRef.putFile(_selectedImage!);
        imageUrl = await storageRef.getDownloadURL();
      }
      ref.watch(userProvider.notifier).setUser(
          name: _enteredName,
          email: _currentUser.email!,
          gender: _selectedGender,
          birthDate: _enteredBirthDate,
          imageUrl: imageUrl,
          phone: _enteredPhone);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser.uid)
          .update(
        {
          'name': _enteredName,
          'phone': _enteredPhone,
          'image_url': imageUrl,
          'birth_date': _enteredBirthDate.toString(),
          'gender': _selectedGender
        },
      );

      setState(() {
        _isLoading = false;
      });
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Success!',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Config.backgroundColor),
          ),
          showCloseIcon: true,
        ),
      );
    } catch (error) {
      print(error);
    }

    setState(() {
      _isLoading = false;
    });
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
    _enteredBirthDate = _userData['birth_date'];
    _selectedGender = _userData['gender'];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton.filledTonal(
            onPressed: () {
              Navigator.pop(context);
            },
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Config.primaryColor),
            ),
            color: Colors.white,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
            )),
        backgroundColor: Config.backgroundColor,
        scrolledUnderElevation: 0,
        toolbarHeight: 50,
        title: Text(
          'Edit Profile',
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
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ProfileImagePicker(onSelectImage: (image) {
                          _selectedImage = image;
                        }),
                        Config.spaceBig,
                        TextFormField(
                          enabled: false,
                          initialValue: _userData['email'],
                          cursorColor: Config.primaryColor,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            contentPadding: const EdgeInsets.all(16.0),
                            hintText: 'Email Address',
                            labelText: 'Email',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.grey),
                            alignLabelWithHint: true,
                            prefixIcon: const Icon(Icons.email_outlined),
                            prefixIconColor: Config.primaryColor,
                            border: Config.outlinedBorder,
                            focusedBorder: Config.focusBorder,
                          ),
                        ),
                        Config.spaceSmall,
                        TextFormField(
                          initialValue: _userData['name'],
                          cursorColor: Config.primaryColor,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            suffixIcon: const Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.grey,
                            ),
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            contentPadding: const EdgeInsets.all(16.0),
                            hintText: 'Name',
                            labelText: 'Name',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.grey),
                            alignLabelWithHint: true,
                            prefixIcon: const Icon(Icons.email_outlined),
                            prefixIconColor: Config.primaryColor,
                            border: Config.outlinedBorder,
                            focusedBorder: Config.focusBorder,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'please fill this field';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredName = newValue!;
                          },
                        ),
                        Config.spaceSmall,
                        TextFormField(
                          initialValue: _userData['phone'],
                          cursorColor: Config.primaryColor,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            suffixIcon: const Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.grey,
                            ),
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            contentPadding: const EdgeInsets.all(16.0),
                            hintText: 'Phone Number',
                            labelText: 'Phone Number',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.grey),
                            alignLabelWithHint: true,
                            prefixIcon: const Icon(Icons.email_outlined),
                            prefixIconColor: Config.primaryColor,
                            border: Config.outlinedBorder,
                            focusedBorder: Config.focusBorder,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'please fill this field';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredPhone = newValue!;
                          },
                        ),
                        Config.spaceSmall,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date of birth',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: TimePickerSpinnerPopUp(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12.5),
                                    mode: CupertinoDatePickerMode.date,
                                    maxTime: DateTime.now(),
                                    initTime: _userData['birth_date'],
                                    onChange: (dateTime) {
                                      _enteredBirthDate = dateTime;
                                    },
                                  ),
                                )
                              ],
                            ),
                            Config.spaceHorizontalMedium,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gender',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  height: 50,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color:
                                        Config.backgroundColor.withOpacity(0),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField2(
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'please fill this field';
                                        }
                                        return null;
                                      },
                                      value: _selectedGender,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 0),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 0.5,
                                              color: Color.fromARGB(
                                                  255, 149, 149, 149)),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 0.9,
                                              color: Color.fromARGB(
                                                  255, 149, 149, 149)),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 0.9,
                                              color: Config.primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      items: ['male', 'female']
                                          .map(
                                            (value) => DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        if (value == null) {
                                          return;
                                        }
                                        setState(
                                          () {
                                            _selectedGender = value;
                                          },
                                        );
                                      },
                                      onSaved: (value) {
                                        _selectedGender = value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Config.spaceMedium,
                        LargeButton(
                          onPressed: () {
                            _updateProfile();
                          },
                          label: 'Update',
                          backgroundColor: Config.primaryColor,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
