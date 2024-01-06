import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:le_vech/Controller/Auth%20Controller/noted_controller.dart';
import 'package:le_vech/Controller/Profile%20Controller/profile_controller.dart';
import 'package:le_vech/Widgets/image_const.dart';
import 'package:le_vech/Widgets/string_const.dart';
import 'package:le_vech/utils/firebase_get.dart';

class AllCategoryController extends GetxController {
  ProfileController profileController = Get.put(ProfileController());
  NotedController notedController = Get.put(NotedController());

  RxBool isIcon = true.obs;
  RxBool isLodingData = false.obs;

  List<String> imageList = [AppImage.allCategory, AppImage.tractorEicher, AppImage.cow, AppImage.horse, AppImage.bike, AppImage.car, AppImage.imglogo];
  List itemName = [AppImage.allCategory, AppString.tractor, AppString.cow, AppString.horse, AppString.twoWheel, AppString.fourWheel, AppString.others];
  RxList<QueryDocumentSnapshot> profileData = <QueryDocumentSnapshot>[].obs;
  RxBool isLoader = false.obs;

  getAllads(BuildContext context) async {
    try {
      isLodingData.value = true;
      profileData.value = await firebaseGet('advertise');
      if (profileData.isNotEmpty) {
        print("GET ALL ADS................................................");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No Data Found")));
      }
      isLodingData.value = false;
    } on Exception catch (e) {
      isLodingData.value = false;
      print(e);
    }
  }

  addFavorite(BuildContext context) {
    try {
      updateData('users', profileController.mo!, {'favorite_list': notedController.favoriteList});
    } on Exception catch (e) {
      print(e);
    }
  }
}
