import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/app_flavour.dart';
import 'package:neom_commons/core/ui/widgets/appbar_child.dart';

import 'package:neom_commons/core/ui/widgets/core_widgets.dart';
import 'package:neom_commons/core/ui/widgets/header_intro.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';
import 'package:neom_commons/core/utils/enums/app_in_use.dart';
import 'package:neom_commons/core/utils/enums/app_locale.dart';
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
                HeaderIntro(subtitle: AppTranslationConstants.introLocale.tr),
                AppTheme.heightSpace30,
                buildActionChip(appEnum: AppLocale.english,
                    controllerFunction: _.setLocale, isActive: AppFlavour.appInUse == AppInUse.g),
                AppTheme.heightSpace10,
                buildActionChip(appEnum: AppLocale.spanish,
                    controllerFunction: _.setLocale),
                //TODO Add French and Deutsch Translations
                AppTheme.heightSpace10,
                buildActionChip(appEnum: AppLocale.french,
                    controllerFunction: _.setLocale, isActive: AppFlavour.appInUse == AppInUse.g),
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
