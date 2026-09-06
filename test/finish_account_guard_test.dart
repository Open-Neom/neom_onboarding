import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neom_core/domain/model/app_coupon.dart';
import 'package:neom_core/domain/model/app_user.dart';
import 'package:neom_core/domain/use_cases/media_upload_service.dart';
import 'package:neom_core/domain/use_cases/profile_service.dart';
import 'package:neom_core/domain/use_cases/user_service.dart';
import 'package:neom_core/utils/constants/app_route_constants.dart';
import 'package:neom_core/utils/enums/media_upload_destination.dart';
import 'package:neom_core/utils/platform/core_io.dart';
import 'package:neom_onboarding/ui/onboarding_controller.dart';
import 'package:sint/sint.dart';

class _UserService extends Fake implements UserService {
  _UserService({required this.isNewUser, required this.user});

  @override
  final bool isNewUser;
  @override
  final AppUser user;
  int createCalls = 0;

  @override
  Future<void> createUser() async => createCalls++;
}

class _MediaUploadService extends Fake implements MediaUploadService {
  int mediaReads = 0;
  int uploadCalls = 0;

  @override
  File getMediaFile() {
    mediaReads++;
    return File('/unused-profile-image.png');
  }

  @override
  Future<String?> uploadFile(MediaUploadDestination destination) async {
    uploadCalls++;
    return null;
  }
}

class _ProfileService extends Fake implements ProfileService {}

class _OnBoardingController extends OnBoardingController {
  int validationCalls = 0;
  int couponValidationCalls = 0;
  int couponHandlingCalls = 0;

  @override
  Future<String> newAccountValidation() async {
    validationCalls++;
    return '';
  }

  @override
  Future<String> validateCoupon(String couponCode) async {
    couponValidationCalls++;
    return '';
  }

  @override
  Future<bool> handleCoupon(AppCoupon? coupon) async {
    couponHandlingCalls++;
    return true;
  }
}

void main() {
  setUp(() => Sint.reset());
  tearDown(() => Sint.reset());

  for (final scenario in [
    (name: 'existing account', isNewUser: false, userId: 'existing-account'),
    (name: 'unknown account', isNewUser: false, userId: ''),
    (name: 'new account without identity', isNewUser: true, userId: ''),
  ]) {
    testWidgets('${scenario.name} returns to login before any side effects', (
      tester,
    ) async {
      final userService = _UserService(
        isNewUser: scenario.isNewUser,
        user: AppUser(id: scenario.userId),
      );
      final mediaService = _MediaUploadService();
      Sint.put<UserService>(userService);
      Sint.put<MediaUploadService>(mediaService);
      Sint.put<ProfileService>(_ProfileService());
      final controller = _OnBoardingController();
      controller.controllerCouponCode.text = 'must-not-be-applied';
      controller.isLoading.value = true;

      await tester.pumpWidget(
        SintMaterialApp(
          initialRoute: AppRouteConstants.introAddImage,
          sintPages: [
            SintPage(
              name: AppRouteConstants.introAddImage,
              page: () => const Scaffold(body: Text('Finish account')),
            ),
            SintPage(
              name: AppRouteConstants.login,
              page: () => const Scaffold(body: Text('Login')),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await controller.finishAccount();
      await tester.pumpAndSettle();

      expect(controller.isLoading.value, isFalse);
      expect(controller.validationCalls, 0);
      expect(controller.couponValidationCalls, 0);
      expect(controller.couponHandlingCalls, 0);
      expect(mediaService.mediaReads, 0);
      expect(mediaService.uploadCalls, 0);
      expect(userService.createCalls, 0);
      expect(Sint.currentRoute, AppRouteConstants.login);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Finish account'), findsNothing);
      expect(tester.takeException(), isNull);

      controller.controllerFullName.dispose();
      controller.controllerUsername.dispose();
      controller.controllerAboutMe.dispose();
      controller.controllerCouponCode.dispose();
      controller.controllerPhone.dispose();
      controller.focusNodeAboutMe.dispose();
      for (final textController in controller.smsCodeControllers) {
        textController.dispose();
      }
      for (final focusNode in controller.smsCodeFocusNodes) {
        focusNode.dispose();
      }
    });
  }
}
