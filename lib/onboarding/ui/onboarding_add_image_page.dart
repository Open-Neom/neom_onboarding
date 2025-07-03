import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neom_commons/commons/ui/theme/app_color.dart';
import 'package:neom_commons/commons/ui/theme/app_theme.dart';
import 'package:neom_commons/commons/ui/widgets/appbar_child.dart';
import 'package:neom_commons/commons/ui/widgets/core_widgets.dart';
import 'package:neom_commons/commons/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/commons/utils/constants/app_translation_constants.dart';
import 'package:neom_commons/commons/utils/external_utilities.dart';
import 'package:neom_core/core/app_properties.dart';

import 'onboarding_controller.dart';
import 'widgets/onboarding_widgets.dart';


class OnBoardingAddImagePage extends StatelessWidget {
  const OnBoardingAddImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
      id: AppPageIdConstants.onBoarding,
      builder: (_) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarChild(color: Colors.transparent),
        backgroundColor: AppColor.main50,
        body: Container(
          width: AppTheme.fullWidth(context),
          height: AppTheme.fullHeight(context),
          decoration: AppTheme.appBoxDecoration,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.padding20),
                child: Column(
                  children: <Widget>[
                    AppTheme.heightSpace50,
                    AppTheme.heightSpace20,
                    Obx(()=> Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Center(
                        child: Stack(
                          children: <Widget>[
                            (_.postUploadController.mediaFile.value.path.isEmpty &&
                            _.userController.user.photoUrl.isEmpty) ?
                            const Icon(Icons.account_circle, size: 150.0, color: Colors.grey) :
                            Container(
                              width: 140.0,
                              height: 140.0,
                              decoration: BoxDecoration(
                                image: _.postUploadController.mediaFile.value.path.isEmpty ?
                                DecorationImage(
                                  image: CachedNetworkImageProvider(_.userController.user.photoUrl),
                                  fit: BoxFit.cover,
                                ) :
                                DecorationImage(
                                  image: FileImage(File(_.postUploadController.mediaFile.value.path)),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(75.0)),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: (_.postUploadController.mediaFile.value.path.isEmpty) ? FloatingActionButton(
                                child: const Icon(Icons.camera_alt),
                                onPressed: ()=> _.handleImage()
                              )
                              : FloatingActionButton (
                                  child: const Icon(Icons.close),
                                  onPressed: () => _.postUploadController.clearMedia()
                              ),
                            ),
                          ]),
                        ),
                      ),),
                    buildLabel(context, "${AppTranslationConstants.welcome.tr} ${_.userController.user.name.split(" ").first}",
                        _.userController.user.photoUrl.isEmpty
                          ? AppTranslationConstants.addProfileImgMsg.tr
                          : _.userController.profile.id.isEmpty
                            ? AppTranslationConstants.addLastProfileInfoMsg.tr
                            : AppTranslationConstants.addNewProfileInfoMsg.tr
                    ),
                    buildContainerTextField(AppTranslationConstants.username.tr,
                        controller: _.controllerUsername, textInputType: TextInputType.text),
                    buildContainerTextField("${AppTranslationConstants.tellAboutYou.tr} (${AppTranslationConstants.optional.tr})",
                        controller: _.controllerAboutMe, maxLines: 20),
                    AppTheme.heightSpace20,
                    Column(
                      children: [
                        buildEntryDateField(_.dateOfBirth.value,
                            context: context, dateFunction: _.setDateOfBirth),
                        AppTheme.heightSpace10,
                        if(!_.isVerifiedPhone &&_.userController.user.phoneNumber.isEmpty) buildPhoneField(onBoardingController: _),
                        if(!_.isVerifiedPhone &&_.userController.user.phoneNumber.isEmpty) TextButton(
                            onPressed: () => _.verifyPhone(),
                            child: Text(!_.smsSent ? AppTranslationConstants.verifyPhone.tr : AppTranslationConstants.sendCodeAgain.tr,
                              style: const TextStyle(decoration: TextDecoration.underline, fontSize: 15),
                            )
                        ),
                        if(_.smsSent && !_.isVerifiedPhone) _.isValidatingSmsCode ? const CircularProgressIndicator() : buildSmsCodeField(context, onBoardingController: _),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: AppTheme.padding20,
                                right: AppTheme.padding20
                            ),
                            child: TextFormField(
                              controller: _.controllerCouponCode,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(labelText: "${AppTranslationConstants.couponCode.tr} (${AppTranslationConstants.optional.tr})"),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                                LengthLimitingTextInputFormatter(10),
                              ],
                            )
                        )
                      ],
                    ),
                    AppTheme.heightSpace5,
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _.agreeTerms.value,
                            onChanged: (value) {
                              _.setTermsAgreement(value ?? false);
                            },
                          ),
                          Text('${AppTranslationConstants.iHaveReadAndAccept.tr} ',
                            style: const TextStyle(fontSize: 14),
                          ),
                          TextButton(
                            // style: TextButton.styleFrom(padding: EdgeInsets.zero),
                            child: Text(AppTranslationConstants.termsAndConditions.tr,
                              style: const TextStyle(fontSize: 14),
                            ),
                            onPressed: () async {
                              ExternalUtilities.launchURL(AppProperties.getTermsOfServiceUrl());
                            }
                          ),
                        ],),
                      ),
                      if(_.agreeTerms.value) Container(
                        width: MediaQuery.of(context).size.width*0.66,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: TextButton(
                          onPressed: () async => {
                            if(_.userController.user.currentProfileId.isEmpty) {
                              await _.finishAccount()
                            } else {
                              await _.createAdditionalProfile()
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                            backgroundColor: AppColor.bondiBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),),
                          child: Text((_.userController.user.currentProfileId.isEmpty)
                              ? AppTranslationConstants.finishAccount.tr
                              : AppTranslationConstants.finishProfile.tr,
                            style: const TextStyle(
                              color: Colors.white, fontSize: 20.0,
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if(_.isLoading.value) Container(
                  color: Colors.black87,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.dodgetBlue)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
