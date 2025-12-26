import 'package:get/get.dart';
import 'package:matrimony/Nav_pages/home/home_controller.dart';
import 'package:matrimony/Nav_pages/home/liked_users/liked_users_controller.dart';
import 'package:matrimony/Nav_pages/match/infoabout/info_persion%20Controller.dart';
import 'package:matrimony/Nav_pages/more/more_likes_controller.dart';
import 'package:matrimony/One_time_pages/Login/LoginController.dart';
import 'package:matrimony/commanPages/Bottom%20Navigation%20Bar/nav_controller.dart';


import '../Nav_pages/home/privacy_policy/privacy_policy_controller.dart';
import '../One_time_pages/Updated_Profile/Updated ProfileController.dart';
import '../commanPages/No Internet/No Internet.dart';
import '../commanPages/splash/splash_controller.dart';

class MyBindings extends Bindings {
  @override
  void dependencies() {
    // Eager initialization of DatePickerController
    Get.lazyPut<SplashController>(() => SplashController());
    Get.lazyPut<UpdateProfileController>(() => UpdateProfileController());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<NavController>(() => NavController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ChatListController>(() => ChatListController());
    Get.lazyPut<infopersionViewcontroller>(() => infopersionViewcontroller());
    Get.lazyPut<LikedUsersController>(() => LikedUsersController());
    Get.lazyPut<PrivacyPolicyController>(() => PrivacyPolicyController());
    Get.lazyPut<NoInternetController>(() => NoInternetController());
  }
}
