import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var phone = "".obs;
  var otp = "".obs;
  var showOtpField = false.obs;
  var isLoading = false.obs;

  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String verificationId = "";

  @override
  void onInit() {
    super.onInit();
    loadSavedPhone();
  }

  // ========== LOAD SAVED PHONE NUMBER ==========
  Future<void> loadSavedPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPhone = prefs.getString("phone");

    if (savedPhone != null && savedPhone.isNotEmpty) {
      phone.value = savedPhone;
      phoneController.text = savedPhone;
    }
  }

  // ========== PHONE INPUT ==========
  void onPhoneChanged(String value) {
    phone.value = value;
  }

  // ========== OTP INPUT ==========
  void onOtpChanged(String value) {
    otp.value = value;
  }

  Future<void> sendOtp() async {
    if (phone.value.length != 10) {
      Get.snackbar("Invalid", "Enter 10 digit number");
      return;
    }

    isLoading.value = true;
    String number = "+91${phone.value}";

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: number,
        timeout: const Duration(seconds: 60),

        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value) async {
            if (value.user != null) {
              return 'success';
            } else {
              return 'error in otp login';
            }
          });
        },

        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar("Error", e.message ?? "OTP Failed",
              backgroundColor: Colors.red, colorText: Colors.white);
        },

        codeSent: (String verId, int? resendToken) {
          verificationId = verId;
          showOtpField.value = true;

          Get.snackbar("OTP Sent", "OTP sent to $number",
              backgroundColor: Colors.green, colorText: Colors.white);
        },

        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
      );
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    }

    // WAIT 3 SECONDS BEFORE HIDING LOADING
    await Future.delayed(const Duration(seconds: 3));

    isLoading.value = false;
  }

  // ========== VERIFY OTP ==========
  Future<void> submitOtp() async {
    isLoading.value = true;

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp.value,
      );

      // Login success
      await auth.signInWithCredential(credential);

      // Now check Firestore user
      await checkUserExist();
    } catch (e) {
      Get.snackbar(
        "Invalid OTP",
        "Please check your code",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    isLoading.value = false;
  }

  // ========== CHECK IF USER EXISTS IN FIRESTORE ==========
  Future<void> checkUserExist() async {
    String docId = phone.value; // Phone number as docId

    DocumentSnapshot userDoc =
    await firestore.collection("userList").doc(docId).get();

    if (userDoc.exists) {
      // ✅ EXISTING USER - SAVE PHONE NUMBER
      await savePhoneNumber(phone.value);

      Get.snackbar("Welcome Back!", "Login Successful",
          backgroundColor: Colors.green, colorText: Colors.white);

      // Navigate to HOME NAVIGATION
      Get.toNamed('/nav', arguments: docId);
    } else {
      // ❌ NEW USER - DON'T SAVE PHONE NUMBER YET
      Get.snackbar("New User", "Please complete profile",
          backgroundColor: Colors.blue, colorText: Colors.white);

      // Navigate to PROFILE UPDATE
      Get.toNamed('/updateprofile', arguments: phone.value);
    }
  }

  // ========== SAVE PHONE NUMBER TO SHARED PREFERENCES ==========
  Future<void> savePhoneNumber(String phoneNumber) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("phone", phoneNumber);
      print("✅ Phone number saved: $phoneNumber");
    } catch (e) {
      print("❌ Error saving phone number: $e");
    }
  }

  // ========== CLEAR SAVED PHONE NUMBER (FOR LOGOUT) ==========
  Future<void> clearSavedPhone() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove("phone");
      phone.value = "";
      phoneController.clear();
      print("✅ Phone number cleared");
    } catch (e) {
      print("❌ Error clearing phone number: $e");
    }
  }
}