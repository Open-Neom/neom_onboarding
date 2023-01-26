import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:neom_commons/core/ui/widgets/header_intro.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';
import 'onboarding_controller.dart';
import 'widgets/onboarding_instrument_list.dart';

class OnBoardingInstrumentsPage extends StatelessWidget {
  const OnBoardingInstrumentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
      id: AppPageIdConstants.onBoardingInstruments,
      init: OnBoardingController(),
      builder: (_) => Scaffold(
          body: Container(
            decoration: AppTheme.appBoxDecoration,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                AppTheme.heightSpace100,
                HeaderIntro(subtitle: AppTranslationConstants.introInstruments.tr),
                const Expanded(child: OnBoardingInstrumentList(),),
                ]
              ),
            ),
      floatingActionButton: _.instrumentController.favInstruments.values.isEmpty ? Container()
          : FloatingActionButton(
              tooltip: AppTranslationConstants.next.tr,
              elevation: AppTheme.elevationFAB,
              child: const Icon(Icons.navigate_next),
              onPressed: ()=>{
                _.addInstrumentToProfile()
            },
          ),
      ),
    );
  }
}
