
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:neom_commons/core/ui/widgets/core_widgets.dart';
import 'package:neom_commons/core/ui/widgets/header_intro.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';
import 'package:neom_commons/core/utils/enums/facilitator_type.dart';
import 'onboarding_controller.dart';

class OnBoardingFacilityTypePage extends StatelessWidget {
  const OnBoardingFacilityTypePage({Key? key}) : super(key: key);



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
                HeaderIntro(subtitle: AppTranslationConstants.introProfileType.tr),
                AppTheme.heightSpace50,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    buildActionChip(appEnum: FacilityType.styleCorrector,
                        controllerFunction: _.setFacilityType),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: FacilityType.publisher,
                        controllerFunction: _.setFacilityType),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: FacilityType.printing,
                        controllerFunction: _.setFacilityType),
                    buildActionChip(appEnum: FacilityType.literaryWorkshop,
                        controllerFunction: _.setFacilityType),
                    buildActionChip(appEnum: FacilityType.designer,
                        controllerFunction: _.setFacilityType),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: FacilityType.podcaster,
                        controllerFunction: _.setFacilityType),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: FacilityType.photographer,
                        controllerFunction: _.setFacilityType),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: FacilityType.radio,
                        controllerFunction: _.setFacilityType),
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
