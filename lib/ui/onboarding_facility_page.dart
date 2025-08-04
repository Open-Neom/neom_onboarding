import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/ui/theme/app_theme.dart';
import 'package:neom_commons/ui/widgets/appbar_child.dart';
import 'package:neom_commons/ui/widgets/core_widgets.dart';
import 'package:neom_commons/ui/widgets/header_intro.dart';
import 'package:neom_commons/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/utils/constants/translations/common_translation_constants.dart';
import 'package:neom_core/app_config.dart';
import 'package:neom_core/utils/enums/app_in_use.dart';
import 'package:neom_core/utils/enums/facilitator_type.dart';

import 'onboarding_controller.dart';

class OnBoardingFacilityTypePage extends StatelessWidget {
  const OnBoardingFacilityTypePage({super.key});

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
            width: AppTheme.fullWidth(context),
            height: AppTheme.fullHeight(context),
            decoration: AppTheme.appBoxDecoration,
            child: Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                HeaderIntro(subtitle: CommonTranslationConstants.whatFacilitatorType.tr),
                AppTheme.heightSpace30,
                SizedBox(
                  height: AppTheme.fullHeight(context)/2,
                  child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        AppConfig.instance.appInUse == AppInUse.g
                            ? Column(children: [
                          buildActionChip(appEnum: FacilityType.recordStudio,
                              controllerFunction: _.setFacilityType),
                          AppTheme.heightSpace10,
                        ],) : const SizedBox.shrink(),
                        buildActionChip(appEnum: FacilityType.producer,
                            controllerFunction: _.setFacilityType),
                        AppTheme.heightSpace10,
                        buildActionChip(appEnum: FacilityType.publisher,
                            controllerFunction: _.setFacilityType),
                        AppTheme.heightSpace10,
                        buildActionChip(appEnum: FacilityType.printing,
                            controllerFunction: _.setFacilityType),
                        AppTheme.heightSpace10,
                        buildActionChip(appEnum: FacilityType.teacher,
                            controllerFunction: _.setFacilityType),
                        AppTheme.heightSpace10,
                        buildActionChip(appEnum: FacilityType.store,
                            controllerFunction: _.setFacilityType),
                        AppTheme.heightSpace10,
                        AppConfig.instance.appInUse == AppInUse.g
                            ? Column(children: [
                          buildActionChip(appEnum: FacilityType.soundRental,
                              controllerFunction: _.setFacilityType),
                          AppTheme.heightSpace10,
                        ],) : const SizedBox.shrink(),
                        AppConfig.instance.appInUse == AppInUse.g
                            ? Column(children: [
                          buildActionChip(appEnum: FacilityType.rehearsalRoom,
                              controllerFunction: _.setFacilityType),
                          AppTheme.heightSpace10,
                        ],) : const SizedBox.shrink(),
                        buildActionChip(appEnum: FacilityType.podcaster,
                            controllerFunction: _.setFacilityType),
                        AppTheme.heightSpace10,
                        buildActionChip(appEnum: FacilityType.radio,
                            controllerFunction: _.setFacilityType),
                        AppTheme.heightSpace30,
                      ]
                  ),
                  ),
                ),
              ],
            ),
            ),
        ),
      ),
    );
  }
}
