import 'package:neom_core/utils/constants/app_route_constants.dart';
import 'package:sint/sint.dart';

import 'ui/onboarding_add_image_page.dart';
import 'ui/onboarding_facility_page.dart';
import 'ui/onboarding_locale_page.dart';
import 'ui/onboarding_place_page.dart';
import 'ui/onboarding_profile_type_page.dart';
import 'ui/onboarding_reason_page.dart';
import 'ui/required_permissions_page.dart';
import 'ui/welcome_page.dart';

class OnBoardingRoutes {

  static final List<SintPage<dynamic>> routes = [
    SintPage(
      name: AppRouteConstants.introRequiredPermissions,
      page: () => const RequiredPermissionsPage(),
      transition: Transition.zoom,
    ),
    SintPage(
      name: AppRouteConstants.introLocale,
      page: () => const OnBoardingLocalePage(),
      transition: Transition.zoom,
    ),
    SintPage(
      name: AppRouteConstants.introProfile,
      page: () => const OnBoardingProfileTypePage(),
      transition: Transition.zoom,
    ),
    SintPage(
      name: AppRouteConstants.introFacility,
      page: () => const OnBoardingFacilityTypePage(),
      transition: Transition.rightToLeft,
    ),
    SintPage(
      name: AppRouteConstants.introPlace,
      page: () => const OnBoardingPlaceTypePage(),
      transition: Transition.rightToLeft,
    ),
    SintPage(
      name: AppRouteConstants.introReason,
      page: () => const OnBoardingReasonPage(),
      transition: Transition.rightToLeft,
    ),
    SintPage(
      name: AppRouteConstants.introAddImage,
      page: () => const OnBoardingAddImagePage(),
      transition: Transition.rightToLeft,
    ),
    SintPage(
      name: AppRouteConstants.createAdditionalProfile,
      page: () => const OnBoardingAddImagePage(),
      transition: Transition.rightToLeft,
    ),
    SintPage(
      name: AppRouteConstants.introWelcome,
      page: () => const WelcomePage(),
      transition: Transition.zoom,
    ),
  ];

}
