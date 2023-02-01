import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/ui/widgets/appbar_child.dart';

import 'package:neom_commons/core/ui/widgets/core_widgets.dart';
import 'package:neom_commons/core/ui/widgets/header_intro.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';
import 'package:neom_commons/core/utils/enums/place_type.dart';
import 'onboarding_controller.dart';

class OnBoardingPlaceTypePage extends StatelessWidget {
  const OnBoardingPlaceTypePage({Key? key}) : super(key: key);


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
            child: Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                HeaderIntro(subtitle: AppTranslationConstants.introProfileType.tr),
                AppTheme.heightSpace50,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    buildActionChip(appEnum: PlaceType.academy,
                        controllerFunction: _.setPlaceType),
                    buildActionChip(appEnum: PlaceType.bar,
                        controllerFunction: _.setPlaceType),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: PlaceType.cafe,
                        controllerFunction: _.setPlaceType),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: PlaceType.culturalCenter,
                        controllerFunction: _.setPlaceType),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: PlaceType.forum,
                        controllerFunction: _.setPlaceType),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: PlaceType.manager,
                        controllerFunction: _.setPlaceType),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: PlaceType.publicSpace,
                        controllerFunction: _.setPlaceType),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: PlaceType.restaurant,
                        controllerFunction: _.setPlaceType),
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
