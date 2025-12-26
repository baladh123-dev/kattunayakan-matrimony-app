import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'privacy_policy_controller.dart';

class PrivacyPolicyView extends StatelessWidget {
  final controller = Get.put(PrivacyPolicyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Privacy & Policy"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                    Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kattu Nayakkan Matrimony',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.pink[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Last updated: December 3, 2025',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Content Sections
              _buildSection(
                icon: Icons.info_outline,
                title: '1. Introduction',
                content:
                'Kattu Nayakkan Matrimony ("we", "our", or "us") operates the mobile application Kattu Nayakkan Matrimony (Package: com.kattu.nayakkan.matrimony).\n\nThis Privacy Policy explains how we collect, use, and protect your information when you use our app. By using our app, you confirm that you are at least 18 years old.',
              ),

              _buildSection(
                icon: Icons.folder_outlined,
                title: '2. Information We Collect',
                content: '',
                children: [
                  _buildSubSection('Personal Information:', [
                    'Name',
                    'Date of Birth / Age (18+)',
                    'Phone Number',
                    'Email ID',
                    'Gender',
                    'Profile Details (caste, village, marital status, etc.)',
                    'Photos you upload',
                  ]),
                  _buildSubSection('Automatically Collected Information:', [
                    'Device information (model, OS version)',
                    'App usage data',
                    'IP address',
                    'Crash logs',
                    'Analytics data',
                  ]),
                  _buildSubSection('Optional Information:', [
                    'Additional profile information you choose to enter',
                  ]),
                ],
              ),

              _buildSection(
                icon: Icons.settings_outlined,
                title: '3. How We Use Your Information',
                listItems: [
                  'Create and manage your profile',
                  'Match you with other users',
                  'Improve app performance',
                  'Communicate important updates',
                  'Provide customer support',
                  'Ensure safety and prevent fraud',
                ],
              ),

              _buildSection(
                icon: Icons.share_outlined,
                title: '4. Sharing of Information',
                content:
                'We may share your information only with:\n\n• Other users (limited profile details)\n• Service providers (Firebase, analytics, storage)\n• Authorities when required by law\n\nWe do not sell your personal data.',
              ),

              _buildSection(
                icon: Icons.security_outlined,
                title: '5. Data Security',
                content:
                'We follow industry practices and secure technologies to protect your information, but no system is 100% secure.',
              ),

              _buildSection(
                icon: Icons.verified_user_outlined,
                title: '6. User Rights',
                content: 'You may:',
                listItems: [
                  'Update your profile',
                  'Request account deletion',
                  'Request removal of your data',
                ],
                footer: 'Contact: baladh123@gmail.com',
              ),

              _buildSection(
                icon: Icons.child_care_outlined,
                title: '7. Children\'s Privacy',
                content:
                'This app is for adults aged 18+ only. We do not knowingly collect data from children under 18.',
                highlight: true,
              ),

              _buildSection(
                icon: Icons.apps_outlined,
                title: '8. Third-Party Services Used',
                listItems: [
                  'Firebase Authentication',
                  'Firebase Firestore',
                  'Firebase Storage',
                  'Analytics tools',
                ],
              ),

              _buildSection(
                icon: Icons.update_outlined,
                title: '9. Changes to This Policy',
                content: 'We may update this Privacy Policy at any time.',
              ),

              // Contact Section
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pink[700]!, Colors.pink[500]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.contact_mail, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(
                          '10. Contact Us',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildContactRow(Icons.email, 'baladh123@gmail.com'),
                    const SizedBox(height: 8),
                    _buildContactRow(
                        Icons.apps, 'Kattu Nayakkan Matrimony'),
                    const SizedBox(height: 8),
                    _buildContactRow(
                        Icons.code, 'com.kattu.nayakkan.matrimony'),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    String content = '',
    List<String>? listItems,
    List<Widget>? children,
    String? footer,
    bool highlight = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: highlight ? Colors.pink[50] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: highlight
            ? Border.all(color: Colors.pink[200]!, width: 2)
            : null,
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.pink[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.pink[700], size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          if (content.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.grey[700],
              ),
            ),
          ],
          if (listItems != null) ...[
            const SizedBox(height: 12),
            ...listItems.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.pink[400],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
          if (children != null) ...children,
          if (footer != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                footer,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.pink[700],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 6, left: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: Colors.pink[400])),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}