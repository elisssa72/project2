import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todos/controllers/signup_controller.dart';
import 'package:todos/routes.dart';
import 'package:todos/widgets/custom_button.dart';
import 'package:todos/widgets/custom_textfield.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GetBuilder<SignupController>(builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'My TODO',
                  style: TextStyle(
                    fontSize: 54,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                hint: 'Name',
                controller: controller.nameController,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                hint: 'Address',
                controller: controller.addressController,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                hint: 'Contact',
                controller: controller.contactController,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                hint: 'Email',
                controller: controller.emailController,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                hint: 'Password',
                controller: controller.passwordController,
                obscureText: true,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                hint: 'Confirm Password',
                controller: controller.confirmPasswordController,
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                label: "Sign Up",
                onPressed: () {
                  controller.checkSignup();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: Color(0xff949494),
                  ),
                  children: [
                    const TextSpan(
                      text: 'Already have an account? ',
                    ),
                    TextSpan(
                      text: 'Login',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed(GetRoutes.login);
                        },
                      style: const TextStyle(
                        color: Color(0xff6b7afc),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                textHeightBehavior:
                    const TextHeightBehavior(applyHeightToFirstAscent: false),
                softWrap: false,
              )
            ],
          );
        }),
      ),
    ));
  }
}
