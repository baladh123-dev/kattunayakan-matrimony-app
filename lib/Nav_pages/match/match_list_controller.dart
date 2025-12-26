import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchListController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxString selectedGender = "Female".obs;
  RxString searchQuery = ''.obs;

  RxList<Map<String, dynamic>> femaleList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> maleList = <Map<String, dynamic>>[].obs;
  RxString gender = ''.obs;
  RxString phoneNumber = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;

  // Pagination variables
  static const int pageSize = 20; // Load 20 users at a time
  DocumentSnapshot? lastFemaleDoc;
  DocumentSnapshot? lastMaleDoc;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  // -------------------------------
  // REFRESH
  // -------------------------------
  Future<void> refreshData() async {
    // Reset pagination
    lastFemaleDoc = null;
    lastMaleDoc = null;
    hasMoreData.value = true;
    femaleList.clear();
    maleList.clear();

    await fetchUserList();
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

      // Fetch initial user list with pagination
      await fetchUserList();

    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserDataFromFirebase(String docId) async {
    DocumentSnapshot userDoc = await _firestore
        .collection('userList')
        .doc(docId)
        .get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      gender.value = userData['gender'] ?? '';

      if (gender.value == 'ஆண்') {
        selectedGender.value = "Female";
      } else if (gender.value == 'பெண்') {
        selectedGender.value = "Male";
      }

      print('User data loaded successfully');
      print('Current user gender: ${gender.value}');
      print('Showing list: ${selectedGender.value}');
    }
  }

  // -------------------------------
  // FETCH USER LIST WITH PAGINATION
  // -------------------------------
  Future<void> fetchUserList({bool loadMore = false}) async {
    try {
      if (loadMore) {
        if (!hasMoreData.value) return;
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
      }

      print("\n============================");
      print(loadMore ? "LOADING MORE USERS" : "FETCHING USER LIST");
      print("============================\n");

      // Fetch females
      await _fetchGenderList(
        gender: 'பெண்',
        list: femaleList,
        lastDoc: lastFemaleDoc,
        loadMore: loadMore,
        onLastDocUpdate: (doc) => lastFemaleDoc = doc,
      );

      // Fetch males
      await _fetchGenderList(
        gender: 'ஆண்',
        list: maleList,
        lastDoc: lastMaleDoc,
        loadMore: loadMore,
        onLastDocUpdate: (doc) => lastMaleDoc = doc,
      );

      print("======================================");
      print("TOTAL FEMALES: ${femaleList.length}");
      print("TOTAL MALES  : ${maleList.length}");
      print("======================================\n");

    } catch (e) {
      print("❌ Error fetching user list: $e");
      Get.snackbar("Error", "Failed to fetch user list");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> _fetchGenderList({
    required String gender,
    required RxList<Map<String, dynamic>> list,
    required DocumentSnapshot? lastDoc,
    required bool loadMore,
    required Function(DocumentSnapshot?) onLastDocUpdate,
  }) async {
    Query query = _firestore
        .collection('userList')
        .where('gender', isEqualTo: gender)
        .limit(pageSize);

    // If loading more, start after last document
    if (loadMore && lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isEmpty) {
      hasMoreData.value = false;
      return;
    }

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
      userData['docId'] = doc.id;

      // Calculate age
      int age = calculateAge(userData['dob']);
      userData['age'] = age;

      list.add(userData);
    }

    // Update last document for pagination
    if (querySnapshot.docs.isNotEmpty) {
      onLastDocUpdate(querySnapshot.docs.last);
    }

    // Check if there's more data
    if (querySnapshot.docs.length < pageSize) {
      hasMoreData.value = false;
    }
  }

  // Call this when user scrolls to bottom
  Future<void> loadMoreUsers() async {
    if (!isLoadingMore.value && hasMoreData.value) {
      await fetchUserList(loadMore: true);
    }
  }

  // -------------------------------
  // SEARCH FUNCTIONALITY
  // -------------------------------
  void updateSearchQuery(String query) {
    searchQuery.value = query.toLowerCase().trim();
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  // -------------------------------
  // GET MATCHED LIST WITH SEARCH FILTER
  // -------------------------------
  List<Map<String, dynamic>> get matchedList {
    List<Map<String, dynamic>> baseList =
    selectedGender.value == "Female" ? femaleList : maleList;

    if (searchQuery.value.isEmpty) {
      return baseList;
    }

    return baseList.where((person) {
      String name = person['name']?.toString().toLowerCase() ?? '';
      String caste = person['caste']?.toString().toLowerCase() ?? '';
      String village = person['village']?.toString().toLowerCase() ?? '';
      String age = person['age']?.toString() ?? '';

      return name.contains(searchQuery.value) ||
          caste.contains(searchQuery.value) ||
          village.contains(searchQuery.value) ||
          age.contains(searchQuery.value);
    }).toList();
  }

  void changeGender(String gender) {
    selectedGender.value = gender;
    clearSearch();
  }

  // -------------------------------
  // AGE CALCULATOR
  // -------------------------------
  int calculateAge(dynamic dob) {
    try {
      late DateTime birthDate;

      if (dob is Timestamp) {
        birthDate = dob.toDate();
      } else if (dob is String && dob.contains('/')) {
        List<String> parts = dob.split('/');
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);
        birthDate = DateTime(year, month, day);
      } else if (dob is String && dob.contains('-')) {
        birthDate = DateTime.parse(dob);
      } else {
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
      print("❌ Age calc error: $e");
      return 0;
    }
  }
}