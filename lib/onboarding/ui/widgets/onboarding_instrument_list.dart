// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'package:neom_commons/core/domain/model/instrument.dart';
// import 'package:neom_commons/core/utils/app_color.dart';
// import 'package:neom_commons/core/utils/constants/app_page_id_constants.dart';
// import '../onboarding_controller.dart';
//
// class OnBoardingInstrumentList extends StatelessWidget{
//   const OnBoardingInstrumentList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<OnBoardingController>(
//         id: AppPageIdConstants.onBoardingInstruments,
//         init: OnBoardingController(),
//         builder: (_) => ListView.separated(
//           separatorBuilder: (context, index) => const Divider(),
//           itemBuilder: (__, index) {
//             Instrument instrument = _.instrumentController.instruments.values.elementAt(index);
//             return GestureDetector(
//               child: ListTile(
//                 tileColor: instrument.isFavorite ? AppColor.getMain() : Colors.transparent,
//                 title: Text(instrument.name.tr.capitalize,
//                   style: TextStyle(fontWeight: instrument.isFavorite ? FontWeight.bold : FontWeight.normal),),
//                 trailing: IconButton(
//                   icon:  Icon(
//                       Icons.multitrack_audio_sharp, color: instrument.isFavorite ? Colors.white : Colors.grey),
//                   onPressed: () {
//                     if(instrument.isFavorite){
//                       _.removeInstrumentIntro(index);
//                     } else {
//                       _.addInstrumentIntro(index);
//                     }
//                   }
//                 ),
//               ),
//               onTap: () {
//                 if(instrument.isFavorite){
//                   _.removeInstrumentIntro(index);
//                 } else {
//                   _.addInstrumentIntro(index);
//                 }
//               } ,
//             );
//           },
//         itemCount: _.instrumentController.instruments.length,
//       ),
//     );
//   }
// }
