import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  // Profile Data
  RxString userName = "".obs;
  RxString userAge = "".obs;
  RxString phoneNumber = "".obs;
  RxString gender = ''.obs;

  // Profile Image
  RxString profileImage = "".obs;
  RxString fatherName = "".obs;
  RxString motherName = "".obs;
  RxString education = "".obs;
  RxString description = "".obs;

  // People who liked you
  RxInt likedYouCount = 0.obs;

  // Edit modes
  var isProfileEditMode = false.obs;
  var isEditMode = false.obs;
  DateTime? selectedDateOfBirth;

  // Additional user data
  RxString dob = "".obs;
  RxString caste = "".obs;
  RxString village = "".obs;
  RxString marriageStatus = "".obs;
  File? selectedFile;
  final ImagePicker picker = ImagePicker();
  var casteList = <String>[].obs;
  var villageList = <String>[].obs;
  // Edit mode
  RxBool isEditing = false.obs;
  RxBool isUploadingImage = false.obs; // NEW: Track upload state

  // Text Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController userAgeController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Loading state
  RxBool isLoading = true.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    _initializeControllers();
    fetchProfileLists();
  }


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


  @override
  void onClose() {
    // Dispose all controllers
    nameController.dispose();

    dobController.dispose();
    userAgeController.dispose();
    fatherNameController.dispose();
    motherNameController.dispose();
    educationController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void _initializeControllers() {
    fatherNameController.text = fatherName.value;
    motherNameController.text = motherName.value;
    educationController.text = education.value;
    descriptionController.text = description.value;
  }

  void changemode() {
    isProfileEditMode.value = !isProfileEditMode.value;
  }

  void changemode2() {
    isEditMode.value = !isEditMode.value;
  }

  // ✅ NEW: Delete old profile image from Firebase Storage
// ⭐ Correct delete using Firebase's refFromURL
  Future<void> deleteOldProfileImage(String oldImageUrl) async {
    try {
      // Skip if empty or invalid URL
      if (oldImageUrl.isEmpty || !oldImageUrl.contains("firebase")) {
        print("⚠️ No valid old image URL to delete");
        return;
      }

      print("🗑️ Attempting to delete old image: $oldImageUrl");

      // Use refFromURL - it's the most reliable method
      final ref = FirebaseStorage.instance.refFromURL(oldImageUrl);

      // Try to delete
      await ref.delete();
      print("✅ Old profile image deleted successfully");

    } catch (e) {
      // Handle specific errors gracefully
      String errorMessage = e.toString().toLowerCase();

      if (errorMessage.contains('object-not-found') ||
          errorMessage.contains('404') ||
          errorMessage.contains('does not exist')) {
        print("⚠️ Old image doesn't exist (already deleted or never uploaded)");
      } else if (errorMessage.contains('unauthorized') ||
          errorMessage.contains('permission')) {
        print("❌ Permission denied to delete old image");
      } else {
        print("❌ Unexpected error deleting old image: $e");
      }
      // Don't throw - just log and continue
    }
  }
  // ✅ UPDATED: Pick and upload profile image with old image deletion
// ✅ FIXED: Upload image with proper error handling
  Future<void> pickAndUploadProfileImage() async {
    try {
      // Pick image
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) {
        print("📷 Image selection cancelled");
        return;
      }

      // Start loading
      isUploadingImage.value = true;

      // Get user phone
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedPhone = prefs.getString("phone");

      if (savedPhone == null || savedPhone.isEmpty) {
        isUploadingImage.value = false;
        Get.snackbar(
          "Error",
          "User not found. Please login again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Generate document ID
      String docId = savedPhone.replaceAll('+91', '').replaceAll(' ', '').trim();

      // Store old image URL BEFORE upload
      String oldImageUrl = profileImage.value;

      print("📤 Starting upload for user: $docId");

      // Create unique file path with timestamp to avoid conflicts
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String filePath = "profileImages/$docId/profile_$timestamp.jpg";

      print("📁 Upload path: $filePath");

      // Create reference and file
      Reference ref = FirebaseStorage.instance.ref(filePath);
      File imageFile = File(image.path);

      // ✅ UPLOAD NEW IMAGE FIRST
      print("⬆️ Uploading new image...");
      UploadTask uploadTask = ref.putFile(imageFile);

      // Wait for completion
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {
        print("✅ Upload completed");
      });

      // Get download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("🔗 Download URL obtained: $downloadUrl");

      // ✅ UPDATE FIRESTORE WITH NEW URL
      print("💾 Updating Firestore...");
      await FirebaseFirestore.instance
          .collection('userList')
          .doc(docId)
          .update({"profileImageUrl": downloadUrl});

      print("✅ Firestore updated");

      // ✅ NOW DELETE OLD IMAGE (only after successful upload)
      if (oldImageUrl.isNotEmpty &&
          oldImageUrl != downloadUrl &&
          oldImageUrl.contains("firebase")) {
        print("🗑️ Deleting old image...");
        await deleteOldProfileImage(oldImageUrl);
      } else {
        print("⚠️ No old image to delete or same URL");
      }

      // Update local state
      profileImage.value = downloadUrl;
      isUploadingImage.value = false;

      // Show success message
      Get.snackbar(
        "Success",
        "Profile image updated successfully! ✓",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      print("🎉 Image upload process completed successfully");

    } catch (e) {
      // Stop loading
      isUploadingImage.value = false;

      // Log detailed error
      print("❌ Image upload error: $e");
      print("❌ Error type: ${e.runtimeType}");

      // User-friendly error message
      String errorMessage = "Failed to upload image";

      if (e.toString().contains('permission')) {
        errorMessage = "Permission denied. Check Firebase Storage rules";
      } else if (e.toString().contains('network')) {
        errorMessage = "Network error. Check your connection";
      } else if (e.toString().contains('quota')) {
        errorMessage = "Storage quota exceeded";
      }

      Get.snackbar(
        "Upload Failed",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  Future<void> saveAllProfileChanges() async {
    // Validate gender
    if (gender.isNotEmpty && gender != "ஆண்" && gender != "பெண்") {
      Get.snackbar(
        "Error",
        "Please enter only ஆண் or பெண்",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await updateBasicInfo(
      name: nameController.text,
      caste: caste.value,
      village: village.value,
      marriageStatus: marriageStatus.value,
      gender: gender.value,
      dob: dobController.text,
      age: userAgeController.text,
    );
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedPhone = prefs.getString("phone");

      if (savedPhone == null || savedPhone.isEmpty) {
        Get.offAllNamed("/");
        return;
      }

      phoneNumber.value = savedPhone;
      String docId = savedPhone.replaceAll('+91', '').replaceAll(' ', '').trim();

      await fetchUserDataFromFirebase(docId);

    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserDataFromFirebase(String docId) async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('userList')
          .doc(docId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        userName.value = userData['name'] ?? 'User';
        dob.value = userData['dob'] ?? '';
        caste.value = userData['caste'] ?? '';
        village.value = userData['village'] ?? '';
        marriageStatus.value = userData['marriageStatus'] ?? '';
        profileImage.value = userData['profileImageUrl'] ?? '';
        phoneNumber.value = userData['phoneNumber'] ?? phoneNumber.value;
        gender.value = userData['gender'] ?? '';
        fatherName.value = userData['fatherName'] ?? "";
        motherName.value = userData['motherName'] ?? "";
        education.value = userData['education'] ?? "";
        description.value = userData['description'] ?? "";
        likedYouCount.value = userData['numberOfLikes'] ?? 0;

        if (dob.value.isNotEmpty) {
          int calculatedAge = calculateAge(dob.value);
          userAge.value = calculatedAge.toString();
          userAgeController.text = calculatedAge.toString();
        }
        nameController.text = userName.value;
        dobController.text = dob.value;



        print('User data loaded successfully');
      } else {
        print('User document does not exist');
        Get.snackbar(
          'Notice',
          'Profile not found. Please complete your profile.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error fetching user data from Firebase: $e');
      throw e;
    }
  }

  int calculateAge(String dobString) {
    try {
      List<String> parts = dobString.split('/');
      if (parts.length != 3) return 0;

      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);

      DateTime birthDate = DateTime(year, month, day);
      DateTime today = DateTime.now();

      int age = today.year - birthDate.year;

      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      return age;
    } catch (e) {
      print('Error calculating age: $e');
      return 0;
    }
  }

  String formatDateForFirebase(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return '$day/$month/$year';
  }

  void updateDateOfBirth(DateTime date) {
    String formattedDate = formatDateForFirebase(date);
    dob.value = formattedDate;
    dobController.text = formattedDate;

    int calculatedAge = calculateAge(formattedDate);
    userAge.value = calculatedAge.toString();
  }



  Future<void> updateBasicInfo({
    String? name,
    String? caste,
    String? village,
    String? marriageStatus,
    String? gender,
    String? dob,
    String? age,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedPhone = prefs.getString("phone");

      if (savedPhone == null || savedPhone.isEmpty) {
        Get.snackbar('Error', 'User not found');
        return;
      }

      String docId = savedPhone.replaceAll('+91', '').replaceAll(' ', '').trim();

      Map<String, dynamic> updateData = {};

      if (name != null && name.isNotEmpty) updateData['name'] = name;
      if (caste != null && caste.isNotEmpty) updateData['caste'] = caste;
      if (village != null && village.isNotEmpty) updateData['village'] = village;
      if (marriageStatus != null && marriageStatus.isNotEmpty) updateData['marriageStatus'] = marriageStatus;
      if (gender != null && gender.isNotEmpty) updateData['gender'] = gender;
      if (dob != null && dob.isNotEmpty) updateData['dob'] = dob;

      if (updateData.isEmpty) {
        Get.snackbar(
          'Notice',
          'No changes to update',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      await _firestore.collection('userList').doc(docId).update(updateData);
      await loadUserData();

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
      );

    } catch (e) {
      print("Error updating basic info: $e");
    }
  }

  Future<void> updateProfileDetails({
    required String fatherName,
    required String motherName,
    required String education,
    required String description,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedPhone = prefs.getString("phone");

      if (savedPhone == null || savedPhone.isEmpty) {
        Get.snackbar('Error', 'User not found');
        return;
      }

      String docId = savedPhone.replaceAll('+91', '').replaceAll(' ', '').trim();

      Map<String, dynamic> updateData = {};

      if (fatherName.isNotEmpty) updateData['fatherName'] = fatherName;
      if (motherName.isNotEmpty) updateData['motherName'] = motherName;
      if (education.isNotEmpty) updateData['education'] = education;
      if (description.isNotEmpty) updateData['description'] = description;

      if (updateData.isEmpty) {
        Get.snackbar(
          'Notice',
          'No changes to update',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      await _firestore.collection('userList').doc(docId).update(updateData);
      await loadUserData();

      Get.snackbar(
        'Success',
        'Updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD4145A),
        colorText: Colors.white,
      );

    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  Future<void> refreshUserData() async {
    await loadUserData();
  }

  void updateProfileImage(String newPath) {
    profileImage.value = newPath;
  }

  void updateUserName(String name) {
    userName.value = name;
  }

  void updateUserAge(String age) {
    userAge.value = age;
  }

  void updatePhoneNumber(String phone) {
    phoneNumber.value = phone;
  }

  Future<void> logout() async {
    try {
      bool? confirmed = await Get.dialog<bool>(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4145A),
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove("phone");
        await prefs.clear();

        Get.offAllNamed("/");

        Get.snackbar(
          'Success',
          'Logged out successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFD4145A),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error during logout: $e');
    }
  }


// ✅ FIXED: Delete account with proper image cleanup
  Future<void> deleteAccount() async {
    try {
      // Get user confirmation first
      bool? confirmed = await Get.dialog<bool>(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Delete Account',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: const Text(
            'Are you sure you want to permanently delete your account? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      // Get user data
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedPhone = prefs.getString("phone");

      if (savedPhone == null || savedPhone.isEmpty) {
        Get.snackbar('Error', 'User not found');
        return;
      }

      String docId = savedPhone.replaceAll('+91', '').replaceAll(' ', '').trim();

      // Show loading
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFD4145A),
          ),
        ),
        barrierDismissible: false,
      );

      print("🗑️ Starting account deletion for: $docId");

      // ✅ Delete profile image if exists
      if (profileImage.value.isNotEmpty) {
        print("🗑️ Deleting profile image...");
        await deleteOldProfileImage(profileImage.value);
      }

      // ✅ Delete all images in user's folder (if any extras exist)
      try {
        final userFolderRef = FirebaseStorage.instance.ref("profileImages/$docId");
        final listResult = await userFolderRef.listAll();

        print("📁 Found ${listResult.items.length} files to delete");

        for (var item in listResult.items) {
          try {
            await item.delete();
            print("✅ Deleted: ${item.fullPath}");
          } catch (e) {
            print("⚠️ Failed to delete ${item.fullPath}: $e");
          }
        }
      } catch (e) {
        print("⚠️ Error cleaning up storage folder: $e");
      }

      // ✅ Delete Firestore document
      print("🗑️ Deleting Firestore document...");
      await FirebaseFirestore.instance
          .collection('userList')
          .doc(docId)
          .delete();

      // ✅ Clear local storage
      await prefs.clear();

      // Close loading dialog
      Get.back();

      // Navigate to login
      Get.offAllNamed("/");

      // Show success message
      Get.snackbar(
        'Success',
        'Account deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      print("✅ Account deletion completed");

    } catch (e) {
      // Close loading if open
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      print('❌ Error deleting account: $e');

      Get.snackbar(
        'Error',
        'Failed to delete account. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }
}