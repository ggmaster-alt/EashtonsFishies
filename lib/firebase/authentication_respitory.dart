import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthenticationRespitory extends GetxController{
  static AuthenticationRespitory get instance => Get.find();

  final _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;


  bool get isAuthenticated => _auth.currentUser != null;

  @override
    void onReady(){
      _auth.setPersistence(Persistence.LOCAL);
  }
}