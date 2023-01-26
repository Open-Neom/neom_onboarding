import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:neom_commons/core/ui/widgets/core_widgets.dart';
import 'package:neom_commons/core/ui/widgets/header_intro.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';
import 'package:neom_commons/core/utils/enums/app_locale.dart';
import 'onboarding_controller.dart';

class OnBoardingLocalePage extends StatelessWidget {
  const OnBoardingLocalePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
        id: AppPageIdConstants.onBoardingProfile,
        init: OnBoardingController(),
        builder: (_) => Scaffold(
          backgroundColor: AppColor.main50,
          body: Container(
            decoration: AppTheme.appBoxDecoration,
            child: Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                HeaderIntro(subtitle: AppTranslationConstants.introLocale.tr),
                AppTheme.heightSpace50,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    buildActionChip(appEnum: AppLocale.english,
                        controllerFunction: _.setLocale),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: AppLocale.spanish,
                        controllerFunction: _.setLocale),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: AppLocale.french,
                        controllerFunction: _.setLocale, isActive: false),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: AppLocale.deutsch,
                        controllerFunction: _.setLocale, isActive: false),
                  ]
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
