import 'package:neom_core/ui/deferred_loader.dart';
import 'package:neom_core/utils/constants/app_route_constants.dart';
import 'package:sint/sint.dart';

import 'ui/onboarding_add_image_page.dart' deferred as add_image;
import 'ui/onboarding_simple_page.dart' deferred as simple;
import 'ui/onboarding_facility_page.dart' deferred as facility;
import 'ui/onboarding_locale_page.dart' deferred as locale;
import 'ui/onboarding_place_page.dart' deferred as place;
import 'ui/onboarding_profile_type_page.dart' deferred as profile_type;
import 'ui/onboarding_reason_page.dart' deferred as reason;
import 'ui/required_permissions_page.dart' deferred as permissions;
import 'ui/welcome_page.dart' deferred as welcome;

class OnBoardingRoutes {

  static final List<SintPage<dynamic>> routes = [
    SintPage(
      name: AppRouteConstants.introRequiredPermissions,
      page: () => DeferredLoader(permissions.loadLibrary, () => permissions.RequiredPermissionsPage()),
      transition: Transition.zoom,
    ),
    SintPage(
      name: AppRouteConstants.introLocale,
      page: () => DeferredLoader(locale.loadLibrary, () => locale.OnBoardingLocalePage()),
      transition: Transition.zoom,
    ),
    SintPage(
      name: AppRouteConstants.introProfile,
      page: () => DeferredLoader(profile_type.loadLibrary, () => profile_type.OnBoardingProfileTypePage()),
      transition: Transition.zoom,
    ),
    SintPage(
      name: AppRouteConstants.introFacility,
      page: () => DeferredLoader(facility.loadLibrary, () => facility.OnBoardingFacilityTypePage()),
      transition: Transition.rightToLeft,
    ),
    SintPage(
      name: AppRouteConstants.introPlace,
      page: () => DeferredLoader(place.loadLibrary, () => place.OnBoardingPlaceTypePage()),
      transition: Transition.rightToLeft,
    ),
    SintPage(
      name: AppRouteConstants.introReason,
      page: () => DeferredLoader(reason.loadLibrary, () => reason.OnBoardingReasonPage()),
      transition: Transition.rightToLeft,
    ),
    SintPage(
      name: AppRouteConstants.introSimple,
      page: () => DeferredLoader(simple.loadLibrary, () => simple.OnBoardingSimplePage()),
      transition: Transition.rightToLeft,
    ),
    SintPage(
      name: AppRouteConstants.introAddImage,
      page: () => DeferredLoader(add_image.loadLibrary, () => add_image.OnBoardingAddImagePage()),
      transition: Transition.rightToLeft,
    ),
    SintPage(
      name: AppRouteConstants.createAdditionalProfile,
      page: () => DeferredLoader(add_image.loadLibrary, () => add_image.OnBoardingAddImagePage()),
      transition: Transition.rightToLeft,
    ),
    SintPage(
      name: AppRouteConstants.introWelcome,
      page: () => DeferredLoader(welcome.loadLibrary, () => welcome.WelcomePage()),
      transition: Transition.zoom,
    ),
  ];

}
