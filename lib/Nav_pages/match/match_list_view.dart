import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'match_list_controller.dart';

class MatchListView extends StatelessWidget {
  final MatchListController controller = Get.put(MatchListController());
  final ScrollController _scrollController = ScrollController();

  MatchListView({super.key}) {
    // Listen to scroll events for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 500) {
        // Load more when user is 500px from bottom
        controller.loadMoreUsers();
      }
    });

    // Preload images when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadImages();
    });
  }

  // PRELOAD FIRST 15 IMAGES FOR INSTANT DISPLAY
  void _preloadImages() {
    final imagesToPreload = controller.matchedList
        .take(15)
        .map((user) => user['profileImageUrl'])
        .where((url) =>
    url != null &&
        url.isNotEmpty &&
        (url.startsWith('http://') || url.startsWith('https://')))
        .toList();

    for (var imageUrl in imagesToPreload) {
      precacheImage(
        CachedNetworkImageProvider(imageUrl),
        Get.context!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(), // Smooth iOS-like scrolling
        cacheExtent: 1000, // Preload images 1000px ahead
        slivers: [
          // ---------------- APP BAR ----------------
          SliverAppBar(
            floating: false,
            pinned: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFD4145A),
                    Color(0xFFFF6B9D),
                    Color(0xFFFFD700),
                  ],
                ),
              ),
              child: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  "காட்டு நாயக்கன்",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFD4145A).withOpacity(0.9),
                        Color(0xFFFF6B9D).withOpacity(0.9),
                        Color(0xFFFFD700).withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(Icons.refresh_rounded, color: Colors.white),
                  onPressed: () => controller.refreshData(),
                ),
              ),
            ],
          ),

          // ---------------- SEARCH + FILTER ----------------
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 7),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFD4145A).withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        controller.updateSearchQuery(value);
                      },
                      decoration: InputDecoration(
                        hintText: "Search by name, caste, village, age...",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        prefixIcon: Container(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.search_rounded,
                            color: Color(0xFFD4145A),
                            size: 22,
                          ),
                        ),
                        suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                            ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                          onPressed: () {
                            controller.clearSearch();
                          },
                        )
                            : GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'This feature is not available on this phone!'),
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFD4145A),
                                  Color(0xFFFF6B9D)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.tune_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        )),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6),

                // Gender Filter
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(
                        () => Row(
                      children: [
                        Expanded(
                          child: _buildGenderChip(
                            label: "பெண்",
                            icon: Icons.female_rounded,
                            isSelected:
                            controller.selectedGender.value == "Female",
                            color: Color(0xFFFF6B9D),
                            onTap: () => controller.changeGender("Female"),
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: _buildGenderChip(
                            label: "ஆண்",
                            icon: Icons.male_rounded,
                            isSelected: controller.selectedGender.value == "Male",
                            color: Color(0xFF4A90E2),
                            onTap: () => controller.changeGender("Male"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 5),

                // Match Count
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(
                        () => Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFD4145A).withOpacity(0.1),
                                Color(0xFFFF6B9D).withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Color(0xFFD4145A).withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.people_rounded,
                                size: 18,
                                color: Color(0xFFD4145A),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "${controller.matchedList.length} Matches",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
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

                SizedBox(height: 5),
              ],
            ),
          ),

          // ---------------- MATCH LIST ----------------
          Obx(() {
            if (controller.isLoading.value && controller.matchedList.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFD4145A).withOpacity(0.1),
                              Color(0xFFFF6B9D).withOpacity(0.1),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: CircularProgressIndicator(
                          color: Color(0xFFD4145A),
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Finding matches...",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (controller.matchedList.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFD4145A).withOpacity(0.1),
                              Color(0xFFFF6B9D).withOpacity(0.1),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.people_outline_rounded,
                          size: 80,
                          color: Color(0xFFD4145A).withOpacity(0.5),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        "No matches found",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Try adjusting your filters",
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final person = controller.matchedList[index];

                  // Get profile image or default based on gender
                  String profileImage = _getProfileImage(person);
                  bool isDefaultImage = _isDefaultImage(person);

                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFD4145A).withOpacity(0.08),
                          blurRadius: 20,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // ---------------- SUPER FAST PROFILE IMAGE ----------------
                            Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFD4145A),
                                        Color(0xFFFF6B9D),
                                        Color(0xFFFFD700),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFD4145A).withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      _showFullImage(
                                          context, profileImage, isDefaultImage);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: _buildSuperFastAvatar(
                                        profileImage,
                                        isDefaultImage,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent[400],
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.greenAccent.withOpacity(0.5),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(width: 14),

                            // ---------------- DETAILS ----------------
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    '/persionINFO',
                                    arguments: {'docId': person['docId']},
                                  );
                                  print(person['docId']);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            person["name"]?.toString() ?? "Unknown",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[900],
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),

                                    _buildInfoRow(
                                      icon: Icons.cake_rounded,
                                      text: "${person['age']} years",
                                      color: Color(0xFFFF6B9D),
                                    ),

                                    SizedBox(height: 3),
                                    _buildInfoRow(
                                      icon: Icons.group_rounded,
                                      text: person["caste"]?.toString() ?? "N/A",
                                      color: Color(0xFF4A90E2),
                                    ),
                                    SizedBox(height: 3),
                                    _buildInfoRow(
                                      icon: Icons.location_on_rounded,
                                      text: person["village"]?.toString() ?? "N/A",
                                      color: Color(0xFF52C41A),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(width: 12),

                            // ---------------- LIKES & ACTION ----------------
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFD4145A).withOpacity(0.15),
                                        Color(0xFFFF6B9D).withOpacity(0.15),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Color(0xFFD4145A).withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        size: 14,
                                        color: Color(0xFFD4145A),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        person["numberOfLikes"]?.toString() ?? "0",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFD4145A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 12),

                                Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFD4145A),
                                        Color(0xFFFF6B9D),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFD4145A).withOpacity(0.4),
                                        blurRadius: 12,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Icon(
                                      Icons.favorite_rounded,
                                      size: 20,
                                      color: Color(0xFFD4145A),
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
                }, childCount: controller.matchedList.length),
              ),
            );
          }),

          // ---------------- LOADING MORE INDICATOR ----------------
          Obx(() {
            if (controller.isLoadingMore.value) {
              return SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFFD4145A),
                          strokeWidth: 2.5,
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Loading more...",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return SliverToBoxAdapter(child: SizedBox(height: 24));
          }),
        ],
      ),
    );
  }

  // ---------------- SUPER FAST AVATAR WITH SHIMMER EFFECT ----------------
  Widget _buildSuperFastAvatar(String imageUrl, bool isAsset) {
    if (isAsset) {
      return CircleAvatar(
        radius: 42,
        backgroundImage: AssetImage(imageUrl),
      );
    }

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 84,
        height: 84,
        fit: BoxFit.cover,
        // SUPER OPTIMIZATION: Very small thumbnail
        memCacheWidth: 168, // 2x for retina displays
        memCacheHeight: 168,
        maxWidthDiskCache: 168,
        maxHeightDiskCache: 168,
        // Ultra fast transitions
        fadeInDuration: Duration(milliseconds: 150),
        fadeOutDuration: Duration(milliseconds: 50),
        // Instagram-style shimmer loading
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[200],
          child: Icon(Icons.person, size: 40, color: Colors.grey[400]),
        ),
      ),
    );
  }

  // Helper method to get profile image
  String _getProfileImage(Map<String, dynamic> person) {
    String? profileUrl = person['profileImageUrl'];

    if (profileUrl != null &&
        profileUrl.isNotEmpty &&
        !profileUrl.contains('placeholder') &&
        (profileUrl.startsWith('http://') || profileUrl.startsWith('https://'))) {
      return profileUrl;
    }

    String gender = person['gender']?.toString().trim() ?? '';

    if (gender == 'பெண்' ||
        gender == 'female' ||
        gender.toLowerCase() == 'female') {
      return 'assets/female.png';
    } else if (gender == 'ஆண்' ||
        gender == 'male' ||
        gender.toLowerCase() == 'male') {
      return 'assets/male.png';
    }

    return 'assets/female.png';
  }

  bool _isDefaultImage(Map<String, dynamic> person) {
    String? profileUrl = person['profileImageUrl'];

    if (profileUrl == null ||
        profileUrl.isEmpty ||
        profileUrl.contains('placeholder') ||
        (!profileUrl.startsWith('http://') && !profileUrl.startsWith('https://'))) {
      return true;
    }

    return false;
  }

  // ---------------- GENDER CHIP ----------------
  Widget _buildGenderChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [color, color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? color.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 15 : 8,
              offset: Offset(0, isSelected ? 6 : 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey[700],
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- FULL IMAGE VIEW WITH HERO ANIMATION ----------------
  void _showFullImage(BuildContext context, String imageUrl, bool isAsset) {
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
                child: isAsset
                    ? Image.asset(
                  imageUrl,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                )
                    : CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  // Full resolution for zoom
                  memCacheWidth: 1200,
                  memCacheHeight: 1200,
                  fadeInDuration: Duration(milliseconds: 200),
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[800]!,
                    highlightColor: Colors.grey[700]!,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) {
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
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),

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

  // ---------------- INFO ROW ----------------
  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 14, color: color),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}