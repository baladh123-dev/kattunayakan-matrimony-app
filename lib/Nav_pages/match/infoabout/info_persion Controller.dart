import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class infopersionViewcontroller extends GetxController {
  final String docId = Get.arguments['docId'];

  RxString userName = ''.obs;
  RxString dob = ''.obs;
  RxString caste = ''.obs;
  RxString village = ''.obs;
  RxString marriageStatus = ''.obs;
  RxString profileImage = ''.obs;
  RxString phoneNumber = ''.obs;
  RxString gender = ''.obs;
  RxString fatherName = ''.obs;
  RxString motherName = ''.obs;
  RxString education = ''.obs;
  RxString description = ''.obs;
  RxInt likedYouCount = 0.obs;

  RxInt age = 0.obs; // 👈 NEW AGE VARIABLE

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
    print(likedYouCount.value);
  }

  Future<void> fetchProfile() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('userList')
          .doc(docId)
          .get();

      if (snapshot.exists) {
        var userData = snapshot.data() as Map<String, dynamic>;

        userName.value = userData['name'] ?? 'User';
        dob.value = userData['dob'] ?? '';
        caste.value = userData['caste'] ?? '';
        village.value = userData['village'] ?? '';
        marriageStatus.value = userData['marriageStatus'] ?? '';
        profileImage.value = userData['profileImageUrl'] ?? 'assets/default_avatar.png';
        phoneNumber.value = userData['phoneNumber'] ?? '';
        gender.value = userData['gender'] ?? '';
        fatherName.value = userData['fatherName'] ?? "";
        motherName.value = userData['motherName'] ?? "";
        education.value = userData['education'] ?? "";
        description.value = userData['description'] ?? "";
        likedYouCount.value = userData['numberOfLikes'] ?? 0;

        age.value = calculateAge(dob.value); // 👈 CALCULATE AGE
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // 👇 AGE CALCULATION METHOD
  int calculateAge(String dob) {
    try {
      late DateTime birthDate;

      // Format: dd/MM/yyyy
      if (dob.contains('/')) {
        final parts = dob.split('/');
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);
        birthDate = DateTime(year, month, day);
      }

      // Format: dd-MM-yyyy
      else if (dob.contains('-')) {
        final parts = dob.split('-');
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);
        birthDate = DateTime(year, month, day);
      }

      else {
        return 0;
      }

      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;

      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      return age;
    } catch (e) {
      print("Age Error → $e");
      return 0;
    }
  }

}
