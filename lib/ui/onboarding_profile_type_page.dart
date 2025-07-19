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
import 'package:neom_core/utils/enums/profile_type.dart';

import '../utils/constants/onboarding_translation_constants.dart';
import 'onboarding_controller.dart';

class OnBoardingProfileTypePage extends StatelessWidget {
  const OnBoardingProfileTypePage({super.key});

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
            width: AppTheme.fullWidth(context),
            height: AppTheme.fullHeight(context),
            child: Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  HeaderIntro(subtitle: OnBoardingTranslationConstants.introProfileType.tr,),
                  AppTheme.heightSpace30,
                  buildActionChip(appEnum: ProfileType.appArtist,
                      controllerFunction: _.setProfileType),
                  AppTheme.heightSpace10,
                  buildActionChip(appEnum: ProfileType.facilitator,
                      controllerFunction: _.setProfileType),
                  AppTheme.heightSpace10,
                  buildActionChip(appEnum: ProfileType.host,
                      controllerFunction: _.setProfileType),
                  AppConfig.instance.appInUse == AppInUse.c ? Column(
                    children: [
                      AppTheme.heightSpace10,
                      buildActionChip(appEnum: ProfileType.researcher,
                          controllerFunction: _.setProfileType),
                    ],
                  ) : const SizedBox.shrink(),
                  AppTheme.heightSpace10,
                  buildActionChip(appEnum: ProfileType.general,
                      controllerFunction: _.setProfileType),
                ],
              ),
            ),

        ),
      ),
    );
  }
}
