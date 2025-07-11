import 'package:spotter/constant-widgets/constant_appbar.dart';
import 'package:spotter/constant-widgets/constant_button.dart';
import 'package:spotter/constant-widgets/constant_textfield.dart';
import 'package:spotter/constants/textstyles.dart';
import 'package:spotter/view-model/auth_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _LoginViewState();
}

class _LoginViewState extends State<ForgotPasswordView> {
  TextEditingController emailController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthViewModel>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: const ConstantAppBar(text: 'Forgot Password'),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.04,
            vertical: Get.height * 0.02,
          ),
          child: Column(
            children: [
              Center(child: Text('SPOTTER', style: kHead2GreyLight)),
              SizedBox(height: Get.height * 0.03),
              Center(child: Text('Forgot password!', style: kBody1Black)),
              Text(
                'Type your email and we shall send you an email to your account to reset password.',
                style: kBody2Black,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Get.height * 0.04),
              ConstantTextField(
                controller: emailController,
                hintText: 'Email',
                prefixIcon: Icons.email,
              ),
              SizedBox(height: Get.height * 0.04),
              ConstantButton(
                buttonText: 'Submit',
                onTap: () {
                  if (emailController.text.isNotEmpty) {
                    provider.resetPassword(emailController.text.trim());
                  } else {
                    Fluttertoast.showToast(msg: 'Please enter correct email');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
