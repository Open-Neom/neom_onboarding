import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/neom_commons.dart';

import 'onboarding_controller.dart';

class WelcomePage extends StatelessWidget {

  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
      id: AppPageIdConstants.onBoarding,
      builder: (_) => Scaffold(
        backgroundColor: AppColor.main50,
        body: Container(
          decoration: AppTheme.appBoxDecoration,
          child: Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppAssets.logoAppWhite,
                  height: AppFlavour.appInUse == AppInUse.g ? 50 : 150,
                  width: 150,
                ),
                Column(
                  children: [
                    const SizedBox(height: 20,),
                    Text(AppTranslationConstants.splashSubtitle.tr,
                      style: TextStyle(
                          color: Colors.white.withOpacity(1.0),
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30,),
                const CircularProgressIndicator(),
                const SizedBox(height: 30,),
                Obx(() => Text(AppTranslationConstants.welcome.tr,
                    style: TextStyle(
                      color: Colors.white.withOpacity(1.0),
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }

}
