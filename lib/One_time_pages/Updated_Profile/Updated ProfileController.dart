import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileController extends GetxController {

  // Observable variables
  var name = ''.obs;
  var dob = ''.obs;
  var selectedCaste = ''.obs;
  var selectedVillage = ''.obs;
  var marriageStatus = ''.obs;
  var gender = ''.obs;
  var profileImage = Rxn<File>();

  // Firebase lists
  var casteList = <String>[].obs;
  var villageList = <String>[].obs;
  var isLoading = false.obs;

  // Error variables
  var nameError = ''.obs;
  var dobError = ''.obs;
  var casteError = ''.obs;
  var villageError = ''.obs;
  var marriageError = ''.obs;
  var genderError = ''.obs;

  // Text controller for name field
  final nameController = TextEditingController();

  // Phone number
  String phoneNumber = '';

  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    selectedVillage.value = '';
    if (Get.arguments != null) {
      phoneNumber = Get.arguments.toString();
    }

    fetchProfileLists();
    print(casteList);
    print(villageList);
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  // ============================
  // 🎭 Get default image path based on gender
  // ============================
  String getDefaultImagePath() {
    if (gender.value == "ஆண்") {
      return 'assets/male.png';
    } else if (gender.value == "பெண்") {
      return 'assets/female.png';
    }
    return ''; // No default if gender not selected
  }

  // ============================
  // 🔥 Fetch caste & village list
  // ============================
  Future<void> fetchProfileLists() async {
    try {
      isLoading(true);
      DocumentSnapshot doc = await _firestore
          .collection('general')
          .doc('profile')
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          var casteData = data['casteList'] ?? [];
          var villageData = data['villagelist'] ?? [];

          casteList.value = List<String>.from(casteData);
          villageList.value = List<String>.from(villageData);
        }
      }
    } finally {
      isLoading(false);
    }
  }

  // ============================
  // 📸 Pick image
  // ============================
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        profileImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ============================
  // 📅 Date picker
  // ============================
  Future<void> selectDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dob.value = DateFormat('dd/MM/yyyy').format(picked);
      dobError.value = '';
    }
  }

  // ============================
  // ✔ Form validation
  // ============================
  bool validateForm() {
    bool isValid = true;

    nameError.value = '';
    dobError.value = '';
    casteError.value = '';
    villageError.value = '';
    marriageError.value = '';
    genderError.value = '';

    if (name.value.trim().isEmpty) {
      nameError.value = 'Name is required';
      isValid = false;
    }

    if (dob.value.isEmpty) {
      dobError.value = 'DOB is required';
      isValid = false;
    }

    if (gender.value.isEmpty) {
      genderError.value = 'Please select gender';
      isValid = false;
    }

    if (selectedCaste.value.isEmpty) {
      casteError.value = 'Please select a caste';
      isValid = false;
    }

    if (selectedVillage.value.isEmpty) {
      villageError.value = 'Please select a village';
      isValid = false;
    }

    if (marriageStatus.value.isEmpty) {
      marriageError.value = 'Please select marriage status';
      isValid = false;
    }

    return isValid;
  }

  // ============================
  // ☁ Upload image to Firebase
  // ============================
  Future<String?> uploadImageToStorage() async {
    if (profileImage.value == null) {
      // Upload default image based on gender
      return getDefaultImagePath();
    }

    try {
      String fileName =
          '${phoneNumber}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      Reference storageRef =
      _storage.ref().child('profile_images/$fileName');

      UploadTask uploadTask = storageRef.putFile(profileImage.value!);

      TaskSnapshot snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // ============================
  // 💾 Save Profile
  // ============================
  Future<void> saveProfile() async {
    if (!validateForm()) {
      Get.snackbar(
        "Validation Error",
        "Please fill all required fields correctly",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()),
          barrierDismissible: false);

      String? imageUrl = await uploadImageToStorage();

      Map<String, dynamic> data = {
        'name': name.value.trim(),
        'dob': dob.value,
        'gender': gender.value,
        'caste': selectedCaste.value,
        'village': selectedVillage.value,
        'marriageStatus': marriageStatus.value,
        'phoneNumber': phoneNumber,
        'profileImageUrl': imageUrl ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      };

      String docId =
      phoneNumber.replaceAll('+91', '').replaceAll(' ', '').trim();

      await _firestore
          .collection('userList')
          .doc(docId)
          .set(data, SetOptions(merge: true));

      Get.back(); // close loader
      // Save local
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("phone", phoneNumber);
      Get.snackbar(
        "Success",
        "Profile saved successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAllNamed('/nav');
    } catch (e) {
      if (Get.isDialogOpen!) Get.back();

      Get.snackbar(
        "Error",
        "Failed to save profile: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}