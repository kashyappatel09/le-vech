import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:le_vech/screens/Auth/noted_screen.dart';
import 'package:le_vech/screens/Home%20Screen/home_screen.dart';
import 'package:le_vech/utils/firebase_get.dart';
import 'package:le_vech/utils/snackbar.dart';
import 'package:le_vech/Widgets/string_const.dart';

class OTPController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<TextEditingController> verifyotp = TextEditingController().obs;
  FirebaseAuth? auth;
  RxList<QueryDocumentSnapshot> firebasedata = <QueryDocumentSnapshot>[].obs;

  void verifyOtp(BuildContext context, String varId, String mo) async {
    auth = FirebaseAuth.instance;
    final code = verifyotp.value.text.trim();
    try {
      isLoading.value = true;

      PhoneAuthCredential phonecredential = PhoneAuthProvider.credential(verificationId: varId, smsCode: code);
      UserCredential result = await auth!.signInWithCredential(phonecredential);

      print('OTP CODE ${phonecredential}');
      if (result.user != null) {
        getData(context, mo);
      } else {
        isLoading.value = false;

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Center(child: Text('Invalid Otp', style: TextStyle(color: Colors.black)))));
      }
    } catch (e) {
      isLoading.value = false;
      errorSnackBar(context, AppString.enterRightOtp);
    }
  }
  void getData(BuildContext context, String mo) async {
    firebasedata.value = await firebaseGetwhere('users', 'mobile_number', mo);

    if (firebasedata.isNotEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(mobileNo: mo)));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => NotedScreen(Mobile: mo)));
    }
    isLoading.value = false;
  }
}
