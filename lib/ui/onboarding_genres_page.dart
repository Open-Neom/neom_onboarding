// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:neom_commons/core/ui/widgets/appbar_child.dart';
//
// import 'package:neom_commons/core/ui/widgets/header_intro.dart';
// import 'package:neom_commons/core/utils/app_color.dart';
// import 'package:neom_commons/core/utils/app_theme.dart';
// import 'package:neom_commons/core/utils/constants/app_page_id_constants.dart';
// import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';
// import 'onboarding_controller.dart';
//
// class OnBoardingGenresPage extends StatelessWidget {
//   const OnBoardingGenresPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<OnBoardingController>(
//       id: AppPageIdConstants.onBoardingGenres,
//       init: OnBoardingController(),
//       builder: (_) => Scaffold(
//         extendBodyBehindAppBar: true,
//         appBar: AppBarChild(color: Colors.transparent),
//         backgroundColor: AppColor.main50,
//         body: Container(
//           decoration: AppTheme.appBoxDecoration,
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                 AppTheme.heightSpace100,
//                 HeaderIntro(subtitle: AppTranslationConstants.introGenres.tr),
//                 ///DEPRECATED const Expanded(child: OnBoardingGenresList()),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: Obx(() => Wrap(
//                           alignment: WrapAlignment.center,
//                           children: _.genresController.genreChips.toList()
//                       ),),
//                     ),
//                   ),
//                 ]
//               ),
//             ),
//       floatingActionButton: FloatingActionButton(
//         tooltip: AppTranslationConstants.next.tr,
//         elevation: AppTheme.elevationFAB,
//         child: const Icon(Icons.navigate_next),
//         onPressed: () => _.addGenresToProfile(),
//       ),
//       ),
//     );
//   }
// }
