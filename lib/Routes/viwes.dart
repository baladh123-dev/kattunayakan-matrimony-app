import 'package:get/get.dart';
import 'package:matrimony/Nav_pages/home/home_controller.dart';
import 'package:matrimony/Nav_pages/home/home_view.dart';
import 'package:matrimony/Nav_pages/home/liked_users/liked_users_controller.dart';
import 'package:matrimony/Nav_pages/home/liked_users/liked_users_view.dart';
import 'package:matrimony/Nav_pages/match/infoabout/info_persion%20Controller.dart';
import 'package:matrimony/Nav_pages/match/infoabout/info_persion%20viwe.dart';
import 'package:matrimony/Nav_pages/match/match_list_controller.dart';
import 'package:matrimony/Nav_pages/match/match_list_view.dart';
import 'package:matrimony/Nav_pages/more/more_likes_controller.dart';
import 'package:matrimony/Nav_pages/more/more_likes_view.dart';
import 'package:matrimony/One_time_pages/Login/LoginController.dart';
import 'package:matrimony/One_time_pages/Login/LoginView.dart';
import 'package:matrimony/commanPages/Bottom%20Navigation%20Bar/nav_controller.dart';
import 'package:matrimony/commanPages/Bottom%20Navigation%20Bar/nav_view.dart';


import '../Nav_pages/home/privacy_policy/privacy_policy_controller.dart';
import '../Nav_pages/home/privacy_policy/privacy_policy_view.dart';
import '../Nav_pages/more/open_talk/open_talk_controller.dart';
import '../Nav_pages/more/open_talk/open_talk_view.dart';
import '../One_time_pages/Updated_Profile/Updated ProfileController.dart';
import '../One_time_pages/Updated_Profile/Updated ProfileView.dart';
import '../commanPages/No Internet/No Internet View.dart';
import '../commanPages/No Internet/No Internet.dart';
import '../commanPages/splash/splash_controller.dart';
import '../commanPages/splash/splash_view.dart' show SplashView;

class Routes {
  static final List<GetPage> routes = [
    GetPage(
        name: '/',
        page: () => SplashView(),
        binding: BindingsBuilder(() {
          Get.lazyPut<SplashController>(() => SplashController());
        })),

    GetPage(
        name: '/updateprofile',
        page: () => UpdateProfileView(),
        binding: BindingsBuilder(() {
          Get.lazyPut<UpdateProfileController>(() => UpdateProfileController());
        })),

    GetPage(
        name: '/Login',
        page: () => LoginView(),
        binding: BindingsBuilder(() {
          Get.lazyPut<LoginController>(() => LoginController());
        })),

    GetPage(
        name: '/nav',
        page: () => NavView(),
        binding: BindingsBuilder(() {
          Get.lazyPut<NavController>(() => NavController());
        })),

    GetPage(
        name: '/home',
        page: () => HomeView(),
        binding: BindingsBuilder(() {
          Get.lazyPut<HomeController>(() => HomeController());
        })),


    GetPage(
        name: '/LikedUsers',
        page: () => LikedUsersView(),
        binding: BindingsBuilder(() {
          Get.lazyPut<LikedUsersController>(() => LikedUsersController());
        })),

    GetPage(
        name: '/Match',
        page: () => MatchListView(),
        binding: BindingsBuilder(() {
          Get.lazyPut<MatchListController>(() => MatchListController());
        })),



    GetPage(
        name: '/persionINFO',
        page: () => infopersionView(),
        binding: BindingsBuilder(() {
          Get.lazyPut<infopersionViewcontroller>(() => infopersionViewcontroller());
        })),


    GetPage(
        name: '/likes',
        page: () => ChatListView(),
        binding: BindingsBuilder(() {
          Get.lazyPut<ChatListController>(() => ChatListController());
        })),


    GetPage(
        name: '/privacy_policy',
        page: () => PrivacyPolicyView(),
        binding: BindingsBuilder(() {
          Get.lazyPut<PrivacyPolicyController>(() => PrivacyPolicyController());
        })),

    GetPage(
        name: '/open_talk',
        page: () => OpenTalkView(),
        binding: BindingsBuilder(() {
          Get.lazyPut<OpenTalkController>(() => OpenTalkController());
        })),


    GetPage(
        name: '/no-more-intrnet',
        page: () => NoInternetView(),
        binding: BindingsBuilder(() {
          Get.lazyPut<NoInternetController>(() => NoInternetController());
        })),






  ];
}