import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:neom_commons/core/ui/widgets/core_widgets.dart';
import 'package:neom_commons/core/ui/widgets/header_intro.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';
import 'package:neom_commons/core/utils/enums/profile_type.dart';
import 'onboarding_controller.dart';

class OnBoardingProfileTypePage extends StatelessWidget {
  const OnBoardingProfileTypePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
        id: AppPageIdConstants.onBoardingProfile,
        init: OnBoardingController(),
        builder: (_) => Scaffold(
          backgroundColor: AppColor.main50,
          body: SingleChildScrollView(
            child: Container(
              decoration: AppTheme.appBoxDecoration,
              width: AppTheme.fullWidth(context),
              height: AppTheme.fullHeight(context),
              child: Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  HeaderIntro(subtitle: AppTranslationConstants.introProfileType.tr),
                  AppTheme.heightSpace50,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buildActionChip(appEnum: ProfileType.musician,
                          controllerFunction: _.setProfileType),
                      AppTheme.heightSpace10,
                      buildActionChip(appEnum: ProfileType.facilitator,
                          controllerFunction: _.setProfileType),
                      AppTheme.heightSpace10,
                      buildActionChip(appEnum: ProfileType.host,
                          controllerFunction: _.setProfileType),
                      AppTheme.heightSpace10,
                      buildActionChip(appEnum: ProfileType.fan,
                          controllerFunction: _.setProfileType),
                    ]
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
