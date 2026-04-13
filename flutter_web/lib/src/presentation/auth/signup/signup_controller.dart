import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/input_validators.dart';
import '../../../data/services/email_auth_api_service.dart';

class SignupController extends GetxController {
  SignupController({EmailAuthApiService? emailAuthApiService})
      : _emailAuthApiService = emailAuthApiService ?? EmailAuthApiService();

  final EmailAuthApiService _emailAuthApiService;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final codeController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isSendingCode = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool codeSent = false.obs;
  final RxBool isCodeExpired = false.obs;
  final RxInt secondsRemaining = 0.obs;

  Timer? _timer;
  DateTime? _expiresAt;

  String get countdownLabel {
    final minutes = (secondsRemaining.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsRemaining.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void resetCodeState() {
    _timer?.cancel();
    _timer = null;
    _expiresAt = null;
    codeSent.value = false;
    isCodeExpired.value = false;
    secondsRemaining.value = 0;
    codeController.clear();
  }

  Future<void> sendCode() async {
    FocusManager.instance.primaryFocus?.unfocus();
    errorMessage.value = '';

    final email = emailController.text.trim();

    if (!InputValidators.isValidEmail(email)) {
      errorMessage.value = 'Please enter a valid email address.';
      _showError('Email Error', errorMessage.value);
      return;
    }

    isSendingCode.value = true;

    try {
      final expiresAt = await _emailAuthApiService.sendCode(email: email);
      _expiresAt = expiresAt.toLocal();
      codeSent.value = true;
      isCodeExpired.value = false;
      _startTimer();

      Get.snackbar(
        'Verification Code Sent',
        'A verification code has been sent.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE9F8EF),
        colorText: const Color(0xFF172638),
        margin: const EdgeInsets.all(18),
      );
    } catch (error) {
      errorMessage.value = error.toString().replaceFirst('Exception: ', '');
      _showError('Send Failed', errorMessage.value);
    } finally {
      isSendingCode.value = false;
    }
  }

  Future<void> signup() async {
    FocusManager.instance.primaryFocus?.unfocus();
    errorMessage.value = '';

    final adminname = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final code = codeController.text.trim();

    if (adminname.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        code.isEmpty) {
      errorMessage.value = 'Please fill in all fields.';
      _showError('Input Error', errorMessage.value);
      return;
    }

    if (!InputValidators.isValidEmail(email)) {
      errorMessage.value = 'Please enter a valid email address.';
      _showError('Email Error', errorMessage.value);
      return;
    }

    if (!InputValidators.isValidPassword(password)) {
      errorMessage.value = 'Password must be at least 8 characters.';
      _showError('Password Error', errorMessage.value);
      return;
    }

    if (password != confirmPassword) {
      errorMessage.value = 'Passwords do not match.';
      _showError('Password Error', errorMessage.value);
      return;
    }

    if (!codeSent.value) {
      errorMessage.value = 'Please request a verification code first.';
      _showError('Verification Required', errorMessage.value);
      return;
    }

    if (isCodeExpired.value) {
      errorMessage.value = 'Verification code has expired. Please request a new one.';
      _showError('Verification Expired', errorMessage.value);
      return;
    }

    isLoading.value = true;

    try {
      await _emailAuthApiService.verifyAndSignup(
        adminname: adminname,
        email: email,
        password: password,
        code: code,
      );

      _timer?.cancel();
      isLoading.value = false;
      Get.back(result: 'admin');
      Get.snackbar(
        'Signup Complete',
        'Admin account has been created.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE9F8EF),
        colorText: const Color(0xFF172638),
        margin: const EdgeInsets.all(18),
      );
    } catch (error) {
      isLoading.value = false;
      errorMessage.value = error.toString().replaceFirst('Exception: ', '');
      _showError('Signup Failed', errorMessage.value);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_expiresAt == null) return;

    final diff = _expiresAt!.difference(DateTime.now());
    if (diff.isNegative || diff.inSeconds <= 0) {
      secondsRemaining.value = 0;
      isCodeExpired.value = true;
      _timer?.cancel();
      return;
    }

    secondsRemaining.value = diff.inSeconds;
  }

  void _showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFFCE9E9),
      colorText: const Color(0xFF8C1D1D),
      margin: const EdgeInsets.all(18),
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    codeController.dispose();
    super.onClose();
  }
}
