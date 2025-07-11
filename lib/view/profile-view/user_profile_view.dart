import 'package:spotter/constant-widgets/constant_appbar.dart';
import 'package:spotter/constant-widgets/constant_textfield.dart';
import 'package:spotter/constants/colors.dart';
import 'package:spotter/constants/textstyles.dart';
import 'package:spotter/view-model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(
      context,
      listen: false,
    );
    return SafeArea(
      child: Scaffold(
        appBar: const ConstantAppBar(text: 'ProfileView'),
        body: StreamBuilder(
          stream: profileViewModel.getUserData(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: SpinKitCircle(color: kBlack));
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No user data', style: kHead2Black));
            } else {
              return Consumer<ProfileViewModel>(
                builder: (context, value, child) {
                  final profileModel = snapshot.data!;
                  nameController.text = profileModel.name;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.02,
                      vertical: Get.height * 0.02,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              value.image != null
                                  ? CircleAvatar(
                                      radius: 35.r,
                                      backgroundImage: FileImage(value.image!),
                                    )
                                  : CircleAvatar(
                                      radius: 35.r,
                                      backgroundImage: NetworkImage(
                                        profileModel.profileImage ??
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnme6H9VJy3qLGvuHRIX8IK4jRpjo_xUWlTw&usqp=CAU',
                                      ),
                                    ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () => profileViewModel.pickImage(),
                                  child: profileViewModel.isUpload
                                      ? SpinKitCircle(size: 24.r, color: kBlack)
                                      : const Icon(Icons.camera_alt),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Get.height * 0.04),
                        ListTile(
                          tileColor: constantColor,
                          title: Text('Name', style: kBody1Black),
                          subtitle: Text(profileModel.name, style: kBody2Black),
                          trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text('Update', style: kBody1Black),
                                    actions: [
                                      ConstantTextField(
                                        controller: nameController,
                                        hintText: '',
                                        prefixIcon: Icons.person,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () => Get.back(),
                                            child: Text(
                                              'Cancel',
                                              style: kBody2Black,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              profileViewModel.updateName(
                                                nameController.text.trim(),
                                              );
                                              Future.delayed(
                                                const Duration(
                                                  milliseconds: 200,
                                                ),
                                                () {
                                                  setState(() {});
                                                },
                                              );
                                            },
                                            child: Text(
                                              'Update',
                                              style: kBody2Black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                        SizedBox(height: Get.height * 0.02),
                        ListTile(
                          tileColor: constantColor,
                          title: Text('Email', style: kBody1Black),
                          subtitle: Text(
                            snapshot.data!.email,
                            style: kBody2Black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }),
        ),
      ),
    );
  }
}
