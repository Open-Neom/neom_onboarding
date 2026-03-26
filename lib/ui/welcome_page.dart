import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/ui/theme/app_theme.dart';
import 'package:neom_commons/utils/constants/app_assets.dart';
import 'package:neom_commons/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/utils/constants/translations/app_translation_constants.dart';
import 'package:neom_commons/utils/constants/translations/common_translation_constants.dart';
import 'package:neom_core/app_config.dart';
import 'package:neom_core/utils/enums/app_in_use.dart';
import 'package:sint/sint.dart';

import 'onboarding_controller.dart';

class WelcomePage extends StatelessWidget {

  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = kIsWeb && MediaQuery.of(context).size.width > 800;
    final logoSize = isWide ? 120.0 : (AppConfig.instance.appInUse == AppInUse.g ? 50.0 : 150.0);
    final titleSize = isWide ? 24.0 : 20.0;
    final subtitleSize = isWide ? 17.0 : 15.0;

    return SintBuilder<OnBoardingController>(
      id: AppPageIdConstants.onBoarding,
      builder: (_) => Scaffold(
        backgroundColor: AppColor.scaffold,
        body: Container(
          decoration: AppTheme.appBoxDecoration,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.isologoAppWhite,
                    height: logoSize,
                    width: logoSize,
                  ),
                  const SizedBox(height: 20),
                  Text(CommonTranslationConstants.splashSubtitle.tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: AppTheme.fontFamily,
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 30),
                  Text(AppTranslationConstants.welcome.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: AppTheme.fontFamily,
                      fontSize: subtitleSize,
                    ),
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
