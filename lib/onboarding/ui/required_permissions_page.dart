import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:neom_commons/core/data/implementations/user_controller.dart';
import 'package:neom_commons/core/ui/widgets/slider_model.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/constants/app_route_constants.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';
import 'package:neom_commons/core/utils/constants/message_translation_constants.dart';
import 'package:neom_profile/profile/ui/profile_controller.dart';

class RequiredPermissionsPage extends StatefulWidget {
  const RequiredPermissionsPage({Key? key}) : super(key: key);

  @override
  RequiredPermissionsPageState createState() => RequiredPermissionsPageState();
}

class RequiredPermissionsPageState extends State<RequiredPermissionsPage> {

  List<SliderModel> slides = [];
  int currentState = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    slides= SliderModel.getRequiredPermissionsSlides();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PageView.builder(
        itemBuilder: (context,index){
          return SlideTiles(
            slides[index].imagePath,
            slides[index].msg1,
            slides[index].title,
            index,
            msg2: slides[index].msg2,
          );
        },
        controller: pageController,
        itemCount: slides.length,
        scrollDirection: Axis.horizontal,
        onPageChanged: (val){
          currentState=val;
        },
      ),
    );
  }
}

class SlideTiles extends StatelessWidget {

  final String imagePath,msg1,title, msg2;
  final int current;

  const SlideTiles(this.imagePath, this.msg1, this.title,this.current, {this.msg2 = "", Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: AppTheme.appBoxDecoration,
        width: AppTheme.fullWidth(context),
        height: AppTheme.fullHeight(context),
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppTheme.heightSpace20,
          Image.asset(imagePath, fit: BoxFit.fill, height: 250),
          AppTheme.heightSpace10,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for(int i=0;i<SliderModel.getRequiredPermissionsSlides().length;i++)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  width: current==i ? 20:8,
                  height: 6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: current ==  i ? AppColor.yellow : Colors.grey[400]
                  ),
                ),
            ],
          ),
          AppTheme.heightSpace10,
          Text(title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600
            ),
            textAlign: TextAlign.center,
          ),
          AppTheme.heightSpace10,
          Text(msg1,style: const TextStyle(fontSize: 18),textAlign: TextAlign.justify),
          AppTheme.heightSpace20,
          msg2.isNotEmpty ? Text(msg2,style: const TextStyle(fontSize: 18),textAlign: TextAlign.justify) : Container(),
          AppTheme.heightSpace20,
          TextButton(
            onPressed: () async {
              try {
                Get.find<UserController>().isNewUser
                    ? Get.toNamed(AppRouteConstants.introProfile)
                    : Get.toNamed(AppRouteConstants.home);
                Get.put(ProfileController()).updateLocation();

              } catch (e) {
                Get.toNamed(AppRouteConstants.logout,
                  arguments: [AppRouteConstants.introRequiredPermissions]
                );
                Get.snackbar(
                  MessageTranslationConstants.userCurrentLocation.tr,
                  MessageTranslationConstants.userCurrentLocationErrorMsg.tr,
                  snackPosition: SnackPosition.bottom,);
              }


            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 10
              ),
              margin: const EdgeInsets.symmetric(horizontal: 50),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 2,
                    color: Colors.grey,
                    offset: Offset(0,2)
                  )
                ]
              ),
              child: Text(AppTranslationConstants.toContinue.tr.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColor.textButton,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppTheme.fontFamily
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          AppTheme.heightSpace20,
          Text('(${AppTranslationConstants.changeThisSettingLater.tr})',
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.justify),
          AppTheme.heightSpace20,
        ]),
      ),
    );
  }
}
