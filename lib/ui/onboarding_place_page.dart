import 'package:flutter/material.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/ui/theme/app_theme.dart';
import 'package:neom_commons/ui/widgets/appbar_child.dart';
import 'package:neom_commons/ui/widgets/core_widgets.dart';
import 'package:neom_commons/ui/widgets/header_intro.dart';
import 'package:neom_commons/ui/widgets/right_side_company_logo.dart';
import 'package:neom_commons/utils/constants/app_page_id_constants.dart';
import 'package:neom_core/utils/enums/place_type.dart';
import 'package:sint/sint.dart';

import '../utils/constants/onboarding_translation_constants.dart';
import 'onboarding_controller.dart';

class OnBoardingPlaceTypePage extends StatelessWidget {
  const OnBoardingPlaceTypePage({super.key});


  @override
  Widget build(BuildContext context) {
    return SintBuilder<OnBoardingController>(
        id: AppPageIdConstants.onBoarding,
        init: OnBoardingController(),
        builder: (controller) => Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBarChild(actionWidgets: [RightSideCompanyLogo()],),
          backgroundColor: AppColor.main50,
          body: Container(
            width: AppTheme.fullWidth(context),
            height: AppTheme.fullHeight(context),
            decoration: AppTheme.appBoxDecoration,
            child: Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                HeaderIntro(
                  showPreLogo: true,
                  subtitle: OnBoardingTranslationConstants.introEventPlannerType.tr
                ),
                AppTheme.heightSpace30,
              SizedBox(
                height: AppTheme.fullHeight(context)/2,
                child: SingleChildScrollView(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    buildActionChip(appEnum: PlaceType.academy,
                        controllerFunction: controller.setPlaceType),
                    buildActionChip(appEnum: PlaceType.bar,
                        controllerFunction: controller.setPlaceType),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: PlaceType.cafe,
                        controllerFunction: controller.setPlaceType),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: PlaceType.culturalCenter,
                        controllerFunction: controller.setPlaceType),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: PlaceType.forum,
                        controllerFunction: controller.setPlaceType),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: PlaceType.manager,
                        controllerFunction: controller.setPlaceType),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: PlaceType.publicSpace,
                        controllerFunction: controller.setPlaceType),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: PlaceType.restaurant,
                        controllerFunction: controller.setPlaceType),
                  ]),
                ),
              ),],
            ),
          ),),
      ),
    );
  }
}
