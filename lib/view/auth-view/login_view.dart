import 'package:spotter/constant-widgets/constant_appbar.dart';
import 'package:spotter/constant-widgets/constant_button.dart';
import 'package:spotter/constant-widgets/constant_textfield.dart';
import 'package:spotter/constants/textstyles.dart';
import 'package:spotter/view-model/auth_view_model.dart';
import 'package:spotter/view/auth-view/forgot_password_view.dart';
import 'package:spotter/view/auth-view/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  ValueNotifier<bool> isChecked = ValueNotifier<bool>(false);
  ValueNotifier<bool> isPasswordVisible = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: const ConstantAppBar(text: 'Login'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50.r,
                    child: Image.asset(
                      'assets/images/icon.jpg',
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                Center(child: Text('Welcome to SPOTTER', style: kHead2Black)),
                SizedBox(height: Get.height * 0.1),
                ConstantTextField(
                  controller: emailController,
                  hintText: 'Email',
                  prefixIcon: Icons.email,
                ),
                SizedBox(height: Get.height * 0.03),
                ValueListenableBuilder(
                  valueListenable: isPasswordVisible,
                  builder: (ctx, value, child) {
                    return ConstantTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: !isPasswordVisible.value,
                      prefixIcon: Icons.lock,
                      suffixIcon: value == true
                          ? Icons.visibility
                          : Icons.visibility_off,
                      onTapSuffixIcon: () {
                        isPasswordVisible.value = !isPasswordVisible.value;
                      },
                    );
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.to(() => const ForgotPasswordView()),
                    child: Text('Forgot password?', style: kBody3Transparent),
                  ),
                ),
                SizedBox(height: Get.height * 0.025),
                ConstantButton(
                  buttonText: 'Login',
                  onTap: () {
                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: 'Please fill both the fields',
                      );
                      return;
                    } else {
                      authViewModel.loginUser(
                        context,
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('New user?', style: kBody2Black),
                    TextButton(
                      onPressed: () => Get.to(() => const SignUpView()),
                      child: Text('Register now', style: kBody2Transparent),
                    ),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Expanded(
                //       child: Divider(
                //         endIndent: Get.width * 0.02,
                //         thickness: 0.5,
                //         color: kBlack,
                //       ),
                //     ),
                //     Text(
                //       'OR',
                //       style: kBody3Black,
                //     ),
                //     Expanded(
                //       child: Divider(
                //         indent: Get.width * 0.02,
                //         thickness: 0.5,
                //         color: kBlack,
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: Get.height * 0.02,
                // ),
                // Center(
                //   child: Text(
                //     'Sign In using',
                //     style: kBody3Black,
                //   ),
                // ),
                // SizedBox(
                //   height: Get.height * 0.01,
                // ),
                // Center(child: Image.asset('assets/images/google.png')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
