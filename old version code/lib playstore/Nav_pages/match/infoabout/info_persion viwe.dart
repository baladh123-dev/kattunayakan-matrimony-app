import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/Nav_pages/match/infoabout/info_persion%20Controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class infopersionView extends StatelessWidget {
  const infopersionView({super.key});

  String maskPhoneNumber(String number) {
    if (number.length < 4) return number;
    return number.substring(0, number.length - 4) + "xxxx";
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(infopersionViewcontroller());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: const Color(0xFFD4145A),
              strokeWidth: 3,
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            // Ultra Modern App Bar with glassmorphism effect
            SliverAppBar(
              expandedHeight: 320,
              pinned: true,
              backgroundColor: const Color(0xFFD4145A),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    onPressed: () => Get.back(),
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFD4145A),
                        Color(0xFFFF6B9D),
                        Color(0xFFFFB6C1),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative circles
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -30,
                        left: -30,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 70),
                          // Profile Image with premium border
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Animated gradient ring
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const SweepGradient(
                                    colors: [
                                      Color(0xFFFFD700),
                                      Color(0xFFFF6B9D),
                                      Color(0xFFD4145A),
                                      Color(0xFFFFD700),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFFD700).withOpacity(0.5),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    _showFullImage(context, controller.profileImage.value);
                                  },
                                  child: CircleAvatar(
                                    radius: 65,
                                    backgroundImage: controller.profileImage.value
                                        .startsWith("assets/")
                                        ? AssetImage(controller.profileImage.value)
                                    as ImageProvider
                                        : NetworkImage(controller.profileImage.value),
                                  ),
                                ),
                              ),
                              // Verified badge
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.verified,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Name with modern typography
                          Text(
                            controller.userName.value,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Enhanced info chips with likes counter
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              const SizedBox(width: 10),
                              _premiumInfoChip(
                                Icons.cake_outlined,
                                controller.dob.value,
                              ),
                              const SizedBox(width: 10),

                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Content with floating card effect
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -30),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 35, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats row
                        _statsRow(controller),

                        const SizedBox(height: 30),

                        // Personal Details Section
                        _modernSectionHeader(Icons.person_outline, "Personal Details"),
                        const SizedBox(height: 16),
                        _glassmorphicCard([
                          _enhancedInfoRow(Icons.wc, "Marriage Status",
                              controller.marriageStatus.value),
                          _enhancedInfoRow(Icons.family_restroom, "Caste",
                              controller.caste.value),
                          _enhancedInfoRow(Icons.location_on_outlined, "Village",
                              controller.village.value),
                        ]),

                        const SizedBox(height: 28),

                        // Family Details Section
                        _modernSectionHeader(Icons.family_restroom, "Family Details"),
                        const SizedBox(height: 16),
                        _glassmorphicCard([
                          _enhancedInfoRow(Icons.man, "Father's Name",
                              controller.fatherName.value),
                          _enhancedInfoRow(Icons.woman, "Mother's Name",
                              controller.motherName.value),
                        ]),

                        const SizedBox(height: 28),

                        // Education & Career
                        _modernSectionHeader(Icons.school_outlined, "Education"),
                        const SizedBox(height: 16),
                        _glassmorphicCard([
                          _enhancedInfoRow(Icons.school, "Qualification",
                              controller.education.value),
                        ]),

                        const SizedBox(height: 28),

                        // Contact Section
                        _modernSectionHeader(Icons.contact_phone_outlined, "Contact"),
                        const SizedBox(height: 16),
                        _phoneNumberCard(maskPhoneNumber(controller.phoneNumber.value)),

                        const SizedBox(height: 28),

                        // About Section
                        if (controller.description.value.isNotEmpty) ...[
                          _modernSectionHeader(Icons.description_outlined, "About"),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white,
                                  const Color(0xFFFFE5F0).withOpacity(0.3),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0xFFFF6B9D).withOpacity(0.2),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF6B9D).withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Text(
                              controller.description.value,
                              style: TextStyle(
                                fontSize: 15.5,
                                height: 1.7,
                                color: Colors.grey[800],
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 40),

                        // Interested Button
                        _interestedButton(),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _statsRow(infopersionViewcontroller controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFF6B9D).withOpacity(0.1),
            const Color(0xFFFFD700).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFF6B9D).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(
            Icons.favorite,
            "${controller.likedYouCount.value}",
            "Likes",
            const Color(0xFFD4145A),
          ),

          Container(
            width: 1,
            height: 40,
            color: Colors.grey.withOpacity(0.3),
          ),

          // ✅ Gender Section Fixed
          _statItem(
            controller.gender.value.toLowerCase() == 'male'
                ? Icons.male
                : Icons.female,

            controller.gender.value.capitalizeFirst!,
            "Gender",

            controller.gender.value.toLowerCase() == 'male'
                ? const Color(0xFF6B9DFF)   // Male → Blue
                : const Color(0xFFD4145A),  // Female → Pink
          ),

          Container(
            width: 1,
            height: 40,
            color: Colors.grey.withOpacity(0.3),
          ),

          _statItem(
            Icons.handshake_outlined,
            "${controller.age.value}",
            "Age",
            const Color(0xFF6B9DFF),
          ),



        ],
      ),
    );
  }


  Widget _statItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _premiumInfoChip(IconData icon, String text, {bool isLikes = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLikes
              ? [
            const Color(0xFFFFD700).withOpacity(0.9),
            const Color(0xFFFFA500).withOpacity(0.9),
          ]
              : [
            Colors.white.withOpacity(0.25),
            Colors.white.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isLikes
                ? const Color(0xFFFFD700).withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text.isEmpty ? "-" : text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _modernSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFD4145A), Color(0xFFFF6B9D)],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD4145A).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 14),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2C2C2C),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _glassmorphicCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            const Color(0xFFFFE5F0).withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFFF6B9D).withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B9D).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _enhancedInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.08),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF6B9D).withOpacity(0.15),
                  const Color(0xFFFFD700).withOpacity(0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 22,
              color: const Color(0xFFD4145A),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value.isEmpty ? "-" : value,
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C2C2C),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD4145A), Color(0xFFFF6B9D)],
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
                  child: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _phoneNumberCard(String phoneNumber) {
    final RxBool isRevealed = false.obs;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            const Color(0xFFFFE5F0).withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFFF6B9D).withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B9D).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFF6B9D).withOpacity(0.15),
                    const Color(0xFFFFD700).withOpacity(0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.phone_outlined,
                size: 24,
                color: Color(0xFFD4145A),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Phone Number",
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Obx(() => Stack(
                    children: [
                      Text(
                        phoneNumber.isEmpty ? "-" : phoneNumber,
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2C2C2C),
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (!isRevealed.value)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.9),
                                const Color(0xFFFFE5F0).withOpacity(0.9),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFFFF6B9D).withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.lock_outline,
                                size: 14,
                                color: const Color(0xFFD4145A),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Protected",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color(0xFFD4145A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  )),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Obx(() => GestureDetector(
              onTap: () => isRevealed.value = !isRevealed.value,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isRevealed.value
                        ? [
                      const Color(0xFFFF6B9D),
                      const Color(0xFFD4145A),
                    ]
                        : [
                      const Color(0xFFD4145A),
                      const Color(0xFFFF6B9D),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4145A).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  isRevealed.value ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _interestedButton() {
    final controller = Get.find<infopersionViewcontroller>();
    final RxBool isInterested = false.obs;
    final RxBool isProcessing = false.obs;

    _checkIfAlreadyInterested(isInterested, controller);

    return Obx(() => GestureDetector(
      onTap: isProcessing.value
          ? null
          : () async {
        isProcessing.value = true;
        try {
          await _handleInterestTap(isInterested, controller);
        } finally {
          isProcessing.value = false;
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isInterested.value
                ? [
              const Color(0xFFFFD700),
              const Color(0xFFFFA500),
            ]
                : [
              const Color(0xFFD4145A),
              const Color(0xFFFF6B9D),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isInterested.value
                  ? const Color(0xFFFFD700).withOpacity(0.5)
                  : const Color(0xFFD4145A).withOpacity(0.4),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: isProcessing.value
            ? const Center(
          child: SizedBox(
            height: 26,
            width: 26,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isInterested.value ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
              size: 26,
            ),
            const SizedBox(width: 12),
            Text(
              isInterested.value ? "Interested ✓" : "I'm Interested",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
Future<void> _checkIfAlreadyInterested(
    RxBool isInterested, infopersionViewcontroller controller) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentUserPhone = prefs.getString("phone");

    if (currentUserPhone == null || currentUserPhone.isEmpty) {
      return;
    }

    String? docId = Get.arguments?['docId'];
    if (docId == null || docId.isEmpty) {
      return;
    }

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('userList')
        .doc(docId)
        .get();

    if (doc.exists) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      List<dynamic> likes = data?['likes'] ?? [];

      if (likes.contains(currentUserPhone)) {
        isInterested.value = true;
      }
    }
  } catch (e) {
    print("Error checking interest status: $e");
  }
}

Future<void> _handleInterestTap(
    RxBool isInterested, infopersionViewcontroller controller) async {
  try {
    // Get current user's phone number
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentUserPhone = prefs.getString("phone");

    if (currentUserPhone == null || currentUserPhone.isEmpty) {
      Get.snackbar(
        "Error",
        "Please login to show interest",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    // Get the document ID from arguments
    String? docId = Get.arguments?['docId'];
    if (docId == null || docId.isEmpty) {
      Get.snackbar(
        "Error",
        "Invalid user profile",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection('userList').doc(docId);

    if (!isInterested.value) {
      // Add interest
      await docRef.update({
        'numberOfLikes': FieldValue.increment(1),
        'likes': FieldValue.arrayUnion([currentUserPhone]),
      });

      isInterested.value = true;

      Get.snackbar(
        "Success",
        "Interest sent successfully!",
        backgroundColor: const Color(0xFFD4145A).withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.favorite, color: Colors.white),
      );
    } else {
      // Remove interest
      await docRef.update({
        'numberOfLikes': FieldValue.increment(-1),
        'likes': FieldValue.arrayRemove([currentUserPhone]),
      });

      isInterested.value = false;

      Get.snackbar(
        "Removed",
        "Interest removed",
        backgroundColor: Colors.grey.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  } catch (e) {
    Get.snackbar(
      "Error",
      "Failed to update interest: $e",
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
    print("Error updating interest: $e");
  }
}

Widget _infoRow(IconData icon, String label, String value) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B9D).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFFD4145A),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value.isEmpty ? "-" : value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C2C2C),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
