import 'package:get/get.dart';
import 'package:todos/screens/auth/login_screen.dart';
import 'package:todos/screens/auth/signup_screen.dart';
import 'package:todos/screens/home/home_screen.dart';

class GetRoutes {
  static const String login = "/login";
  static const String signup = "/signup";
  static const String home = "/home";

  static List<GetPage> routes = [
    GetPage(
      name: GetRoutes.login,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: GetRoutes.signup,
      page: () => SignupScreen(),
    ),
    GetPage(
      name: GetRoutes.home,
      page: () => HomeScreen(),
    ),
  ];
}
