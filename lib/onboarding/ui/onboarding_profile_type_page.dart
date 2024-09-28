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
import 'package:neom_commons/core/utils/enums/profile_type.dart';
import 'onboarding_controller.dart';

class OnBoardingProfileTypePage extends StatelessWidget {
  const OnBoardingProfileTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
        id: AppPageIdConstants.onBoardingProfile,
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
                  HeaderIntro(subtitle: AppTranslationConstants.introProfileType.tr,),
                  AppTheme.heightSpace30,
                  buildActionChip(appEnum: ProfileType.artist,
                      controllerFunction: _.setProfileType),
                  AppTheme.heightSpace10,
                  buildActionChip(appEnum: ProfileType.facilitator,
                      controllerFunction: _.setProfileType),
                  AppTheme.heightSpace10,
                  buildActionChip(appEnum: ProfileType.host,
                      controllerFunction: _.setProfileType),
                  AppFlavour.appInUse == AppInUse.c ? Column(
                    children: [
                      AppTheme.heightSpace10,
                      buildActionChip(appEnum: ProfileType.researcher,
                          controllerFunction: _.setProfileType),
                    ],
                  ) : const SizedBox.shrink(),
                  AppTheme.heightSpace10,
                  buildActionChip(appEnum: ProfileType.casual,
                      controllerFunction: _.setProfileType),
                ],
              ),
            ),

        ),
      ),
    );
  }
}
