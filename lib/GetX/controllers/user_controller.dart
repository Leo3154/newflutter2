import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


import '../model/user_model.dart';

class UserController extends GetxController {
  final user = User().obs;
  final editingController = TextEditingController();

  updateUser(String age) {
    user.update((val) {
      val?.userName = editingController.text;
      val?.userAge = age;
    });
  }
}