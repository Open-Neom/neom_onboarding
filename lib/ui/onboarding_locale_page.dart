import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/ui/theme/app_theme.dart';
import 'package:neom_commons/ui/widgets/core_widgets.dart';
import 'package:neom_commons/ui/widgets/header_intro.dart';
import 'package:neom_commons/ui/widgets/right_side_company_logo.dart';
import 'package:neom_commons/utils/constants/app_page_id_constants.dart';
import 'package:neom_core/app_config.dart';
import 'package:neom_core/utils/enums/app_in_use.dart';
import 'package:neom_core/utils/enums/app_locale.dart';
import 'package:sint/sint.dart';

import '../utils/constants/onboarding_translation_constants.dart';
import 'onboarding_controller.dart';

class OnBoardingLocalePage extends StatelessWidget {
  const OnBoardingLocalePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = kIsWeb && MediaQuery.of(context).size.width > 800;

    return SintBuilder<OnBoardingController>(
        id: AppPageIdConstants.onBoarding,
        init: OnBoardingController(),
        builder: (controller) => Scaffold(
          extendBodyBehindAppBar: true,
          appBar: SintAppBar(actions: [RightSideCompanyLogo()]),
          backgroundColor: AppColor.scaffold,
          body: Container(
            decoration: AppTheme.appBoxDecoration,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isWide ? 480 : double.infinity),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    HeaderIntro(
                      showPreLogo: true,
                      subtitle: OnBoardingTranslationConstants.introLocale.tr),
                    AppTheme.heightSpace30,
                    buildActionChip(appEnum: AppLocale.english,
                        controllerFunction: controller.setLocale, isActive: AppConfig.instance.appInUse == AppInUse.g),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: AppLocale.spanish,
                        controllerFunction: controller.setLocale),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: AppLocale.french,
                        controllerFunction: controller.setLocale, isActive: AppConfig.instance.appInUse == AppInUse.g),
                    AppTheme.heightSpace10,
                    buildActionChip(appEnum: AppLocale.deutsch,
                        controllerFunction: controller.setLocale),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
