import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/ui/theme/app_theme.dart';
import 'package:neom_commons/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/utils/constants/translations/app_translation_constants.dart';
import 'package:neom_commons/utils/constants/translations/common_translation_constants.dart';
import 'package:neom_core/app_properties.dart';
import 'package:sint/sint.dart';

import '../utils/constants/onboarding_translation_constants.dart';
import 'onboarding_controller.dart';
import 'widgets/onboarding_widgets.dart';

/// Simple onboarding page for Itzli (email/pass signups).
/// Minimal: name + birthday + terms. Inspired by ChatGPT's signup.
class OnBoardingSimplePage extends StatelessWidget {
  const OnBoardingSimplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SintBuilder<OnBoardingController>(
      id: AppPageIdConstants.onBoarding,
      builder: (controller) => Scaffold(
        backgroundColor: AppColor.scaffold,
        body: Container(
          width: AppTheme.fullWidth(context),
          height: AppTheme.fullHeight(context),
          decoration: AppTheme.appBoxDecoration,
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: _buildContent(context, controller),
                  ),
                ),
              ),
              if (controller.isLoading.value)
                Container(
                  color: Colors.black87,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.bondiBlue),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, OnBoardingController controller) {
    final appName = AppProperties.getAppName();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // App logo
        if (AppProperties.getAppLogoUrl().isNotEmpty)
          Image.asset(
            AppProperties.getAppLogoUrl(),
            height: 48,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        const SizedBox(height: 24),

        // Title
        Text(
          '${AppTranslationConstants.welcome.tr} $appName',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: AppTheme.fontFamily,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

        // Subtitle
        Text(
          OnBoardingTranslationConstants.simpleOnboardingSubtitle.tr,
          style: TextStyle(
            color: Colors.white60,
            fontSize: 15,
            fontFamily: AppTheme.fontFamily,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 36),

        // Full name field
        _buildField(
          label: AppTranslationConstants.username.tr,
          controller: controller.controllerUsername,
        ),
        const SizedBox(height: 16),

        // Birthday
        buildEntryDateField(
          controller.dateOfBirth.value,
          context: context,
          dateFunction: controller.setDateOfBirth,
        ),
        const SizedBox(height: 28),

        // Terms text (not checkbox - implicit like ChatGPT)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                color: Colors.white54,
                fontSize: 13,
                fontFamily: AppTheme.fontFamily,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: OnBoardingTranslationConstants.byClickingFinish.tr,
                ),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () => _showTermsDialog(context, controller),
                    child: Text(
                      CommonTranslationConstants.termsAndConditions.tr,
                      style: const TextStyle(
                        color: AppColor.bondiBlue,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                TextSpan(
                  text: OnBoardingTranslationConstants.andPrivacyPolicy.tr,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Finish button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _finish(controller),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            child: Text(
              OnBoardingTranslationConstants.finishAccount.tr,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white54),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.bondiBlue),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }

  void _finish(OnBoardingController controller) {
    // Accept terms implicitly (like ChatGPT)
    controller.setTermsAgreement(true);
    if (controller.userServiceImpl.user.currentProfileId.isEmpty) {
      controller.finishAccount();
    } else {
      controller.createAdditionalProfile();
    }
  }

  void _showTermsDialog(BuildContext context, OnBoardingController controller) {
    Sint.toNamed('/terms');
  }
}
