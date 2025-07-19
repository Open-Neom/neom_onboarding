import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/ui/theme/app_theme.dart';
import 'package:neom_commons/utils/constants/app_assets.dart';
import 'package:neom_commons/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/utils/constants/translations/app_translation_constants.dart';
import 'package:neom_commons/utils/constants/translations/common_translation_constants.dart';
import 'package:neom_core/app_config.dart';
import 'package:neom_core/utils/enums/app_in_use.dart';

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
                  height: AppConfig.instance.appInUse == AppInUse.g ? 50 : 150,
                  width: 150,
                ),
                Column(
                  children: [
                    const SizedBox(height: 20,),
                    Text(CommonTranslationConstants.splashSubtitle.tr,
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
