import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikedUsersController extends GetxController {
  RxList<Map<String, dynamic>> likedUsers = <Map<String, dynamic>>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLikedUsers();
  }
  //////////////////////////////////////////////////// ads starting /////////////////////////////////////////////////////////////////



  ///////////////////////////////////////////////////// ads starting ////////////////////////////////////////////////////////////////
  Future<void> fetchLikedUsers() async {
    try {
      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedPhone = prefs.getString("phone");

      if (savedPhone == null) {
        print("⚠ No phone saved in SharedPreferences");
        return;
      }

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('userList')
          .doc(savedPhone)
          .get();

      if (!userSnapshot.exists) {
        print("⚠ User document not found");
        return;
      }

      Map<String, dynamic>? userData =
      userSnapshot.data() as Map<String, dynamic>?;

      if (userData == null || !userData.containsKey('likes')) {
        print("⚠ Likes field missing");
        return;
      }

      List<dynamic> likedNumbers = userData['likes'];

      print("👍 Total liked users = ${likedNumbers.length}");

      List<Map<String, dynamic>> finalList = [];

      for (var phone in likedNumbers) {
        String phoneStr = phone.toString();

        DocumentSnapshot likedUserSnapshot = await FirebaseFirestore.instance
            .collection('userList')
            .doc(phoneStr)
            .get();

        if (likedUserSnapshot.exists) {
          Map<String, dynamic> likedUserData =
          likedUserSnapshot.data() as Map<String, dynamic>;

          finalList.add({
            "phone": likedUserData["phoneNumber"] ?? "No Name",
            "name": likedUserData["name"] ?? "No Name",
            "profileImage": likedUserData["profileImageUrl"] ?? "",
            "numberOfLikes": likedUserData["numberOfLikes"] ?? 0,
          });
        }
      }

      likedUsers.value = finalList;
    } catch (e) {
      print("❌ Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String maskPhone(String phone) {
    if (phone.length < 4) return phone;
    return phone.substring(0, phone.length - 4) + "xxxx";
  }




  ///////////////////////////////////////////





  void showUserInfoBottomSheet({
    required String userId,
  }) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    try {
      DocumentSnapshot doc =
      await _db.collection('userList').doc(userId).get();
      if (!doc.exists) return;
      final data = doc.data() as Map<String, dynamic>;
      final String? dob = data['dob']; // "27/04/2008"
      final int age = dob != null ? calculateAge(dob) : 0;
      final String profileImage = (data['profileImageUrl'] != null &&
          data['profileImageUrl'].toString().isNotEmpty)
          ? data['profileImageUrl']
          : (data['gender'] == 'female'
          ? 'assets/female.png'
          : 'assets/male.png');
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFB6C1).withOpacity(0.3),
                Colors.white,
              ],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFD4145A).withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// drag handle
              Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFD4145A), Color(0xFFFF6B9D)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              /// profile image with gradient border
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFD4145A),
                          Color(0xFFFF6B9D),
                          Color(0xFFFFB6C1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showFullImage(Get.context!, profileImage);
                    },
                    child: Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: profileImage.startsWith("assets/")
                            ? Image.asset(profileImage, fit: BoxFit.cover)
                            : Image.network(profileImage, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFD4145A), Color(0xFFFF6B9D)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFD4145A).withOpacity(0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.zoom_in,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// name with heart icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Color(0xFFFF6B9D),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    data['name'] ?? 'User',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD4145A),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.favorite,
                    color: Color(0xFFFF6B9D),
                    size: 20,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// info cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        icon: Icons.cake_outlined,
                        label: "Age",
                        value: "${age > 0 ? age : '--'} yrs",
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoCard(
                        icon: Icons.location_on_outlined,
                        label: "Village",
                        value: data['village'] ?? 'Unknown',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// caste card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFFB6C1).withOpacity(0.3),
                        Color(0xFFFF6B9D).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color(0xFFFF6B9D).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.people_outline,
                          color: Color(0xFFD4145A),
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Community",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFD4145A).withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              data['caste'] ?? 'Not mentioned',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFD4145A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// action buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: Get.back,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFFD4145A),
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: Color(0xFFFF6B9D).withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.close_rounded, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "Close",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFD4145A),
                              Color(0xFFFF6B9D),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFD4145A).withOpacity(0.4),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(
                              '/persionINFO',
                              arguments: {'docId': userId.toString()},
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.favorite_rounded, size: 20),
                              SizedBox(width: 8),
                              Text(
                                "View Profile",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
        isScrollControlled: true,
      );
    } catch (e) {
      print("Error loading user info: $e");
    }
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFB6C1).withOpacity(0.3),
            Color(0xFFFF6B9D).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFFFF6B9D).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Color(0xFFD4145A),
              size: 20,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFD4145A).withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD4145A),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  int calculateAge(String dobString) {
    try {
      final parts = dobString.split('/');
      if (parts.length != 3) return 0;

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final birthDate = DateTime(year, month, day);
      final today = DateTime.now();

      int age = today.year - birthDate.year;

      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      return age;
    } catch (e) {
      return 0;
    }
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.95),
      useSafeArea: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Full screen interactive image
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: imageUrl.startsWith("assets/")
                    ? Image.asset(
                  imageUrl,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                )
                    : Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: const Color(0xFFFF6B9D),
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: 80,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Unable to load image",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Close button with better positioning
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFD4145A),
                        Color(0xFFFF6B9D),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),

            // Hint text at bottom
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.zoom_in,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Pinch to zoom",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
