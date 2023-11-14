import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:neom_commons/core/app_flavour.dart';
import 'package:neom_commons/core/data/firestore/coupon_firestore.dart';
import 'package:neom_commons/core/data/firestore/profile_firestore.dart';
import 'package:neom_commons/core/data/firestore/user_firestore.dart';
import 'package:neom_commons/core/data/implementations/shared_preference_controller.dart';
import 'package:neom_commons/core/data/implementations/user_controller.dart';
import 'package:neom_commons/core/domain/model/app_coupon.dart';
import 'package:neom_commons/core/domain/model/app_user.dart';
import 'package:neom_commons/core/domain/model/facility.dart';
import 'package:neom_commons/core/domain/model/genre.dart';
import 'package:neom_commons/core/domain/model/instrument.dart';
import 'package:neom_commons/core/domain/model/place.dart';
import 'package:neom_commons/core/domain/model/wallet.dart';
import 'package:neom_commons/core/domain/use_cases/onboarding_service.dart';
import 'package:neom_commons/core/utils/app_utilities.dart';
import 'package:neom_commons/core/utils/constants/app_constants.dart';
import 'package:neom_commons/core/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/core/utils/constants/app_route_constants.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';
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
import 'package:neom_instruments/genres/data/implementations/genres_controller.dart';
import 'package:neom_instruments/instruments/ui/instrument_controller.dart';
import 'package:neom_posts/posts/ui/add/post_upload_controller.dart';

class OnBoardingController extends GetxController implements OnBoardingService {

  var logger = AppUtilities.logger;

  final userController = Get.find<UserController>();
  final instrumentController = Get.put(InstrumentController());
  final genresController = Get.put(GenresController());
  final postUploadController = Get.put(PostUploadController());

  TextEditingController controllerFullName = TextEditingController();
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerAboutMe = TextEditingController();
  TextEditingController controllerCouponCode = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();

  final Rxn<AppUser> user = Rxn<AppUser>();
  final RxBool isLoading = false.obs;
  final RxBool agreeTerms = false.obs;
  final Rx<DateTime> dateOfBirth = DateTime(AppConstants.lastYearDOB).obs;
  final Rx<Country> phoneCountry = countries[0].obs;

  String countryCode = '';
  String phoneNumber = '';
  String aboutMe = '';

  final FocusNode focusNodeAboutMe = FocusNode();

  @override
  void onInit() async {
    super.onInit();
    user.value = userController.user;
    controllerFullName.text = user.value?.name ?? "";
    controllerUsername.text = user.value?.name ?? "";

    genresController.favGenres.clear();
    instrumentController.favInstruments.clear();

    for (var country in countries) {
      if(Get.locale!.countryCode == country.code){
        phoneCountry.value = country; //Mexico
      }
    }

  }

  void setLocale(AppLocale locale) async {
    await Get.find<SharedPreferenceController>().updateLocale(locale);
    update([AppPageIdConstants.onBoardingProfile]);
    Get.toNamed(AppRouteConstants.introProfile);
  }


  @override
  void setProfileType(ProfileType profileType) {
    logger.d("ProfileType registered as ${profileType.name}");
    userController.newProfile.type = profileType;

    update([AppPageIdConstants.onBoardingProfile]);

    if(AppFlavour.appInUse == AppInUse.c) {
      Get.toNamed(AppRouteConstants.introAddImage);
    } else {
      switch(profileType) {
        case(ProfileType.instrumentist):
          Get.toNamed(AppRouteConstants.introReason);
          break;
        case(ProfileType.facilitator):
          Get.toNamed(AppRouteConstants.introFacility);
          break;
        case(ProfileType.host):
          Get.toNamed(AppRouteConstants.introPlace);
          break;
        case(ProfileType.researcher):
          Get.toNamed(AppRouteConstants.introGenres);
          break;
        case(ProfileType.fan):
          Get.toNamed(AppRouteConstants.introGenres);
          break;
        case(ProfileType.band):
          Get.toNamed(AppRouteConstants.introReason);
          break;
      }
    }


  }

  @override
  Future<void>  addInstrumentIntro(int index) async {
    logger.d("Adding instrument to new account");
    String instrumentKey = instrumentController.instruments.keys.elementAt(index);
    Instrument instrument = instrumentController.instruments[instrumentKey]!;
    instrumentController.instruments[instrumentKey]!.isFavorite = true;
    instrumentController.favInstruments[instrumentKey] = instrument;

    update([AppPageIdConstants.onBoardingInstruments]);
  }

  @override
  Future<void> removeInstrumentIntro(int index) async {
    logger.d("Removing instrument from new account");

    String instrumentKey = instrumentController.instruments.keys.elementAt(index);
    Instrument instrument = instrumentController.instruments[instrumentKey]!;
    instrumentController.instruments[instrumentKey]!.isFavorite = false;
    logger.d("Removing instrument ${instrument.name}");
    instrumentController.favInstruments.remove(instrumentKey);

    update([AppPageIdConstants.onBoardingInstruments]);
  }

  ///DEPRECATED
  // @override
  // Future<void>  addGenreIntro(int index) async {
  //   logger.d("Adding instrument to new account");
  //   String genreKey = genresController.genres.keys.elementAt(index);
  //   Genre genre = genresController.genres[genreKey]!;
  //   genresController.genres[genreKey]!.isFavorite = true;
  //   genresController.favGenres[genreKey] = genre;
  //
  //   update([AppPageIdConstants.onBoardingGenres]);
  // }
  //
  // @override
  // Future<void> removeGenreIntro(int index) async {
  //   logger.d("Removing genre from new account");
  //
  //   String genreKey = genresController.genres.keys.elementAt(index);
  //   Genre genre = genresController.genres[genreKey]!;
  //   genresController.genres[genreKey]!.isFavorite = false;
  //   logger.d("Removing genre ${genre.name}");
  //   genresController.favGenres.remove(genreKey);
  //
  //   update([AppPageIdConstants.onBoardingGenres]);
  // }

  @override
  void addInstrumentToProfile(){
    logger.d("Adding ${instrumentController.favInstruments.length} Instruments to Profile");

    userController.newProfile.instruments = instrumentController.favInstruments
        .map((name, instrument) => MapEntry<String,Instrument>(name,instrument));

    update([AppPageIdConstants.onBoardingInstruments]);
    Get.toNamed(AppRouteConstants.introGenres);
  }

  @override
  void addGenresToProfile() {
    logger.d("Adding ${genresController.selectedGenres.length} Genres to Profile");

    userController.newProfile.genres = Map<String, Genre>.fromEntries(
      genresController.selectedGenres.value
          .map((genre) => MapEntry<String, Genre>(genre.name, genre)),
    );


    Get.toNamed(AppRouteConstants.introAddImage);
    update([AppPageIdConstants.onBoardingGenres]);
  }



  @override
  void setReason(UsageReason reason) {
    logger.d("ProfileType registered Reason as ${reason.name}");
    userController.newProfile.reason = reason;
    Get.toNamed(AppRouteConstants.introInstruments);
    update([AppPageIdConstants.onBoardingReason]);
  }


  @override
  void handleImage() async {
    await postUploadController.handleImage(uploadImageType: UploadImageType.profile);
    update([AppPageIdConstants.onBoardingAddImage]);
  }


  @override
  void setDateOfBirth(DateTime? pickedDate) {
    logger.d("");
    try {
      if (pickedDate != null
          && pickedDate.compareTo(dateOfBirth.value) != 0
          && pickedDate.compareTo(DateTime.now()) < 0) {
        dateOfBirth.value = pickedDate;
      }
    } catch (e) {
      logger.e(e.toString());
    }

    update([AppPageIdConstants.onBoardingAddImage]);
  }


  @override
  void setTermsAgreement(bool agree) {
    logger.d("");
    try {
      agreeTerms.value = agree;
    } catch (e) {
      logger.e(e.toString());
    }

    update([AppPageIdConstants.onBoardingAddImage]);
  }


  @override
  Future<void> finishAccount() async {
    logger.i("Finishing and creating account");
    focusNodeAboutMe.unfocus();

    String validateMsg = "";

    validateMsg = Validator.validateUsername(controllerUsername.text);

    if(!await ProfileFirestore().isAvailableName(controllerUsername.text)) {
      validateMsg = MessageTranslationConstants.profileNameUsed;
    }

    bool optionalPhoneNumber = true;

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
          logger.i("Phone number $phoneNumber is available");
        } else {
          validateMsg = MessageTranslationConstants.phoneUsed;
        }
    }

    if(validateMsg.isEmpty) {

      if(dateOfBirth.value.compareTo(DateTime(AppConstants.lastYearDOB)) >= 0) {
        ///Validation removed by Apple's Guidelines
        //validateMsg = MessageTranslationConstants.pleaseEnterDOB;
        dateOfBirth.value = DateTime.now();
      }

      if(postUploadController.mediaFile.value.path.isNotEmpty) {
        userController.user!.photoUrl = await postUploadController.handleUploadImage(UploadImageType.profile);
      }
      if(phoneNumber.isNotEmpty) {
        userController.user!.phoneNumber = phoneNumber;
        userController.user!.countryCode = phoneCountry.value.dialCode;
      }
      userController.user!.referralCode = controllerCouponCode.text.toLowerCase().trim();
      userController.newProfile.aboutMe = controllerAboutMe.text.trim();
      userController.newProfile.name = controllerUsername.text.trim();

      userController.user!.wallet = Wallet();
      userController.user!.wallet.currency = AppCurrency.appCoin;
      AppCoupon coupon = AppCoupon();

      if(userController.user!.referralCode.isNotEmpty) {
        coupon = await CouponFirestore()
            .getCouponByCode(user.value!.referralCode);

        if(coupon.id.isNotEmpty) {
          if(coupon.type == CouponType.coinAddition
              && coupon.usageCount < coupon.usageLimit) {
            userController.user!.wallet.amount = coupon.amount;
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
    logger.i("Finishing and creating additional profile");
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
    logger.d("PlaceType registered as ${placeType.name}");

    try {
      userController.newProfile.places = {};
      userController.newProfile.places![placeType.name] = Place.addBasic(placeType);
    } catch (e) {
      logger.e(e.toString());
    }

    Get.toNamed(AppRouteConstants.introGenres);
    update([AppPageIdConstants.onBoardingProfile]);

  }


  @override
  void setFacilityType(FacilityType facilityTpe) {
    logger.d("FacilityType registered as ${facilityTpe.name}");

    userController.newProfile.facilities = {};
    userController.newProfile.facilities![facilityTpe.name] = Facility.addBasic(facilityTpe);

    Get.toNamed(AppRouteConstants.introGenres);
    update([AppPageIdConstants.onBoardingProfile]);

  }



}
