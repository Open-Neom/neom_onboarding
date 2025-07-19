import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/ui/theme/app_theme.dart';
import 'package:neom_commons/ui/widgets/appbar_child.dart';
import 'package:neom_commons/ui/widgets/core_widgets.dart';
import 'package:neom_commons/ui/widgets/header_intro.dart';
import 'package:neom_commons/utils/constants/app_page_id_constants.dart';
import 'package:neom_core/utils/enums/usage_reason.dart';

import '../utils/constants/onboarding_translation_constants.dart';
import 'onboarding_controller.dart';

class OnBoardingReasonPage extends StatelessWidget {
  const OnBoardingReasonPage({super.key});


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
                  HeaderIntro(subtitle: OnBoardingTranslationConstants.introReason.tr,),
                  AppTheme.heightSpace30,
              SizedBox(
                height: AppTheme.fullHeight(context)*0.4,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AppTheme.heightSpace10,
                      buildActionChip(appEnum: UsageReason.casual,
                          controllerFunction: _.setReason),
                      AppTheme.heightSpace10,
                      buildActionChip(appEnum: UsageReason.professional,
                          controllerFunction: _.setReason),
                      AppTheme.heightSpace10,
                      buildActionChip(appEnum: UsageReason.any,
                          controllerFunction: _.setReason),
                    ]
                  ),
                ),
              ),],
            ),
          ),
        ),
      ),
    );
  }
}
