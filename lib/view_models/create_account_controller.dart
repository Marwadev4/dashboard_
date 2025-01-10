import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// CreateAccountController
class CreateAccountController extends GetxController {
  var isLoading = false.obs;
  var rememberMe = false.obs;
  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  Future<void> createAccount(String email, String password) async {
    isLoading.value = true;
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      Get.snackbar(
          "Success", "Account created successfully. Please verify your email.",
          backgroundColor: Colors.green, colorText: Colors.white);

      Get.offNamed("/home");
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthErrors(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkIfEmailExists(String email) async {
    try {
      final list =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (list.isNotEmpty) {
        Get.snackbar("Email Exists", "This email is already registered.",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      } else {
        Get.snackbar("Email Available", "This email is available.",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to check email. Try again later.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  void _handleFirebaseAuthErrors(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'weak-password':
        message = "The password is too weak.";
        break;
      case 'email-already-in-use':
        message = "This email is already registered.";
        break;
      case 'invalid-email':
        message = "The email address is invalid.";
        break;
      default:
        message = e.message ?? "An error occurred.";
    }
    Get.snackbar("Error", message,
        backgroundColor: Colors.redAccent, colorText: Colors.white);
  }
}
