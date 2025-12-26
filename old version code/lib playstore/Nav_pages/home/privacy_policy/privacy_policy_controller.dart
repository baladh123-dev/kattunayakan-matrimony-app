import 'package:get/get.dart';

class PrivacyPolicyController extends GetxController {
  RxBool isLoading = false.obs;

  // In case you want future features like loading from API
  void loadPolicy() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    isLoading.value = false;
  }
}
