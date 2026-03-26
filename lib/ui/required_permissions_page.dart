import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/ui/theme/app_theme.dart';
import 'package:neom_commons/ui/widgets/app_circular_progress_indicator.dart';
import 'package:neom_commons/utils/constants/app_assets.dart';
import 'package:neom_commons/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/utils/constants/translations/app_translation_constants.dart';
import 'package:neom_commons/utils/constants/translations/common_translation_constants.dart';
import 'package:neom_commons/utils/constants/translations/message_translation_constants.dart';
import 'package:neom_core/domain/use_cases/login_service.dart';
import 'package:neom_core/utils/constants/app_route_constants.dart';
import 'package:sint/sint.dart';

import '../utils/constants/onboarding_translation_constants.dart';
import 'onboarding_controller.dart';

class RequiredPermissionsPage extends StatelessWidget {

  const RequiredPermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SintBuilder<OnBoardingController>(
      id: AppPageIdConstants.onBoarding,
      init: OnBoardingController(),
      builder: (controller) {
        // Web: skip geolocation, detect locale from browser and go straight to profile
        if (kIsWeb && !controller.hasNavigatedFromPermissions) {
          controller.hasNavigatedFromPermissions = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.setLocationFromBrowser();
          });
          return Scaffold(
            backgroundColor: AppColor.scaffold,
            body: const AppCircularProgressIndicator(),
          );
        }

        return PopScope(
          onPopInvoked: (didPop) async {
            await Sint.find<LoginService>().signOut();
          },
          child: SafeArea(
            child: Scaffold(
              backgroundColor: AppColor.scaffold,
              body: Container(
                decoration: AppTheme.appBoxDecoration,
                height: AppTheme.fullHeight(context),
                width: AppTheme.fullWidth(context),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Obx(()=>controller.isLoading.value ? AppCircularProgressIndicator() : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppTheme.heightSpace20,
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320, maxHeight: 320),
                        child: Image.asset(AppAssets.intro02,
                            fit: BoxFit.contain),
                      ),
                      AppTheme.heightSpace10,
                      Text(CommonTranslationConstants.locationRequiredTitle.tr,
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppTheme.heightSpace10,
                      Text(MessageTranslationConstants.locationRequiredMsg1.tr,
                          style: const TextStyle(fontSize: 18),textAlign: TextAlign.justify
                      ),
                      AppTheme.heightSpace20,
                      MessageTranslationConstants.locationRequiredMsg2.isNotEmpty ? Text(MessageTranslationConstants.locationRequiredMsg2.tr,
                          style: const TextStyle(fontSize: 18),textAlign: TextAlign.justify) : const SizedBox.shrink(),
                      AppTheme.heightSpace20,
                      TextButton(
                        onPressed: () async {
                          try {
                            controller.setLocation();
                          } catch (e) {
                            Sint.toNamed(AppRouteConstants.logout,
                                arguments: [AppRouteConstants.introRequiredPermissions]
                            );
                            Sint.snackbar(
                              CommonTranslationConstants.userCurrentLocation.tr,
                              MessageTranslationConstants.userCurrentLocationErrorMsg.tr,
                              snackPosition: SnackPosition.bottom,);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          width: MediaQuery.of(context).size.width*0.66,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 2,
                                    color: Colors.grey,
                                    offset: Offset(0,2)
                                )
                              ]
                          ),
                          child: Text(AppTranslationConstants.toContinue.tr.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 18,
                                color: AppColor.textButton,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppTheme.fontFamily
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      AppTheme.heightSpace20,
                      Text('(${OnBoardingTranslationConstants.changeThisSettingLater.tr})',
                          style: const TextStyle(fontSize: 15),
                          textAlign: TextAlign.justify),
                      AppTheme.heightSpace20,
                    ],
                  ),
                ),
              ),),
            ),
          ),
        );
      },
    );
  }
}
