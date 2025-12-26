
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFD4145A),
              strokeWidth: 3,
            ),
          );
        }
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
             expandedHeight: 120,
              automaticallyImplyLeading: false,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFD4145A),
                      Color(0xFFFF6B9D),
                      Color(0xFFFFB6C1),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4145A).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: EdgeInsets.only(bottom: 20),
                  title: Text(
                    "காட்டு நாயக்கன்",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16, top: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.settings_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    onPressed: () => _openSettings(context),
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 35),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.toNamed('/LikedUsers');
                              },
                              child: Obx(
                                    () => _statCard(
                                  icon: Image.asset(
                                    'assets/fire.gif',
                                    fit: BoxFit.contain,
                                  ),
                                  value: controller.likedYouCount.value.toString(),
                                  label: "People like you",
                                ),
                              ),
                            ),

                            Row(
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () async {
                                    if (controller.isProfileEditMode.value) {
                                      await controller.saveAllProfileChanges();
                                    }
                                    controller.changemode();
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: controller.isProfileEditMode.value
                                          ? const Color(0xFF10B981).withOpacity(0.12)
                                          : const Color(0xFFD4145A).withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      controller.isProfileEditMode.value
                                          ? Icons.check_rounded
                                          : Icons.edit_rounded,
                                      color: controller.isProfileEditMode.value
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFFD4145A),
                                      size: 20,
                                    ),
                                  ),
                                ),
                                if (controller.isProfileEditMode.value) const SizedBox(width: 8),
                                if (controller.isProfileEditMode.value)
                                  InkWell(
                                    borderRadius: BorderRadius.circular(14),
                                    onTap: () {
                                      controller.changemode();
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // ✅ UPDATED: Profile Image with Loading Indicator
                        controller.isProfileEditMode.value
                            ? Obx(() => _buildEditableProfileImage())
                            : Obx(() => GestureDetector(
                          onTap: () {
                            _showFullImage(
                              context,
                              controller.profileImage.value.isEmpty
                                  ? "https://i.pinimg.com/736x/62/01/0d/62010d848b790a2336d1542fcda51789.jpg"
                                  : controller.profileImage.value,
                            );
                          },
                          child: _buildViewProfileImage(),
                        )),
                        SizedBox(height: 18),
                        Obx(
                              () => controller.isProfileEditMode.value
                              ? TextFormField(
                            controller: controller.nameController,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter your name",
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: const Color(0xFFD4145A).withOpacity(0.2),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFFD4145A),
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                            ),
                          )
                              : Text(
                            controller.userName.value.isEmpty
                                ? "Guest User"
                                : controller.userName.value,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(
                              () => Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                                  children: [
                                    // AGE
                                    controller.isProfileEditMode.value
                                        ? _buildDatePickerChip(context)
                                        : _infoChip(
                                      controller.userAge.value.isEmpty
                                          ? "Age"
                                          : "${controller.userAge.value} years",
                                    ),

                                    // CASTE
                                    // CASTE
                                    controller.isProfileEditMode.value
                                        ? _dropdownChip(
                                      label: "Caste",
                                      selectedValue: controller.caste.value,
                                      items: controller.casteList.map((e) => {"name": e}).toList(),
                                      onChanged: (val) => controller.caste.value = val,
                                    )
                                        : _infoChip(
                                      controller.caste.value.isEmpty ? "Caste" : controller.caste.value,
                                    ),

// VILLAGE
                                    controller.isProfileEditMode.value
                                        ? _dropdownChip(
                                      label: "Village",
                                      selectedValue: controller.village.value,
                                      items: controller.villageList.map((e) => {"name": e}).toList(),
                                      onChanged: (val) => controller.village.value = val,
                                    )
                                        : _infoChip(
                                      controller.village.value.isEmpty ? "Village" : controller.village.value,
                                    ),


                                    // VILLAGE
                                    // VILLAGE

                                    // STATUS
                                    controller.isProfileEditMode.value
                                        ? _dropdownChip(
                                      label: "Status",
                                      selectedValue: controller.marriageStatus.value,
                                      items: [
                                        {"name": "திருமணம் ஆனவர்"},   // Married
                                        {"name": "திருமணம் ஆகாதவர்"}, // Unmarried
                                      ],
                                      onChanged: (val) => controller.marriageStatus.value = val, // <-- required
                                    )

                                        : _infoChip(
                                      controller.marriageStatus.value.isEmpty
                                          ? "Status"
                                          : controller.marriageStatus.value,
                                    ),

                                    // GENDER
                                    controller.isProfileEditMode.value
                                        ? Row(
                                      children: [
                                        Expanded(
                                          child: _buildRadioOption(
                                            "ஆண்",
                                            controller.gender.value == "ஆண்",
                                                () {
                                              controller.gender.value = "ஆண்";
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _buildRadioOption(
                                            "பெண்",
                                            controller.gender.value == "பெண்",
                                                () {
                                              controller.gender.value = "பெண்";
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                        : _infoChip(
                                      controller.gender.value.isEmpty
                                          ? "Gender"
                                          : controller.gender.value,
                                    ),
                                  ]
                              ),
                        ),
                        const SizedBox(height: 20),
                        Obx(
                              () => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4145A).withOpacity(0.07),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(0xFFD4145A).withOpacity(0.15),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.phone_rounded,
                                  color: Color(0xFFD4145A),
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  controller.phoneNumber.value.isEmpty
                                      ? "No phone"
                                      : controller.phoneNumber.value,
                                  style: const TextStyle(
                                    color: Color(0xFFD4145A),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4145A).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.info_rounded,
                            color: Color(0xFFD4145A),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "உங்களை பற்றி எழுதுங்கள்",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                controller.isEditMode.value
                                    ? const Color(0xFF10B981).withOpacity(0.1)
                                    : const Color(0xFFD4145A).withOpacity(0.1),
                                controller.isEditMode.value
                                    ? const Color(0xFF059669).withOpacity(0.1)
                                    : const Color(0xFFFF6B9D).withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: controller.isEditMode.value
                                  ? const Color(0xFF10B981).withOpacity(0.3)
                                  : const Color(0xFFD4145A).withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Obx(() {
                            return controller.isEditMode.value
                                ? Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.save_rounded,
                                    color: Color(0xFF10B981),
                                    size: 20,
                                  ),
                                  onPressed: () async {
                                    await controller.updateProfileDetails(
                                      fatherName: controller.fatherNameController.text.trim(),
                                      motherName: controller.motherNameController.text.trim(),
                                      education: controller.educationController.text.trim(),
                                      description: controller.descriptionController.text.trim(),
                                    );
                                    controller.changemode2();
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    controller.changemode2();
                                  },
                                ),
                              ],
                            )
                                : IconButton(
                              icon: const Icon(
                                Icons.edit_rounded,
                                color: Color(0xFFD4145A),
                                size: 20,
                              ),
                              onPressed: () {
                                controller.changemode2();
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: controller.isEditMode.value
                              ? const Color(0xFFD4145A).withOpacity(0.2)
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: controller.isEditMode.value
                            ? [
                          _buildEditableInfoRow(
                            Icons.person_outline_rounded,
                            "தந்தை பெயர்",
                            controller.fatherName.value,
                            const Color(0xFF6366F1),
                            controller.fatherNameController,
                          ),
                          const SizedBox(height: 20),
                          Divider(color: Colors.grey[200], height: 1),
                          const SizedBox(height: 20),
                          _buildEditableInfoRow(
                            Icons.face_rounded,
                            "தாய் பெயர்",
                            controller.motherName.value,
                            const Color(0xFFEC4899),
                            controller.motherNameController,
                          ),
                          const SizedBox(height: 20),
                          Divider(color: Colors.grey[200], height: 1),
                          const SizedBox(height: 20),
                          _buildEditableInfoRow(
                            Icons.school_rounded,
                            "கல்வி விவரம்",
                            controller.education.value,
                            const Color(0xFF8B5CF6),
                            controller.educationController,
                          ),
                          const SizedBox(height: 20),
                          Divider(color: Colors.grey[200], height: 1),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.description_rounded,
                                  color: Color(0xFF10B981),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "உங்களை பற்றி விளக்கம்",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: controller.descriptionController,
                            minLines: 5,
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              hintText: controller.description.value.isEmpty
                                  ? "Tell us about yourself..."
                                  : controller.description.value,
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: const Color(0xFF10B981).withOpacity(0.2),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF10B981),
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ]
                            : [
                          _buildInfoRow(
                            Icons.person_outline_rounded,
                            "தந்தை பெயர்",
                            controller.fatherName.value.isEmpty
                                ? "Not specified"
                                : controller.fatherName.value,
                            const Color(0xFF6366F1),
                          ),
                          const SizedBox(height: 20),
                          Divider(color: Colors.grey[200], height: 1),
                          const SizedBox(height: 20),
                          _buildInfoRow(
                            Icons.face_rounded,
                            "தாய் பெயர்",
                            controller.motherName.value.isEmpty
                                ? "Not specified"
                                : controller.motherName.value,
                            const Color(0xFFEC4899),
                          ),
                          const SizedBox(height: 20),
                          Divider(color: Colors.grey[200], height: 1),
                          const SizedBox(height: 20),
                          _buildInfoRow(
                            Icons.school_rounded,
                            "கல்வி விவரம்",
                            controller.education.value.isEmpty
                                ? "Not specified"
                                : controller.education.value,
                            const Color(0xFF8B5CF6),
                          ),
                          const SizedBox(height: 20),
                          Divider(color: Colors.grey[200], height: 1),
                          const SizedBox(height: 20),
                          _buildInfoRow(
                            Icons.description_rounded,
                            "உங்களை பற்றி விளக்கம்",
                            controller.description.value.isEmpty
                                ? "No description yet"
                                : controller.description.value,
                            const Color(0xFF10B981),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
  Widget _buildRadioOption(
      String label,
      bool isSelected,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? Colors.blue.shade50 : Colors.white,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.blue : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }



  Widget _dropdownChip({
    required String label,
    required String selectedValue,
    required List<Map<String, dynamic>> items,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue.isEmpty ? null : selectedValue,
          hint: Text(label),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
              value: item['name'],
              child: Text(item['name']),
            ),
          )
              .toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }


  // ✅ NEW: Editable Profile Image with Loading Indicator

  Widget _buildEditableProfileImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Gradient Border
        Container(
          width: 130,
          height: 130,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFD4145A), Color(0xFFFFD700)],
            ),
          ),
        ),

        // Profile Image with Tap
        InkWell(
          onTap: controller.isUploadingImage.value
              ? null
              : () async {
            await controller.pickAndUploadProfileImage();
          },
          borderRadius: BorderRadius.circular(62),
          child: CircleAvatar(
            radius: 62,
            backgroundColor: Colors.white,
            backgroundImage: _getProfileImageProvider(),
          ),
        ),

        // Modern Upload Overlay (shows on hover effect)
        if (!controller.isUploadingImage.value)
          IgnorePointer(
            child: Container(
              width: 124,
              height: 124,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Change Photo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Loading Overlay
        if (controller.isUploadingImage.value)
          Container(
            width: 124,
            height: 124,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.9),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
                SizedBox(height: 12),
                Text(
                  'Uploading...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }



  // ✅ NEW: View Profile Image
  Widget _buildViewProfileImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFD4145A), Color(0xFFFFD700)],
            ),
          ),
        ),
        CircleAvatar(
          radius: 62,
          backgroundColor: Colors.white,
          backgroundImage: _getProfileImageProvider(),
        ),
      ],
    );
  }


  // ✅ UPDATED: Smart Image Provider with gender-based defaults
  ImageProvider _getProfileImageProvider() {
    if (controller.profileImage.value.isEmpty) {
      // Use gender-based default images
      if (controller.gender.value == "ஆண்") {
        return const AssetImage("assets/male.png");
      } else if (controller.gender.value == "பெண்") {
        return const AssetImage("assets/female.png");
      } else {
        // Fallback if gender not set
        return const AssetImage("assets/male.png");
      }
    } else if (controller.profileImage.value.startsWith('http')) {
      return NetworkImage(controller.profileImage.value);
    } else {
      // Fallback for invalid URLs
      if (controller.gender.value == "ஆண்") {
        return const AssetImage("assets/male.png");
      } else if (controller.gender.value == "பெண்") {
        return const AssetImage("assets/female.png");
      } else {
        return const AssetImage("assets/male.png");
      }
    }
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFD4145A),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.updateDateOfBirth(picked);
    }
  }

  Widget _buildDatePickerChip(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDateOfBirth(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFD4145A).withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD4145A).withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              size: 14,
              color: Color(0xFFD4145A),
            ),
            const SizedBox(width: 6),
            Obx(
                  () => Text(
                controller.userAge.value.isEmpty
                    ? "Select DOB"
                    : "${controller.userAge.value} years",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _editChip(TextEditingController controller, String hint) {
    return Container(
      constraints: const BoxConstraints(minWidth: 80, maxWidth: 150),
      child: IntrinsicWidth(
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
            filled: true,
            fillColor: const Color(0xFFD4145A).withOpacity(0.08),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: const Color(0xFFD4145A).withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFFD4145A), width: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _statCard({
    required Widget icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 28,
            width: 28,
            child: icon,   // 👈 now supports Image.asset (GIFs)
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFD4145A),
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildEditableInfoRow(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    TextEditingController controller,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title :",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: subtitle.isEmpty ? "Enter $title" : subtitle,
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: color.withOpacity(0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: color, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1A1A1A),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title :",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openSettings(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Settings",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 24),
            _buildSettingsItem(
              icon: Icons.privacy_tip_rounded,
              title: "Privacy Policy",
              color: const Color(0xFF8B5CF6),
              onTap: () {
                Get.toNamed('/privacy_policy');
              },
            ),
            const SizedBox(height: 12),
            _buildSettingsItem(
              icon: Icons.help_rounded,
              title: "Help & Support",
              color: const Color(0xFFF59E0B),
              onTap: () {
                _showHelpSupportDialog(context);
              },
            ),
            const SizedBox(height: 12),
            _buildSettingsItem(
              icon: Icons.logout_rounded,
              title: "Logout",
              color: const Color(0xFFD4145A),
              onTap: () {
                Get.back();
                controller.logout();
              },
            ),
            const SizedBox(height: 12),
            _buildSettingsItem(
              icon: Icons.delete_rounded,
              title: "Delete Account",
              color: const Color(0xFF1A1A1A),
              onTap: () {
                Get.back();
                _showDeleteConfirmation(context);
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }


  void _showHelpSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.help_rounded,
                color: const Color(0xFFF59E0B),
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Help & Support',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'How would you like to contact us?',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              // Call Option
              _buildContactOption(
                icon: Icons.phone,
                title: 'Call Us',
                subtitle: '+91 97880 30743',
                color: Colors.green,
                onTap: () async {
                  final Uri phoneUri = Uri(scheme: 'tel', path: '+919788030743');
                  if (await canLaunchUrl(phoneUri)) {
                    await launchUrl(phoneUri);
                  }
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              // WhatsApp Option
              _buildContactOption(
                icon: Icons.chat,
                title: 'WhatsApp',
                subtitle: '+91 97880 30743',
                color: const Color(0xFF25D366),
                onTap: () async {
                  final Uri whatsappUri = Uri.parse('https://wa.me/919788030743');
                  if (await canLaunchUrl(whatsappUri)) {
                    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.15), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: 0.2,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Colors.grey[400],
            ),
          ],
        ),
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


  void _showDeleteConfirmation(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFD4145A).withOpacity(0.15),
                      const Color(0xFFFF6B9D).withOpacity(0.15),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Color(0xFFD4145A),
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Delete Account?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "This action cannot be undone. All your data will be permanently deleted.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD4145A), Color(0xFFFF6B9D)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD4145A).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          controller.deleteAccount();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

}
