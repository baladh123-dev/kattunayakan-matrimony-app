import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'open_talk_controller.dart';

class OpenTalkView extends StatelessWidget {
  final OpenTalkController controller = Get.put(OpenTalkController());
  final TextEditingController msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFD4145A), // Deep Rose
                Color(0xFFFF6B9D), // Soft Pink
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Open Chat",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            Text(
              "Chat with everyone",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    "Open Chat",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD4145A),
                    ),
                  ),
                  content: Text(
                    "This is an open chat room where all users can communicate with each other. Be respectful and kind! ❤️",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        "Got it",
                        style: TextStyle(color: Color(0xFFD4145A)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFF6B9D).withOpacity(0.2),
                              Color(0xFFFFD700).withOpacity(0.2),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 64,
                          color: Color(0xFFD4145A),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "No messages yet",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Be the first to say hello! 👋",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: controller.messages.length,
                itemBuilder: (_, i) {
                  var msg = controller.messages[i];
                  bool isMe = msg["senderId"] == controller.myId;
                  String profilePic = msg["profilePic"] ?? "";
                  String senderName = msg["senderName"] ?? "Unknown";
                  String gender = msg["gender"] ?? "male";

                  // Check if we should show profile pic and name
                  // Show if it's the first message OR if sender changed from previous message
                  bool showHeader = i == 0 ||
                      controller.messages[i - 1]["senderId"] != msg["senderId"];

                  return Container(
                    margin: EdgeInsets.only(
                      bottom: (i < controller.messages.length - 1 &&
                          controller.messages[i + 1]["senderId"] == msg["senderId"])
                          ? 4
                          : 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        /// PROFILE PIC (left side for others)
                        if (!isMe) ...[
                          GestureDetector(
                            onTap:(){
                              controller.showUserInfoBottomSheet(
                                userId: msg['senderId'],
                              );
                            },
                            child: Container(
                              width: 40,
                              child: showHeader
                                  ? _buildProfilePic(profilePic, gender)
                                  : SizedBox(width: 40),
                            ),
                          ),
                          SizedBox(width: 8),
                        ],

                        /// MESSAGE CONTENT
                        Flexible(
                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              /// SENDER NAME (only if showHeader)
                              if (showHeader && !isMe)
                                Padding(
                                  padding: EdgeInsets.only(left: 12, bottom: 4),
                                  child: GestureDetector(
                                    onTap:(){
                                      controller.showUserInfoBottomSheet(
                                        userId: msg['senderId'],
                                      );
                                    },
                                    child: Text(
                                      senderName,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFD4145A),
                                      ),
                                    ),
                                  ),
                                ),

                              /// MESSAGE BUBBLE
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                  MediaQuery.of(context).size.width * 0.65,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  gradient: isMe
                                      ? LinearGradient(
                                    colors: [
                                      Color(0xFFD4145A),
                                      Color(0xFFFF6B9D),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                      : null,
                                  color: isMe ? null : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isMe
                                          ? Color(0xFFFF6B9D).withOpacity(0.2)
                                          : Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: msg["text"] != ""
                                    ? Text(
                                  msg["text"],
                                  style: TextStyle(
                                    color: isMe
                                        ? Colors.white
                                        : Colors.grey.shade800,
                                    fontSize: 15,
                                    height: 1.4,
                                  ),
                                )
                                    : msg["imageUrl"] != ""
                                    ? ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                  child: Image.network(
                                    msg["imageUrl"],
                                    width: 200,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child,
                                        loadingProgress) {
                                      if (loadingProgress == null)
                                        return child;
                                      return Container(
                                        width: 200,
                                        height: 200,
                                        child: Center(
                                          child:
                                          CircularProgressIndicator(
                                            color: isMe
                                                ? Colors.white
                                                : Color(0xFFFF6B9D),
                                            value: loadingProgress
                                                .expectedTotalBytes !=
                                                null
                                                ? loadingProgress
                                                .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return Container(
                                        width: 200,
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize:
                                          MainAxisSize.min,
                                          children: [
                                            Icon(Icons.error_outline,
                                                color: Colors.red),
                                            SizedBox(height: 8),
                                            Text(
                                              "Failed to load image",
                                              style: TextStyle(
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                                    : msg["audioUrl"] != ""
                                    ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.play_circle_filled,
                                      color: isMe
                                          ? Colors.white
                                          : Color(0xFFFF6B9D),
                                      size: 32,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Audio",
                                      style: TextStyle(
                                        color: isMe
                                            ? Colors.white
                                            : Colors.grey.shade800,
                                      ),
                                    ),
                                  ],
                                )
                                    : SizedBox(),
                              ),
                            ],
                          ),
                        ),

                        /// PROFILE PIC (right side for me)
                        if (isMe) ...[
                          SizedBox(width: 8),
                          Container(
                            width: 40,
                            child: showHeader
                                ? _buildProfilePic(profilePic, gender)
                                : SizedBox(width: 40),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              );
            }),
          ),

          /// IMAGE UPLOAD INDICATOR
          Obx(() {
            if (controller.isSendingImage.value) {
              return Container(
                padding: EdgeInsets.all(12),
                color: Colors.grey.shade100,
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Color(0xFFFF6B9D)),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Sending image...",
                      style: TextStyle(
                        color: Color(0xFFD4145A),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }
            return SizedBox.shrink();
          }),

          /// MESSAGE INPUT AREA
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  /// IMAGE BUTTON
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFF6B9D).withOpacity(0.2),
                          Color(0xFFFFD700).withOpacity(0.2),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Obx(() {
                      return IconButton(
                        icon: Icon(
                          Icons.image_rounded,
                          color: controller.isSendingImage.value
                              ? Colors.grey
                              : Color(0xFFD4145A),
                        ),
                        onPressed: controller.isSendingImage.value
                            ? null
                            : controller.sendImage,
                      );
                    }),
                  ),

                  SizedBox(width: 8),

                  /// TEXT FIELD
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: msgController,
                        decoration: InputDecoration(
                          hintText: "Type your message...",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 15),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  /// SEND BUTTON
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFD4145A),
                          Color(0xFFFF6B9D),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFF6B9D).withOpacity(0.4),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (msgController.text.trim().isNotEmpty) {
                          controller.sendText(msgController.text);
                          msgController.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// BUILD PROFILE PIC WIDGET
  Widget _buildProfilePic(String profilePicUrl, String gender) {
    bool isAsset = profilePicUrl.startsWith('assets/');

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFD4145A).withOpacity(0.1),
      ),
      child: ClipOval(
        child: isAsset
            ? Image.asset(
          profilePicUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultAvatar();
          },
        )
            : profilePicUrl.isNotEmpty
            ? Image.network(
          profilePicUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // If network image fails, show gender-based asset
            return Image.asset(
              gender.toLowerCase() == 'female'
                  ? 'assets/female.png'
                  : 'assets/male.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildDefaultAvatar();
              },
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildDefaultAvatar();
          },
        )
            : Image.asset(
          gender.toLowerCase() == 'female'
              ? 'assets/female.png'
              : 'assets/male.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultAvatar();
          },
        ),
      ),
    );
  }

  /// DEFAULT AVATAR (when no profile pic or error loading)
  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFD4145A),
            Color(0xFFFF6B9D),
          ],
        ),
      ),
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: 22,
      ),
    );
  }
}