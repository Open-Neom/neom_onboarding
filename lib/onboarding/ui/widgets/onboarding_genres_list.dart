import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:neom_commons/core/domain/model/genre.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/constants/app_page_id_constants.dart';
import '../onboarding_controller.dart';

class OnBoardingGenresList extends StatelessWidget{
  const OnBoardingGenresList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
        id: AppPageIdConstants.onBoardingGenres,
        init: OnBoardingController(),
        builder: (_) => ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (__, index) {
            Genre genre = _.genresController.genres.values.elementAt(index);
            return GestureDetector(
              child: ListTile(
                tileColor: genre.isFavorite ? AppColor.getMain() : Colors.transparent,
                title: Text(genre.name.tr.capitalizeFirst,
                  style: TextStyle(fontWeight: genre.isFavorite ? FontWeight.bold : FontWeight.normal),),
                trailing: IconButton(
                  icon:  Icon(
                      Icons.multitrack_audio_sharp, color: genre.isFavorite ? Colors.white : Colors.grey),
                  onPressed: () {
                    if(genre.isFavorite){
                      _.removeGenreIntro(index);
                    } else {
                      _.addGenreIntro(index);
                    }
                  }
                ),
              ),
              onTap: () {
                if(genre.isFavorite){
                  _.removeGenreIntro(index);
                } else {
                  _.addGenreIntro(index);
                }
              } ,
            );
          },
        itemCount: _.genresController.genres.length,
      ),
    );
  }
}
