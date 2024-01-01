import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todos/routes.dart';
import 'package:todos/utils/baseurl.dart';
import 'package:todos/utils/custom_snackbar.dart';
import 'package:todos/widgets/Loader.dart';
import 'package:http/http.dart' as http;

class SignupController extends GetxController {
  late TextEditingController nameController,
      contactController,
      addressController,
      emailController,
      passwordController,
      confirmPasswordController;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    nameController = TextEditingController();
    contactController = TextEditingController();
    addressController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    nameController.dispose();
    contactController.dispose();
    addressController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  checkSignup() {
    if (nameController.text.isEmpty) {
      customSnackbar("Error", "Name is required", "error");
    } else if (addressController.text.isEmpty) {
      customSnackbar("Error", "Address is required", "error");
    } else if (contactController.text.isEmpty) {
      customSnackbar("Error", "Address is required", "error");
    } else if (emailController.text.isEmpty ||
        GetUtils.isEmail(emailController.text) == false) {
      customSnackbar("Error", "A Valid email is required", "error");
    } else if (passwordController.text.isEmpty) {
      customSnackbar("Error", "Password is required", "error");
    } else if (passwordController.text != confirmPasswordController.text) {
      customSnackbar("Error", "Password doesnot match!", "error");
    } else {
      Get.showOverlay(
          asyncFunction: () => signup(), loadingWidget: const Loader());
    }
  }

  signup() async {
    var response = await http.post(Uri.parse(baseurl + 'signup.php'), body: {
      "name": nameController.text,
      "contact": contactController.text,    //get data from served based on url
      "address": addressController.text,
      "email": emailController.text,
      "password": passwordController.text,
    });

    var res = await json.decode(response.body);

    if (res['success']) {
      customSnackbar("Success", res['message'], "success");
      Get.offAllNamed(GetRoutes.login);
    } else {
      customSnackbar("Error", res['message'], "error");
    }
  }
}
