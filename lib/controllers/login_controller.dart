import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:todos/models/user.dart';
import 'package:todos/routes.dart';
import 'package:todos/utils/baseurl.dart';
import 'package:todos/utils/custom_snackbar.dart';
import 'package:todos/utils/shared_prefs.dart';
import 'package:todos/widgets/Loader.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  late TextEditingController emailController, passwordController;

  @override
  void onInit() {   // initialize controllers
    // TODO: implement onInit
    super.onInit();
    checkUser();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  checkUser() async {
    var user = await SharedPrefs().getUser();
    if (user != null) {
      Get.offAllNamed(GetRoutes.home);  //check user and go home if available
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    emailController.dispose();
    passwordController.dispose();  //clean up
  }

  checkLogin() {
    if (emailController.text.isEmpty ||
        GetUtils.isEmail(emailController.text) == false) {
      customSnackbar("Error", "A Valid email is required", "error");   //check validation
    } else if (passwordController.text.isEmpty) {
      customSnackbar("Error", "Password is required", "error");
    } else {
      Get.showOverlay(
          asyncFunction: () => login(), loadingWidget: const Loader());
    }
  }

  login() async {
    var response = await http.post(Uri.parse(baseurl + 'login.php'), body: {  //send request based on url
      "email": emailController.text,
      "password": passwordController.text,
    });

    var res = await json.decode(response.body);   //decodes  the json data to dart since server respond using json

    if (res['success']) {
      customSnackbar("Success", res['message'], "success");
      User user = User.fromJson(res['user']);     //success
      await SharedPrefs().storeUser(json.encode(user));
      Get.offAllNamed(GetRoutes.home);
    } else {
      customSnackbar("Error", res['message'], "error");
    }
  }
}
