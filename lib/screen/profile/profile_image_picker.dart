import 'dart:io';
import 'package:e_health/providers/user_provider.dart';
import 'package:e_health/utils/config.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends ConsumerStatefulWidget {
  const ProfileImagePicker({super.key, required this.onSelectImage});
  final void Function(File image) onSelectImage;

  @override
  ConsumerState<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends ConsumerState<ProfileImagePicker> {
  File? _selectedImage;

  void _pickImage(ImageSource source) async {
    final pickedImage =
        await ImagePicker().pickImage(source: source, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
    widget.onSelectImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    final _userData = ref.watch(userProvider);
    var _userImage = _userData['image_url'];
    return Center(
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.height * 0.15,
            height: MediaQuery.of(context).size.height * 0.15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: _selectedImage != null
                  ? Image.file(_selectedImage!, fit: BoxFit.cover)
                  : _userImage != ''
                      ? Image.network(_userImage, fit: BoxFit.cover)
                      : Image.asset('assets/profile.jpg', fit: BoxFit.cover),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.height * 0.05,
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 78, 190, 168),
                borderRadius: BorderRadius.circular(25),
              ),
              child: PopupMenuButton<ImageSource>(
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem(
                      value: ImageSource.camera,
                      child: Row(
                        children: [
                          Icon(Icons.camera_alt_rounded),
                          Config.spaceHorizontalSmall,
                          Text('Camera'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: ImageSource.gallery,
                      child: Row(
                        children: [
                          Icon(Icons.image),
                          Config.spaceHorizontalSmall,
                          Text('Gallery'),
                        ],
                      ),
                    ),
                  ];
                },
                onSelected: (source) async {
                  _pickImage(source);
                },
                child: const Icon(
                  Icons.camera_alt,
                  size: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
