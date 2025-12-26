import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Updated ProfileController.dart';

class UpdateProfileView extends StatelessWidget {
  final controller = Get.put(UpdateProfileController());

  UpdateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7), // Soft Pink White
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "காட்டு நாயக்கன் சமுதாயம்",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Image Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Obx(() => GestureDetector(
                    onTap: () => controller.pickImage(),
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFD4145A), // Rose
                                Color(0xFFFFD700), // Gold
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFD4145A).withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: CircleAvatar(
                              radius: 62,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: controller.profileImage.value != null
                                  ? FileImage(controller.profileImage.value!)
                                  : (controller.gender.value.isNotEmpty
                                  ? AssetImage(controller.getDefaultImagePath())
                                  : null) as ImageProvider?,
                              child: (controller.profileImage.value == null &&
                                  controller.gender.value.isEmpty)
                                  ? Icon(Icons.person, size: 50, color: Colors.grey[400])
                                  : null,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFD4145A),
                                  Color(0xFFFF6B9D),
                                ],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 15),
                  Text(
                    "Phone: ${controller.phoneNumber}",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Form Fields Container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Input
                  _buildLabel("Name", Icons.person_outline),
                  const SizedBox(height: 8),
                  Obx(() => TextField(
                    controller: controller.nameController,
                    onChanged: (value) => controller.name.value = value,
                    decoration: _buildInputDecoration(
                      "Enter your name",
                      controller.nameError.value,
                    ),
                  )),

                  const SizedBox(height: 25),

                  // Date of Birth
                  _buildLabel("Date of Birth", Icons.calendar_today),
                  const SizedBox(height: 8),
                  Obx(() => GestureDetector(
                    onTap: () => controller.selectDatePicker(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.dobError.value.isNotEmpty
                              ? Colors.red
                              : const Color(0xFFD4145A).withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.dob.value.isEmpty
                                    ? "Select date"
                                    : controller.dob.value,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: controller.dob.value.isEmpty
                                      ? Colors.grey[400]
                                      : Colors.black87,
                                ),
                              ),
                              if (controller.dobError.value.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    controller.dobError.value,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Color(0xFFD4145A),
                          ),
                        ],
                      ),
                    ),
                  )),

                  const SizedBox(height: 25),

                  // Gender Selection
                  _buildLabel("Gender", Icons.wc),
                  const SizedBox(height: 12),
                  Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildRadioOption(
                              "ஆண்",
                              controller.gender.value == "ஆண்",
                                  () {
                                controller.gender.value = "ஆண்";
                                controller.genderError.value = '';
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
                                controller.genderError.value = '';
                              },
                            ),
                          ),
                        ],
                      ),
                      if (controller.genderError.value.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            controller.genderError.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  )),

                  const SizedBox(height: 25),

                  // Caste Dropdown
                  _buildLabel("இனம்", Icons.group_outlined),
                  const SizedBox(height: 8),
                  Obx(() => Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: controller.casteError.value.isNotEmpty
                            ? Colors.red
                            : const Color(0xFFD4145A).withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          value: controller.selectedCaste.value.isEmpty
                              ? null
                              : controller.selectedCaste.value,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                            border: InputBorder.none,
                          ),
                          hint: Text(
                            "Select caste",
                            style: TextStyle(color: Colors.grey[400], fontSize: 15),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFFD4145A),
                          ),
                          items: controller.casteList.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value, style: const TextStyle(fontSize: 15)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            controller.selectedCaste.value = value!;
                            controller.casteError.value = '';
                          },
                        ),
                        if (controller.casteError.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 15, bottom: 8),
                            child: Text(
                              controller.casteError.value,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  )),

                  const SizedBox(height: 25),

                  // Village Dropdown
                  _buildLabel("ஊர்கள்", Icons.location_on_outlined),
                  const SizedBox(height: 8),
                  Obx(() => Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: controller.villageError.value.isNotEmpty
                            ? Colors.red
                            : const Color(0xFFD4145A).withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          value: controller.selectedVillage.value.isEmpty
                              ? null
                              : controller.selectedVillage.value,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                            border: InputBorder.none,
                          ),
                          hint: const Text(
                            "Select village",
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFFD4145A),
                          ),
                          items: controller.villageList.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value, style: const TextStyle(fontSize: 15)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            controller.selectedVillage.value = value!;
                            controller.villageError.value = '';
                          },
                        ),
                        if (controller.villageError.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 15, bottom: 8),
                            child: Text(
                              controller.villageError.value,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  )),

                  const SizedBox(height: 25),

                  // Marriage Status
                  _buildLabel("Marriage Status", Icons.favorite_outline),
                  const SizedBox(height: 12),
                  Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildRadioOption(
                              "Single",
                              controller.marriageStatus.value == "திருமணம் ஆகாதவர்",
                                  () {
                                controller.marriageStatus.value = "திருமணம் ஆகாதவர்";
                                controller.marriageError.value = '';
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildRadioOption(
                              "Married",
                              controller.marriageStatus.value == "திருமணமானவர்",
                                  () {
                                controller.marriageStatus.value = "திருமணமானவர்";
                                controller.marriageError.value = '';
                              },
                            ),
                          ),
                        ],
                      ),
                      if (controller.marriageError.value.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            controller.marriageError.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  )),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Save Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 55,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD4145A), Color(0xFFFF6B9D)],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4145A).withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  controller.saveProfile();
                },
                child: const Text(
                  "Save Profile",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFFD4145A)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String hint, String error) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color(0xFFD4145A).withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: error.isNotEmpty
              ? Colors.red
              : const Color(0xFFD4145A).withOpacity(0.2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: error.isNotEmpty ? Colors.red : const Color(0xFFD4145A),
          width: 2,
        ),
      ),
      errorText: error.isNotEmpty ? error : null,
      errorStyle: const TextStyle(fontSize: 12),
    );
  }

  Widget _buildRadioOption(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [
              const Color(0xFFD4145A).withOpacity(0.15),
              const Color(0xFFFF6B9D).withOpacity(0.15),
            ],
          )
              : null,
          color: isSelected ? null : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFD4145A) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isSelected
                    ? const LinearGradient(
                  colors: [
                    Color(0xFFD4145A),
                    Color(0xFFFF6B9D),
                  ],
                )
                    : null,
                border: !isSelected
                    ? Border.all(
                  color: Colors.grey[400]!,
                  width: 2,
                )
                    : null,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? const Color(0xFFD4145A) : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}