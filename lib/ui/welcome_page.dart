import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/ui/theme/app_theme.dart';
import 'package:neom_commons/utils/constants/app_assets.dart';
import 'package:neom_commons/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/utils/constants/translations/app_translation_constants.dart';
import 'package:neom_commons/utils/constants/translations/common_translation_constants.dart';
import 'package:neom_core/app_config.dart';
import 'package:neom_core/domain/use_cases/user_service.dart';
import 'package:neom_core/utils/constants/app_route_constants.dart';
import 'package:neom_core/utils/enums/app_in_use.dart';
import 'package:sint/sint.dart';
import 'package:neom_commons/utils/auth_guard.dart';

import 'onboarding_controller.dart';

class WelcomePage extends StatefulWidget {

  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Timer? _pollTimer;
  Timer? _safetyTimer;

  @override
  void initState() {
    super.initState();

    // Poll: as soon as user creation finishes (currentProfileId is populated),
    // navigate to home. Covers the case where createUser's offAllNamed(home)
    // gets lost in a race with the welcome-page navigation that preceded it.
    _pollTimer = Timer.periodic(const Duration(milliseconds: 500), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (Sint.isRegistered<UserService>()) {
        final user = Sint.find<UserService>().user;
        if (user.currentProfileId.isNotEmpty && user.id.isNotEmpty) {
          t.cancel();
          if (AuthGuard.pendingRedirectRoute != null) {
            final nextRoute = AuthGuard.pendingRedirectRoute!;
            final nextArgs = AuthGuard.pendingRedirectArgs;
            AuthGuard.pendingRedirectRoute = null;
            AuthGuard.pendingRedirectArgs = null;
            AppConfig.logger.i("Redirecting to pending nextRoute from welcome page: $nextRoute");
            Sint.offAllNamed(nextRoute, arguments: nextArgs);
          } else {
            Sint.offAllNamed(AppRouteConstants.home);
          }
        }
      }
    });

    // Safety: even if user creation silently fails or stalls, eject after 15s
    // to root so the user is not trapped here.
    _safetyTimer = Timer(const Duration(seconds: 15), () {
      if (mounted) Sint.offAllNamed(AppRouteConstants.root);
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _safetyTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = kIsWeb && MediaQuery.of(context).size.width > 800;
    final logoSize = isWide ? 120.0 : (AppConfig.instance.appInUse == AppInUse.g ? 50.0 : 150.0);
    final titleSize = isWide ? 24.0 : 20.0;
    final subtitleSize = isWide ? 17.0 : 15.0;

    return SintBuilder<OnBoardingController>(
      id: AppPageIdConstants.onBoarding,
      init: OnBoardingController(),
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
