import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/ui/widgets/appbar_child.dart';

import 'package:neom_commons/core/ui/widgets/core_widgets.dart';
import 'package:neom_commons/core/ui/widgets/header_intro.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';
import 'package:neom_commons/core/utils/enums/usage_reason.dart';
import 'onboarding_controller.dart';

class OnBoardingReasonPage extends StatelessWidget {
  const OnBoardingReasonPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
        id: AppPageIdConstants.onBoardingReason,
        init: OnBoardingController(),
        builder: (_) => Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBarChild(color: Colors.transparent),
          body: SingleChildScrollView(
            child: Container(
              decoration: AppTheme.appBoxDecoration,
              width: AppTheme.fullWidth(context),
              height: AppTheme.fullHeight(context),
              child: Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  HeaderIntro(subtitle: AppTranslationConstants.introReason.tr),
                  AppTheme.heightSpace50,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AppTheme.heightSpace10,
                      buildActionChip(appEnum: UsageReason.fun,
                          controllerFunction: _.setReason),
                      AppTheme.heightSpace10,
                      buildActionChip(appEnum: UsageReason.professional,
                          controllerFunction: _.setReason),
                      AppTheme.heightSpace10,
                      buildActionChip(appEnum: UsageReason.composition,
                          controllerFunction: _.setReason),
                      AppTheme.heightSpace10,
                      buildActionChip(appEnum: UsageReason.any,
                          controllerFunction: _.setReason),
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
