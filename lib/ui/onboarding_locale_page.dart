import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/ui/theme/app_theme.dart';
import 'package:neom_commons/ui/widgets/appbar_child.dart';
import 'package:neom_commons/ui/widgets/core_widgets.dart';
import 'package:neom_commons/ui/widgets/header_intro.dart';
import 'package:neom_commons/utils/constants/app_page_id_constants.dart';
import 'package:neom_core/app_config.dart';
import 'package:neom_core/utils/enums/app_in_use.dart';
import 'package:neom_core/utils/enums/app_locale.dart';

import '../utils/constants/onboarding_translation_constants.dart';
import 'onboarding_controller.dart';

class OnBoardingLocalePage extends StatelessWidget {
  const OnBoardingLocalePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
        id: AppPageIdConstants.onBoarding,
        init: OnBoardingController(),
        builder: (_) => Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBarChild(color: Colors.transparent),
          backgroundColor: AppColor.main50,
          body: Container(
            decoration: AppTheme.appBoxDecoration,
            child: Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                HeaderIntro(subtitle: OnBoardingTranslationConstants.introLocale.tr),
                AppTheme.heightSpace30,
                buildActionChip(appEnum: AppLocale.english,
                    controllerFunction: _.setLocale, isActive: AppConfig.instance.appInUse == AppInUse.g),
                AppTheme.heightSpace10,
                buildActionChip(appEnum: AppLocale.spanish,
                    controllerFunction: _.setLocale),
                //TODO Add French and Deutsch Translations
                AppTheme.heightSpace10,
                buildActionChip(appEnum: AppLocale.french,
                    controllerFunction: _.setLocale, isActive: AppConfig.instance.appInUse == AppInUse.g),
                // AppTheme.heightSpace10,
                // buildActionChip(appEnum: AppLocale.deutsch,
                //     controllerFunction: _.setLocale, isActive: false),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
