import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:neom_bank/bank/data/implementations/app_bank_controller.dart';
import 'package:neom_commons/commons/app_flavour.dart';
import 'package:neom_commons/commons/utils/app_utilities.dart';
import 'package:neom_commons/commons/utils/constants/app_locale_constants.dart';
import 'package:neom_commons/commons/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/commons/utils/constants/app_translation_constants.dart';
import 'package:neom_commons/commons/utils/constants/intl_countries_list.dart';
import 'package:neom_commons/commons/utils/constants/message_translation_constants.dart';
import 'package:neom_core/core/app_config.dart';
import 'package:neom_core/core/data/firestore/coupon_firestore.dart';
import 'package:neom_core/core/data/firestore/profile_firestore.dart';
import 'package:neom_core/core/data/firestore/user_firestore.dart';
import 'package:neom_core/core/data/implementations/app_hive_controller.dart';
import 'package:neom_core/core/data/implementations/user_controller.dart';
import 'package:neom_core/core/domain/model/app_coupon.dart';
import 'package:neom_core/core/domain/model/facility.dart';
import 'package:neom_core/core/domain/model/place.dart';
import 'package:neom_core/core/domain/use_cases/login_service.dart';
import 'package:neom_core/core/domain/use_cases/onboarding_service.dart';
import 'package:neom_core/core/utils/constants/app_route_constants.dart';
import 'package:neom_core/core/utils/constants/core_constants.dart';
import 'package:neom_core/core/utils/enums/app_in_use.dart';
import 'package:neom_core/core/utils/enums/app_locale.dart';
import 'package:neom_core/core/utils/enums/coupon_type.dart';
import 'package:neom_core/core/utils/enums/facilitator_type.dart';
import 'package:neom_core/core/utils/enums/place_type.dart';
import 'package:neom_core/core/utils/enums/profile_type.dart';
import 'package:neom_core/core/utils/enums/subscription_level.dart';
import 'package:neom_core/core/utils/enums/transaction_type.dart';
import 'package:neom_core/core/utils/enums/upload_image_type.dart';
import 'package:neom_core/core/utils/enums/usage_reason.dart';
import 'package:neom_core/core/utils/validator.dart';
import 'package:neom_posts/posts/ui/upload/post_upload_controller.dart';
import 'package:neom_profile/neom_profile.dart';

class OnBoardingController extends GetxController implements OnBoardingService {

  final userController = Get.find<UserController>();
  final postUploadController = Get.put(PostUploadController());
  final profileController = Get.put(ProfileController());

  TextEditingController controllerFullName = TextEditingController();
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerAboutMe = TextEditingController();
  TextEditingController controllerCouponCode = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool agreeTerms = false.obs;
  final Rxn<DateTime> dateOfBirth = Rxn<DateTime>();
  final DateTime minAllowedDate = DateTime(CoreConstants.lastYearDOB, 1, 1);

  final Rx<Country> phoneCountry = IntlPhoneConstants.availableCountries[0].obs;

  AppCoupon? validCoupon;
  String countryCode = '';
  String phoneNumber = '';
  String aboutMe = '';

  final FocusNode focusNodeAboutMe = FocusNode();
  bool optionalPhoneNumber = true;

  @override
  void onInit() async {
    super.onInit();
    controllerFullName.text = userController.user.name;
    controllerUsername.text = userController.user.name;

    for (var country in countries) {
      if(Get.locale!.countryCode == country.code){
        phoneCountry.value = country; //Mexico
      }
    }

  }

  void setLocale(AppLocale locale) async {
    AppHiveController().setLocale(locale);
    AppHiveController().updateLocale(locale);
    update([AppPageIdConstants.onBoarding]);
    Get.toNamed(AppRouteConstants.introAddImage);
  }

  @override
  void setProfileType(ProfileType profileType) {
    AppConfig.logger.d("ProfileType registered as ${profileType.name}");
    userController.newProfile.type = profileType;

    update([AppPageIdConstants.onBoarding]);

    if(AppFlavour.appInUse == AppInUse.c) {
      Get.toNamed(AppRouteConstants.introAddImage);
    } else {
      switch(profileType) {
        case(ProfileType.appArtist):
        case(ProfileType.band):
          Get.toNamed(AppRouteConstants.introReason);
          break;
        case(ProfileType.facilitator):
          Get.toNamed(AppRouteConstants.introFacility);
          break;
        case(ProfileType.host):
          Get.toNamed(AppRouteConstants.introPlace);
          break;
        default:
          Get.toNamed(AppRouteConstants.introGenres);
          break;
      }
    }

  }

  @override
  void setReason(UsageReason reason) {
    AppConfig.logger.d("ProfileType registered Reason as ${reason.name}");
    userController.newProfile.usageReason = reason;
    Get.toNamed(AppRouteConstants.introInstruments);
    update([AppPageIdConstants.onBoarding]);
  }

  @override
  void handleImage() async {
    await postUploadController.handleImage(imageType: UploadImageType.profile);
    update([AppPageIdConstants.onBoarding]);
  }

  @override
  void setDateOfBirth(DateTime? pickedDate) {
    AppConfig.logger.d("setDateOfBirth");
    try {
      if (pickedDate != null && isValidDOB(pickedDate)) {
        dateOfBirth.value = pickedDate;
      }
    } catch (e) {
      AppConfig.logger.e(e.toString());
    }

    update([AppPageIdConstants.onBoarding]);
  }

  bool isValidDOB(DateTime? dob) {
    if (dob == null) {
      AppConfig.logger.w("Date of birth is null.");
      return false;
    }

    if (dob.isBefore(minAllowedDate)) {
      return true;
    } else {
      AppConfig.logger.w("Invalid DOB: Must be before 2010.");
      return false;
    }
  }

  @override
  void setTermsAgreement(bool agree) {
    AppConfig.logger.t("setTermsAgreement");
    try {
      agreeTerms.value = agree;
    } catch (e) {
      AppConfig.logger.e(e.toString());
    }

    update([AppPageIdConstants.onBoarding]);
  }

  @override
  Future<void> finishAccount() async {
    AppConfig.logger.i("Finishing and creating account");
    focusNodeAboutMe.unfocus();
    isLoading.value = true;

    try {
      String validateMsg = await newAccountValidation();

      if(validateMsg.isEmpty) {
        if(controllerCouponCode.text.trim().isNotEmpty) {
          validateMsg = await validateCoupon(controllerCouponCode.text.trim());
        }

        if(validateMsg.isEmpty) {
          AppConfig.logger.d('Finishing Account - HandlingCoupon');

          userController.newProfile.aboutMe = controllerAboutMe.text.trim();
          userController.newProfile.name = controllerUsername.text.trim();

          bool couponHandled = await handleCoupon(validCoupon);

          if(validCoupon == null || couponHandled) {
            AppConfig.logger.d('Finishing Account - Welcome & Creating User');
            Get.toNamed(AppRouteConstants.introWelcome);

            if(postUploadController.mediaFile.value.path.isNotEmpty) {
              userController.user.photoUrl = await postUploadController.handleUploadImage(UploadImageType.profile);
            }
            await userController.createUser();
          }

        }
      }

      if(validateMsg.isNotEmpty) {
        AppConfig.logger.w(validateMsg.tr);
        Get.snackbar(MessageTranslationConstants.finishingAccount.tr,
            validateMsg.tr, snackPosition: SnackPosition.bottom);
      }
    } catch (e) {
      AppConfig.logger.e(e.toString());
    }

    isLoading.value = false;
  }

  Future<String> validateCoupon(String couponCode) async {
    validCoupon = await CouponFirestore().getCouponByCode(couponCode);
    if(validCoupon == null || (validCoupon?.id.isEmpty ?? true) || (validCoupon?.usedBy?.length ?? 0) >= (validCoupon?.usageLimit ?? 0)) {
      return AppTranslationConstants.invalidCouponCodeMsg.tr;
    } else {
      return '';
    }
  }

  Future<bool> handleCoupon(AppCoupon? coupon) async {
    if(coupon == null) return false;

    AppConfig.logger.i("Handling coupon ${coupon.code}");

    AppBankController bankController = AppBankController();

    userController.user.referralCode = coupon.code;

    if(coupon.usedBy?.contains(userController.user.email) ?? false) {
      Get.snackbar(AppTranslationConstants.appliedCouponCode.tr,
          AppTranslationConstants.couponAlreadyUsed.tr,
          snackPosition: SnackPosition.bottom);
      return false;
    } else if(coupon.type == CouponType.oneMonthFree) {
      bankController.addCoinsToWallet(coupon.ownerEmail, coupon.ownerAmount, transactionType: TransactionType.coupon);
      userController.user.subscriptionId = SubscriptionLevel.freeMonth.name;
    } else if(coupon.type == CouponType.coinAddition) {
      bankController.addCoinsToWallet(userController.user.email, coupon.amount, transactionType: TransactionType.coupon);
    }

    CouponFirestore().addUsedBy(coupon.id, userController.user.email);
    Get.snackbar(AppTranslationConstants.appliedCouponCode.tr,
        AppTranslationConstants.appliedCouponCodeMsg.tr,
        snackPosition: SnackPosition.bottom);
    return true;
  }

  Future<String> newAccountValidation() async {
    String validateMsg = Validator.validateUsername(controllerUsername.text);

    if(!isValidDOB(dateOfBirth.value)){
      validateMsg = MessageTranslationConstants.pleaseEnterDOB;
    } else if(!await ProfileFirestore().isAvailableName(controllerUsername.text)) {
      validateMsg = MessageTranslationConstants.profileNameUsed;
    }

    userController.user.dateOfBirth = dateOfBirth.value?.millisecondsSinceEpoch ?? 0;

    if(validateMsg.isEmpty) {
      if (controllerPhone.text.isEmpty && (controllerPhone.text.length < phoneCountry.value.minLength
              || controllerPhone.text.length > phoneCountry.value.maxLength)) {
        validateMsg = MessageTranslationConstants.pleaseEnterPhone;
        phoneNumber = '';
      } else if (phoneCountry.value.code.isEmpty) {
        validateMsg = MessageTranslationConstants.pleaseEnterCountryCode;
        phoneNumber = '';
      } else {
        phoneNumber = controllerPhone.text;
        userController.user.phoneNumber = phoneNumber;
        userController.user.countryCode = phoneCountry.value.dialCode;
      }

      if(validateMsg.isNotEmpty && optionalPhoneNumber) {
        validateMsg = '';
      }

    }

    if(phoneNumber.isNotEmpty && validateMsg.isEmpty) {
        if(await UserFirestore().isAvailablePhone(phoneNumber)) {
          AppConfig.logger.i("Phone number $phoneNumber is available");
        } else {
          validateMsg = MessageTranslationConstants.phoneUsed;
        }
    }
    return validateMsg;
  }

  @override
  Future<void> createAdditionalProfile() async {
    AppConfig.logger.i("Finishing and creating additional profile");
    focusNodeAboutMe.unfocus();

    String validateMsg = "";

    validateMsg = Validator.validateUsername(controllerUsername.text);

    if(!await ProfileFirestore().isAvailableName(controllerUsername.text)) {
      validateMsg = MessageTranslationConstants.profileNameUsed;
    }

    if(validateMsg.isEmpty) {
      if(postUploadController.mediaFile.value.path.isNotEmpty) {
        userController.newProfile.photoUrl = await postUploadController.handleUploadImage(UploadImageType.profile);
      }

      userController.newProfile.aboutMe = controllerAboutMe.text.trim();
      userController.newProfile.name = controllerUsername.text.trim();

      Get.toNamed(AppRouteConstants.introWelcome,
          arguments: [AppRouteConstants.createAdditionalProfile]
      );
    } else {
      Get.snackbar(
          MessageTranslationConstants.finishingAccount.tr,
          validateMsg.tr,
          snackPosition: SnackPosition.bottom);
    }
    isLoading.value = false;
    update([AppPageIdConstants.onBoarding]);
  }

  @override
  void setPlaceType(PlaceType placeType) {
    AppConfig.logger.d("PlaceType registered as ${placeType.name}");

    try {
      userController.newProfile.places = {};
      userController.newProfile.places![placeType.name] = Place.addBasic(placeType);
    } catch (e) {
      AppConfig.logger.e(e.toString());
    }

    Get.toNamed(AppRouteConstants.introGenres);
    update([AppPageIdConstants.onBoarding]);
  }


  @override
  void setFacilityType(FacilityType facilityTpe) {
    AppConfig.logger.d("FacilityType registered as ${facilityTpe.name}");

    userController.newProfile.facilities = {};
    userController.newProfile.facilities![facilityTpe.name] = Facility.addBasic(facilityTpe);

    Get.toNamed(AppRouteConstants.introGenres);
    update([AppPageIdConstants.onBoarding]);

  }

  List<TextEditingController> smsCodeControllers = List.generate(6, (index) => TextEditingController());
  List<FocusNode> smsCodeFocusNodes = List.generate(6, (index) => FocusNode());
  bool smsSent = false;
  String smsCode = '';
  bool isVerifiedPhone = false;
  bool isValidatingSmsCode = false;

  @override
  Future<void> verifyPhone() async {
    AppConfig.logger.i("verifyPhone");
    focusNodeAboutMe.unfocus();

    String validateMsg = "";

    if (controllerPhone.text.isEmpty && (controllerPhone.text.length < phoneCountry.value.minLength
        || controllerPhone.text.length > phoneCountry.value.maxLength)) {
      validateMsg = MessageTranslationConstants.pleaseEnterPhone;
      phoneNumber = '';
    } else if (phoneCountry.value.code.isEmpty) {
      validateMsg = MessageTranslationConstants.pleaseEnterCountryCode;
      phoneNumber = '';
    } else {
      phoneNumber = controllerPhone.text;
    }

    if(phoneNumber.isNotEmpty && validateMsg.isEmpty) {
      if(await UserFirestore().isAvailablePhone(phoneNumber)) {
        AppConfig.logger.d("Phone number $phoneNumber is available");
      } else {
        validateMsg = MessageTranslationConstants.phoneUsed;
      }
    }

    if(validateMsg.isEmpty) {
      final loginController = Get.find<LoginService>();

      if(phoneNumber.isNotEmpty) {
        userController.user.phoneNumber = phoneNumber;
        userController.user.countryCode = phoneCountry.value.dialCode;
        await loginController.verifyPhoneNumber('+${phoneCountry.value.dialCode}$phoneNumber');
        smsSent = true;
      }
    } else {
      Get.snackbar(
          MessageTranslationConstants.finishingAccount.tr,
          validateMsg.tr,
          snackPosition: SnackPosition.bottom);
    }
    
    isLoading.value = false;
    update([AppPageIdConstants.onBoarding]);
  }

  @override
  Future<void> verifySmsCode() async {
    AppConfig.logger.d("verifySmsCode");

    try {

      for (var controller in smsCodeControllers) {
        smsCode += controller.text; // Concatenar el valor de cada campo
      }

      if(smsCode.length == 6) {
        isValidatingSmsCode = true;
        update([AppPageIdConstants.onBoarding]);

        final loginController = Get.find<LoginService>();
        loginController.setIsPhoneAuth(true);
        isVerifiedPhone = await loginController.validateSmsCode(smsCode);
      }
    } catch(e) {
      AppConfig.logger.e(e.toString());
    }

    smsCode = '';
    isValidatingSmsCode = false;
    AppConfig.logger.d("isValidPhone: $isVerifiedPhone");

    Get.snackbar(AppTranslationConstants.verifyPhone.tr,
        isVerifiedPhone ? AppTranslationConstants.phoneVerified.tr : AppTranslationConstants.phoneVerificationFailed.tr,
        snackPosition: SnackPosition.bottom);
    
    update([AppPageIdConstants.onBoarding]);
  }

  Future<void> setLocation() async {
    AppConfig.logger.d("setLocation");
    try {
      isLoading.value = true;
      await profileController.updateLocation();

      if(profileController.location.value.isNotEmpty) {
        // Lógica para establecer el idioma basada en la ubicación
        String locationString = profileController.location.value;
        // Intentar extraer el país (asumiendo formato "Ciudad, País" o similar)
        List<String> parts = locationString.split(',');
        String country = parts.isNotEmpty ? AppUtilities.normalizeString(parts.last.trim().toLowerCase()) : '';

        AppLocale detectedLocale = AppFlavour.appInUse == AppInUse.e ? AppLocale.spanish : AppLocale.english;

        // Mapear país a idioma usando las listas
        if (AppLocaleConstants.spanishCountries.contains(country)) {
          detectedLocale = AppLocale.spanish;
        } else if (AppLocaleConstants.frenchCountries.contains(country)) {
          detectedLocale = AppLocale.french;
        } else if (AppLocaleConstants.germanCountries.contains(country)) {
          detectedLocale = AppLocale.deutsch;
        }

        // Llamar a updateLocale en AppHiveController para guardar la preferencia y actualizar GetX
        setLocale(detectedLocale);
        // _appHiveController.setLocale(detectedLocale); // Asegurarse de que GetX locale se actualice inmediatamente

      }

      if(userController.isNewUser) {
        Get.toNamed(AppFlavour.appInUse == AppInUse.g ? AppRouteConstants.introLocale : AppRouteConstants.introAddImage);
      } else {
        Get.toNamed(AppRouteConstants.home);
      }

      isLoading.value = false;
    } catch (e) {
      AppConfig.logger.e(e.toString());
      Get.snackbar(
          MessageTranslationConstants.creatingAccount.tr,
          MessageTranslationConstants.userCurrentLocationErrorMsg.tr,
          snackPosition: SnackPosition.bottom);
    }
  }

}
