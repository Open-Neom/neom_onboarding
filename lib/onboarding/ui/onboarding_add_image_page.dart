import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/app_flavour.dart';
import 'package:neom_commons/core/ui/widgets/appbar_child.dart';

import 'package:neom_commons/core/ui/widgets/core_widgets.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';
import 'package:neom_commons/core/utils/core_utilities.dart';
import 'onboarding_controller.dart';
import 'widgets/onboarding_widgets.dart';


class OnBoardingAddImagePage extends StatelessWidget {
  const OnBoardingAddImagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
      id: AppPageIdConstants.onBoardingAddImage,
      init: OnBoardingController(),
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
                            (_.postUploadController.imageFile.path.isEmpty &&
                            _.userController.user!.photoUrl.isEmpty) ?
                            const Icon(Icons.account_circle, size: 150.0, color: Colors.grey) :
                            Container(
                              width: 140.0,
                              height: 140.0,
                              decoration: BoxDecoration(
                                image: _.postUploadController.imageFile.path.isEmpty ?
                                DecorationImage(
                                  image: CachedNetworkImageProvider(_.userController.user!.photoUrl),
                                  fit: BoxFit.cover,
                                ) :
                                DecorationImage(
                                  image: FileImage(File(_.postUploadController.imageFile.path)),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(75.0)),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: (_.postUploadController.imageFile.path.isEmpty) ? FloatingActionButton(
                                child: const Icon(Icons.camera_alt),
                                onPressed: ()=> _.handleImage()
                              )
                              : FloatingActionButton (
                                  child: const Icon(Icons.close),
                                  onPressed: () => _.postUploadController.clearImage()
                              ),
                            ),
                          ]),
                        ),
                      ),),
                    buildLabel(context, "${AppTranslationConstants.welcome.tr} ${_.userController.user!.name.split(" ").first}",
                        _.userController.user!.photoUrl.isEmpty
                          ? AppTranslationConstants.addProfileImgMsg.tr
                          : _.userController.profile.id.isEmpty
                            ? AppTranslationConstants.addLastProfileInfoMsg.tr
                            : AppTranslationConstants.addNewProfileInfoMsg.tr
                    ),
                    buildContainerTextField(AppTranslationConstants.username.tr,
                        controller: _.controllerUsername),
                    buildContainerTextField("${AppTranslationConstants.tellAboutYou.tr} (${AppTranslationConstants.optional.tr})",
                        controller: _.controllerAboutMe, maxLines: 20),
                    AppTheme.heightSpace20,
                    Column(
                      children: [
                        buildEntryDateField(_.dateOfBirth,
                            context: context, dateFunction: _.setDateOfBirth),
                        AppTheme.heightSpace10,
                        buildPhoneField(onBoardingController: _),
                          ///WAITING FOR GIGCOIN TO WORK
                          /// buildContainerTextField("${AppTranslationConstants.couponCode.tr} (${AppTranslationConstants.optional.tr})",
                          ///     controller: _.controllerCouponCode),
                      ],
                    ),
                    AppTheme.heightSpace5,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _.agreeTerms,
                            onChanged: (value) {
                              _.setTermsAgreement(value ?? false);
                            },
                          ),
                          Text(AppTranslationConstants.iHaveReadAndAccept.tr,
                            style: const TextStyle(fontSize: 12),
                          ),
                          TextButton(
                            child: Text(AppTranslationConstants.termsAndConditions.tr,
                              style: const TextStyle(fontSize: 12),
                            ),
                            onPressed: () async {
                              CoreUtilities.launchURL(AppFlavour.getTermsOfServiceUrl());
                            }
                          ),
                        ],
                      ),
                      if(_.agreeTerms) Container(
                        width: MediaQuery.of(context).size.width*0.66,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: TextButton(
                          onPressed: () async => {
                            if(_.userController.user?.currentProfileId.isEmpty ?? true) {
                              await _.finishAccount()
                            } else {
                              await _.createAdditionalProfile()
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                            backgroundColor: AppColor.bondiBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),),
                          child: Text((_.userController.user?.currentProfileId.isEmpty ?? true)
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
                if(_.isLoading) Container(
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
