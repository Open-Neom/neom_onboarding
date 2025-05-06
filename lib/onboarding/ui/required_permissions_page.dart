import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/neom_commons.dart';

import 'onboarding_controller.dart';

class RequiredPermissionsPage extends StatelessWidget {

  const RequiredPermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
        id: AppPageIdConstants.onBoardingAddImage,
        init: OnBoardingController(),
    builder: (_) => PopScope(
      onPopInvoked: (didPop) async {
        await Get.find<LoginController>().signOut();
      },
      child: SafeArea(child: Scaffold(
        backgroundColor: AppColor.main50,
        body: SingleChildScrollView(
          child: Container(
            decoration: AppTheme.appBoxDecoration,
            height: AppTheme.fullHeight(context),
            width: AppTheme.fullWidth(context),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTheme.heightSpace20,
                SizedBox(
                  width: AppTheme.fullWidth(context)/2,
                  child: Image.asset(AppAssets.intro02,
                      fit: BoxFit.fill),
                ),
                AppTheme.heightSpace10,
                Text(AppTranslationConstants.locationRequiredTitle.tr,
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600
                  ),
                  textAlign: TextAlign.center,
                ),
                AppTheme.heightSpace10,
                Text(AppTranslationConstants.locationRequiredMsg1.tr,
                    style: const TextStyle(fontSize: 18),textAlign: TextAlign.justify
                ),
                AppTheme.heightSpace20,
                AppTranslationConstants.locationRequiredMsg2.isNotEmpty ? Text(AppTranslationConstants.locationRequiredMsg2.tr,
                    style: const TextStyle(fontSize: 18),textAlign: TextAlign.justify) : const SizedBox.shrink(),
                AppTheme.heightSpace20,
                TextButton(
                  onPressed: () async {
                    try {
                      _.setLocation();
                    } catch (e) {
                      Get.toNamed(AppRouteConstants.logout,
                          arguments: [AppRouteConstants.introRequiredPermissions]
                      );
                      Get.snackbar(
                        MessageTranslationConstants.userCurrentLocation.tr,
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
                Text('(${AppTranslationConstants.changeThisSettingLater.tr})',
                    style: const TextStyle(fontSize: 15),
                    textAlign: TextAlign.justify),
                AppTheme.heightSpace20,
              ],
            ),),
          ),
        ),
      ),),
      ),
    );
  }
}
