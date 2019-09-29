import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password, String phoneNumber, String name);
  Future<FirebaseUser> getCurrentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return result.user.uid;
  }

  Future<String> signUp(String email, String password, String phoneNumber, String name) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    
    UserUpdateInfo updateUser = UserUpdateInfo();
    updateUser.displayName = name;

    await user.updateProfile(updateUser);


    return result.user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> verifyPhone(phoneNumber) async {
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(minutes: 2),
        verificationCompleted: (credential) async {
          await (await FirebaseAuth.instance.currentUser()).updatePhoneNumberCredential(credential);
          // either this occurs or the user needs to manually enter the SMS code
        },
        verificationFailed: null,
        codeSent: (verificationId, [forceResendingToken]) async {
          String smsCode = "23FGH";
          // get the SMS code from the user somehow (probably using a text field)
          final AuthCredential credential =
            PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: smsCode);
          await (await FirebaseAuth.instance.currentUser()).updatePhoneNumberCredential(credential);
        },
        codeAutoRetrievalTimeout: null);
  }
  
}