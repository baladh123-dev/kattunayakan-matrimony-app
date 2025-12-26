import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/One_time_pages/Login/LoginController.dart';

class LoginView extends StatelessWidget {
  final controller = Get.put(LoginController());

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD4145A), // Deep Rose
              Color(0xFFFF6B9D), // Soft Pink
              Color(0xFFFFD700), // Gold
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Section with Logo
              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        textAlign:TextAlign.center,
                        "காட்டு நாயக்கன் \n சமுதாயம்",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Matrimony app",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Section with Form
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(30),
                    child: Obx(() => AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: !controller.showOtpField.value
                          ? _buildPhoneSection()
                          : _buildOtpSection(),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Phone Number Section
  Widget _buildPhoneSection() {
    return Column(
      key: ValueKey('phone'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Login",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Enter your phone number to continue",
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 35),

        // Phone Number Label
        Row(
          children: [
            Icon(Icons.phone_android, size: 20, color: Color(0xFFD4145A)),
            SizedBox(width: 8),
            Text(
              "Phone Number",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),

        // Phone Input Field
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Color(0xFFD4145A).withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller.phoneController,
            keyboardType: TextInputType.number,
            maxLength: 10,
            onChanged: controller.onPhoneChanged,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            decoration: InputDecoration(
              prefixIcon: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "🇮🇳",
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "+91",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
              hintText: "10 digit number",
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding:
              EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              counterText: "",
            ),
          ),
        ),

        SizedBox(height: 30),

        // Send OTP Button with Loading Indicator
        Obx(() => AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: controller.phone.value.length == 10 ? 55 : 0,
          child: controller.phone.value.length == 10
              ? Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD4145A), Color(0xFFFF6B9D)],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFD4145A).withOpacity(0.4),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.sendOtp(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                disabledBackgroundColor: Colors.transparent,
              ),
              child: controller.isLoading.value
                  ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Send OTP",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          )
              : SizedBox.shrink(),
        )),

        SizedBox(height: 30),

        // Info Text
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFD4145A).withOpacity(0.1),
                Color(0xFFFFD700).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFD4145A).withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFFD4145A), size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "இந்த மொபைல் பயன்பாடு காட்டுநாயக்க மக்கள் சமுதாயத்துக்காக உருவாக்கப்பட்டது",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFD4145A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // OTP Section
  Widget _buildOtpSection() {
    return Column(
      key: ValueKey('otp'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back Button
        IconButton(
          onPressed: () {
            controller.showOtpField.value = false;
            controller.otpController.clear();
          },
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          padding: EdgeInsets.zero,
          alignment: Alignment.centerLeft,
        ),

        SizedBox(height: 10),

        Text(
          "Verify OTP",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),

        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            children: [
              TextSpan(text: "Code sent to "),
              TextSpan(
                text: "+91 ${controller.phone.value}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4145A),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 35),

        // OTP Label
        Row(
          children: [
            Icon(Icons.lock_outline, size: 20, color: Color(0xFFD4145A)),
            SizedBox(width: 8),
            Text(
              "OTP Code",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),

        // OTP Input Field
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Color(0xFFD4145A).withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller.otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            onChanged: controller.onOtpChanged,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
              color: Color(0xFFD4145A),
            ),
            decoration: InputDecoration(
              hintText: "• • • • • •",
              hintStyle: TextStyle(
                color: Colors.grey[300],
                fontSize: 24,
                letterSpacing: 8,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 20),
              counterText: "",
            ),
          ),
        ),

        SizedBox(height: 20),

        // Resend OTP
        Center(
          child: TextButton(
            onPressed: controller.isLoading.value
                ? null
                : () {
              controller.sendOtp();
              Get.snackbar(
                "Success",
                "OTP resent successfully",
                backgroundColor: Colors.green,
                colorText: Colors.white,
                icon: Icon(Icons.check_circle, color: Colors.white),
                snackPosition: SnackPosition.BOTTOM,
                margin: EdgeInsets.all(15),
                borderRadius: 10,
              );
            },
            child: Text(
              "Didn't receive code? Resend",
              style: TextStyle(
                fontSize: 14,
                color: controller.isLoading.value
                    ? Colors.grey
                    : Color(0xFFD4145A),
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),

        SizedBox(height: 25),

        // Submit Button with Loading Indicator
        Obx(() => AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: controller.otp.value.length == 6 ? 55 : 0,
          child: controller.otp.value.length == 6
              ? Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4CAF50),
                  Color(0xFF66BB6A),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF4CAF50).withOpacity(0.4),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.submitOtp(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                disabledBackgroundColor: Colors.transparent,
              ),
              child: controller.isLoading.value
                  ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,
                      color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Verify & Continue",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          )
              : SizedBox.shrink(),
        )),

        SizedBox(height: 25),

        // Security Info
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF9B59B6).withOpacity(0.1),
                Color(0xFFD4145A).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF9B59B6).withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.security, color: Color(0xFF9B59B6), size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "இந்த அனைத்து தரவுகளும் தமிழக அரசால் சேமிக்கப்பட்டுள்ளன ",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9B59B6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}