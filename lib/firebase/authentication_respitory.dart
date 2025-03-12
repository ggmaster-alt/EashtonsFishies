import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
// for checking user authentication
class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find(); // part of searching, this part is the holder of what it is searching for

  final _auth = FirebaseAuth.instance; // looks for users

  User? get user => _auth.currentUser; // looks at current user and gets uid


  bool get isAuthenticated => _auth.currentUser != null;

  @override
    void onReady(){
      _auth.setPersistence(Persistence.LOCAL);
  }
}