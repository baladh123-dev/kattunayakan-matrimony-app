import 'dart:developer';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToHome();
  }

  // ====== FIXED FUNCTION WITH INTERNET CHECK ======
  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));

    // Check internet connectivity
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      log("NO INTERNET CONNECTION");
      log("Redirecting to: '/no-more-internet'");
      Get.offAllNamed('/no-more-internet');
      return;
    }

    log("INTERNET CONNECTED");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phone = prefs.getString("phone");

    if (phone != null && phone.isNotEmpty) {
      log("PHONE FOUND → $phone");
      log("Redirecting to: '/nav'");
      Get.offAllNamed('/nav');
    } else {
      log("PHONE NOT FOUND");
      log("Redirecting to: '/Login'");
      Get.offAllNamed('/Login');
    }
  }
}