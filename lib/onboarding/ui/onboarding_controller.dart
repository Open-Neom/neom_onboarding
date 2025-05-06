import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:neom_commons/auth/ui/login/login_controller.dart';
import 'package:neom_commons/core/app_flavour.dart';
import 'package:neom_commons/core/data/firestore/coupon_firestore.dart';
import 'package:neom_commons/core/data/firestore/profile_firestore.dart';
import 'package:neom_commons/core/data/firestore/user_firestore.dart';
import 'package:neom_commons/core/data/implementations/app_hive_controller.dart';
import 'package:neom_commons/core/data/implementations/user_controller.dart';
import 'package:neom_commons/core/domain/model/app_coupon.dart';
import 'package:neom_commons/core/domain/model/app_user.dart';
import 'package:neom_commons/core/domain/model/facility.dart';
import 'package:neom_commons/core/domain/model/place.dart';
import 'package:neom_commons/core/domain/model/wallet.dart';
import 'package:neom_commons/core/domain/use_cases/onboarding_service.dart';
import 'package:neom_commons/core/utils/app_utilities.dart';
import 'package:neom_commons/core/utils/constants/app_constants.dart';
import 'package:neom_commons/core/utils/constants/app_locale_constants.dart';
import 'package:neom_commons/core/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/core/utils/constants/app_route_constants.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';
import 'package:neom_commons/core/utils/constants/intl_countries_list.dart';
import 'package:neom_commons/core/utils/constants/message_translation_constants.dart';
import 'package:neom_commons/core/utils/enums/app_currency.dart';
import 'package:neom_commons/core/utils/enums/app_in_use.dart';
import 'package:neom_commons/core/utils/enums/app_locale.dart';
import 'package:neom_commons/core/utils/enums/coupon_type.dart';
import 'package:neom_commons/core/utils/enums/facilitator_type.dart';
import 'package:neom_commons/core/utils/enums/place_type.dart';
import 'package:neom_commons/core/utils/enums/profile_type.dart';
import 'package:neom_commons/core/utils/enums/upload_image_type.dart';
import 'package:neom_commons/core/utils/enums/usage_reason.dart';
import 'package:neom_commons/core/utils/validator.dart';
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

  final Rxn<AppUser> user = Rxn<AppUser>();
  final RxBool isLoading = false.obs;
  final RxBool agreeTerms = false.obs;
  final Rxn<DateTime> dateOfBirth = Rxn<DateTime>();
  final DateTime minAllowedDate = DateTime(AppConstants.lastYearDOB, 1, 1);

  final Rx<Country> phoneCountry = IntlPhoneConstants.availableCountries[0].obs;

  String countryCode = '';
  String phoneNumber = '';
  String aboutMe = '';

  final FocusNode focusNodeAboutMe = FocusNode();
  bool optionalPhoneNumber = true;

  @override
  void onInit() async {
    super.onInit();
    user.value = userController.user;
    controllerFullName.text = user.value?.name ?? "";
    controllerUsername.text = user.value?.name ?? "";

    for (var country in countries) {
      if(Get.locale!.countryCode == country.code){
        phoneCountry.value = country; //Mexico
      }
    }

  }

  void setLocale(AppLocale locale) async {
    await Get.find<AppHiveController>().updateLocale(locale);
    update([AppPageIdConstants.onBoardingProfile]);
    Get.toNamed(AppRouteConstants.introAddImage);
  }

  @override
  void setProfileType(ProfileType profileType) {
    AppUtilities.logger.d("ProfileType registered as ${profileType.name}");
    userController.newProfile.type = profileType;

    update([AppPageIdConstants.onBoardingProfile]);

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
    AppUtilities.logger.d("ProfileType registered Reason as ${reason.name}");
    userController.newProfile.usageReason = reason;
    Get.toNamed(AppRouteConstants.introInstruments);
    update([AppPageIdConstants.onBoardingReason]);
  }

  @override
  void handleImage() async {
    await postUploadController.handleImage(imageType: UploadImageType.profile);
    update([AppPageIdConstants.onBoardingAddImage]);
  }

  @override
  void setDateOfBirth(DateTime? pickedDate) {
    AppUtilities.logger.d("");
    try {
      if (pickedDate != null && isValidDOB(pickedDate)) {
        dateOfBirth.value = pickedDate;
      }
    } catch (e) {
      AppUtilities.logger.e(e.toString());
    }

    update([AppPageIdConstants.onBoardingAddImage]);
  }

  bool isValidDOB(DateTime? dob) {
    if (dob == null) {
      AppUtilities.logger.w("Date of birth is null.");
      return false;
    }

    if (dob.isBefore(minAllowedDate)) {
      return true;
    } else {
      AppUtilities.logger.w("Invalid DOB: Must be before 2010.");
      return false;
    }
  }

  @override
  void setTermsAgreement(bool agree) {
    AppUtilities.logger.d("");
    try {
      agreeTerms.value = agree;
    } catch (e) {
      AppUtilities.logger.e(e.toString());
    }

    update([AppPageIdConstants.onBoardingAddImage]);
  }

  @override
  Future<void> finishAccount() async {
    AppUtilities.logger.i("Finishing and creating account");
    focusNodeAboutMe.unfocus();

    String validateMsg = "";

    validateMsg = Validator.validateUsername(controllerUsername.text);

    if(!await ProfileFirestore().isAvailableName(controllerUsername.text)) {
      validateMsg = MessageTranslationConstants.profileNameUsed;
    }


    if(!isValidDOB(dateOfBirth.value)){
      validateMsg = MessageTranslationConstants.pleaseEnterDOB;
    }

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
      }

      if(validateMsg.isNotEmpty && optionalPhoneNumber) {
        validateMsg = '';
      }

    }

    if(phoneNumber.isNotEmpty && validateMsg.isEmpty) {
        if(await UserFirestore().isAvailablePhone(phoneNumber)) {
          AppUtilities.logger.i("Phone number $phoneNumber is available");
        } else {
          validateMsg = MessageTranslationConstants.phoneUsed;
        }
    }

    if(validateMsg.isEmpty) {
      if(postUploadController.mediaFile.value.path.isNotEmpty) {
        userController.user.photoUrl = await postUploadController.handleUploadImage(UploadImageType.profile);
      }
      if(phoneNumber.isNotEmpty) {
        userController.user.phoneNumber = phoneNumber;
        userController.user.countryCode = phoneCountry.value.dialCode;
      }
      userController.user.referralCode = controllerCouponCode.text.toLowerCase().trim();
      userController.newProfile.aboutMe = controllerAboutMe.text.trim();
      userController.newProfile.name = controllerUsername.text.trim();

      userController.user.wallet = Wallet();
      userController.user.wallet.currency = AppCurrency.appCoin;
      AppCoupon coupon = AppCoupon();

      if(userController.user.referralCode.isNotEmpty) {
        coupon = await CouponFirestore()
            .getCouponByCode(user.value!.referralCode);

        if(coupon.id.isNotEmpty) {
          if(coupon.type == CouponType.coinAddition
              && (coupon.usedBy?.length ?? 0) < coupon.usageLimit) {
            userController.user.wallet.amount = coupon.amount;
            userController.appliedCoupon = true;
            userController.coupon = coupon;
          }

          Get.snackbar(AppTranslationConstants.appliedCouponCode.tr,
              AppTranslationConstants.appliedCouponCodeMsg.tr,
              snackPosition: SnackPosition.bottom);

          await Future.delayed(const Duration(seconds: 2));

          Get.toNamed(AppRouteConstants.introWelcome,
              arguments: [AppRouteConstants.introAddImage]);

        } else {
          Get.snackbar(AppTranslationConstants.invalidCouponCode.tr,
              AppTranslationConstants.invalidCouponCodeMsg.tr,
              snackPosition: SnackPosition.bottom);
        }
      } else {
        Get.toNamed(AppRouteConstants.introWelcome,
            arguments: [AppRouteConstants.introAddImage]);
      }
    } else {
      AppUtilities.logger.w(validateMsg.tr);
      Get.snackbar(MessageTranslationConstants.finishingAccount.tr,
          validateMsg.tr, snackPosition: SnackPosition.bottom);
    }
    isLoading.value = false;
    update([AppPageIdConstants.onBoardingAddImage]);
  }

  @override
  Future<void> createAdditionalProfile() async {
    AppUtilities.logger.i("Finishing and creating additional profile");
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
    update([AppPageIdConstants.onBoardingAddImage]);
  }

  @override
  void setPlaceType(PlaceType placeType) {
    AppUtilities.logger.d("PlaceType registered as ${placeType.name}");

    try {
      userController.newProfile.places = {};
      userController.newProfile.places![placeType.name] = Place.addBasic(placeType);
    } catch (e) {
      AppUtilities.logger.e(e.toString());
    }

    Get.toNamed(AppRouteConstants.introGenres);
    update([AppPageIdConstants.onBoardingProfile]);

  }


  @override
  void setFacilityType(FacilityType facilityTpe) {
    AppUtilities.logger.d("FacilityType registered as ${facilityTpe.name}");

    userController.newProfile.facilities = {};
    userController.newProfile.facilities![facilityTpe.name] = Facility.addBasic(facilityTpe);

    Get.toNamed(AppRouteConstants.introGenres);
    update([AppPageIdConstants.onBoardingProfile]);

  }

  List<TextEditingController> smsCodeControllers = List.generate(6, (index) => TextEditingController());
  List<FocusNode> smsCodeFocusNodes = List.generate(6, (index) => FocusNode());
  bool smsSent = false;
  String smsCode = '';
  bool isVerifiedPhone = false;
  bool isValidatingSmsCode = false;

  @override
  Future<void> verifyPhone() async {
    AppUtilities.logger.i("verifyPhone");
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
        AppUtilities.logger.d("Phone number $phoneNumber is available");
      } else {
        validateMsg = MessageTranslationConstants.phoneUsed;
      }
    }

    if(validateMsg.isEmpty) {
      LoginController loginController = Get.find<LoginController>();

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
    update([AppPageIdConstants.onBoardingAddImage]);
  }

  @override
  Future<void> verifySmsCode() async {
    AppUtilities.logger.d("verifySmsCode");

    try {

      for (var controller in smsCodeControllers) {
        smsCode += controller.text; // Concatenar el valor de cada campo
      }

      if(smsCode.length == 6) {
        isValidatingSmsCode = true;
        update([AppPageIdConstants.onBoardingAddImage]);

        LoginController loginController = Get.find<LoginController>();
        loginController.isPhoneAuth = true;
        isVerifiedPhone = await loginController.validateSmsCode(smsCode);
      }
    } catch(e) {
      AppUtilities.logger.e(e.toString());
    }

    smsCode = '';
    isValidatingSmsCode = false;
    AppUtilities.logger.d("isValidPhone: $isVerifiedPhone");

    Get.snackbar(AppTranslationConstants.verifyPhone.tr,
        isVerifiedPhone ? AppTranslationConstants.phoneVerified.tr : AppTranslationConstants.phoneVerificationFailed.tr,
        snackPosition: SnackPosition.bottom);
    
    update([AppPageIdConstants.onBoardingAddImage]);
  }

  Future<void> setLocation() async {
    AppUtilities.logger.d("setLocation");
    try {
      await profileController.updateLocation();

      if(profileController.location.value.isNotEmpty) {
        // Lógica para establecer el idioma basada en la ubicación
        String locationString = profileController.location.value;
        // Intentar extraer el país (asumiendo formato "Ciudad, País" o similar)
        List<String> parts = locationString.split(',');
        String country = parts.isNotEmpty ? parts.last.trim().toLowerCase() : '';

        AppLocale detectedLocale = AppLocale.english; // Default a inglés

        // Mapear país a idioma usando las listas
        if (AppLocaleConstants.spanishCountries.map((c) => c.toLowerCase()).contains(country)) {
          detectedLocale = AppLocale.spanish;
        } else if (AppLocaleConstants.frenchCountries.map((c) => c.toLowerCase()).contains(country)) {
          detectedLocale = AppLocale.french;
        } else if (AppLocaleConstants.germanCountries.map((c) => c.toLowerCase()).contains(country)) {
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
    } catch (e) {
      AppUtilities.logger.e(e.toString());
      Get.snackbar(
          MessageTranslationConstants.creatingAccount.tr,
          MessageTranslationConstants.userCurrentLocationErrorMsg.tr,
          snackPosition: SnackPosition.bottom);
    }
  }

}
