import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserRespitory extends GetxController{
  static UserRespitory get instance => Get.find(); // part of searching in database
  final _db = FirebaseFirestore.instance; //collects layout of the database

  Future<void> addUser(Map<String, dynamic> data) async { // time if this doesn't work: 15.20
    await _db.collection('users').add(data);
  }
}