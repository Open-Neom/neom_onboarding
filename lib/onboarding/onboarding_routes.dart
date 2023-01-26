import 'package:get/get.dart';

import 'package:neom_commons/core/utils/constants/app_route_constants.dart';
import 'ui/onboarding_add_image_page.dart';
import 'ui/onboarding_facility_page.dart';
import 'ui/onboarding_genres_page.dart';
import 'ui/onboarding_instruments_page.dart';
import 'ui/onboarding_locale_page.dart';
import 'ui/onboarding_place_page.dart';
import 'ui/onboarding_profile_type_page.dart';
import 'ui/onboarding_reason_page.dart';
import 'ui/required_permissions_page.dart';

class OnBoardingRoutes {

  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: AppRouteConstants.introRequiredPermissions,
      page: () => const RequiredPermissionsPage(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: AppRouteConstants.introLocale,
      page: () => const OnBoardingLocalePage(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: AppRouteConstants.introProfile,
      page: () => const OnBoardingProfileTypePage(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: AppRouteConstants.introInstruments,
      page: () => const OnBoardingInstrumentsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRouteConstants.introFacility,
      page: () => const OnBoardingFacilityTypePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRouteConstants.introPlace,
      page: () => const OnBoardingPlaceTypePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRouteConstants.introGenres,
      page: () => const OnBoardingGenresPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRouteConstants.introReason,
      page: () => const OnBoardingReasonPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRouteConstants.introAddImage,
      page: () => const OnBoardingAddImagePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRouteConstants.createAdditionalProfile,
      page: () => const OnBoardingAddImagePage(),
      transition: Transition.rightToLeft,
    ),
  ];

}
