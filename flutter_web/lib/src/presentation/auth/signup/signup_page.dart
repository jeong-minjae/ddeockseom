import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth_routes.dart';
import '../widgets/auth_page_shell.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_button.dart';
import 'signup_controller.dart';

class SignupPage extends GetView<SignupController> {
  const SignupPage({super.key});

  Widget _buildEmailVerificationSection(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthTextField(
            label: 'Email',
            hintText: 'example@company.com',
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) {
              if (controller.errorMessage.value.isNotEmpty) {
                controller.errorMessage.value = '';
              }
              if (controller.codeSent.value) {
                controller.resetCodeState();
              }
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: controller.isSendingCode.value ? 'Sending...' : 'Send Code',
                  isLoading: controller.isSendingCode.value,
                  onPressed: controller.sendCode,
                ),
              ),
              if (controller.codeSent.value) ...[
                const SizedBox(width: 12),
                Text(
                  controller.isCodeExpired.value ? 'Expired' : controller.countdownLabel,
                  style: TextStyle(
                    color: controller.isCodeExpired.value
                        ? Colors.redAccent
                        : Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 18),
          AuthTextField(
            label: 'Verification Code',
            hintText: 'Enter the code you received',
            controller: controller.codeController,
            keyboardType: TextInputType.number,
            onChanged: (_) {
              if (controller.errorMessage.value.isNotEmpty) {
                controller.errorMessage.value = '';
              }
            },
          ),
          const SizedBox(height: 10),
          Text(
            controller.codeSent.value
                ? 'Enter the verification code and complete signup.'
                : 'Please send a verification code first.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildFormContent(BuildContext context) {
    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Admin Signup',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Create an admin account with email verification.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          AuthTextField(
            label: 'Admin Name',
            hintText: 'Enter admin name',
            controller: controller.nameController,
            onChanged: (_) {
              if (controller.errorMessage.value.isNotEmpty) {
                controller.errorMessage.value = '';
              }
            },
          ),
          const SizedBox(height: 18),
          _buildEmailVerificationSection(context),
          const SizedBox(height: 18),
          AuthTextField(
            label: 'Password',
            hintText: 'At least 8 characters',
            controller: controller.passwordController,
            obscureText: true,
          ),
          const SizedBox(height: 18),
          AuthTextField(
            label: 'Confirm Password',
            hintText: 'Re-enter your password',
            controller: controller.confirmPasswordController,
            obscureText: true,
          ),
          const SizedBox(height: 24),
          if (controller.errorMessage.value.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                controller.errorMessage.value,
                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500),
              ),
            ),
          PrimaryButton(
            label: 'Create Admin Account',
            isLoading: controller.isLoading.value,
            onPressed: controller.signup,
          ),
          const SizedBox(height: 16),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Already have an account?'),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, AuthRoutes.login),
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageShell(
      leftTitle: 'Admin Access',
      leftSubtitle: 'This web console is for developers and administrators only.',
      leftCaption: 'Email verification is required before creating an admin account.',
      leftImageAsset: 'images/park_view_photo_4.jpg',
      formCard: SingleChildScrollView(
        child: _buildFormContent(context),
      ),
    );
  }
}
