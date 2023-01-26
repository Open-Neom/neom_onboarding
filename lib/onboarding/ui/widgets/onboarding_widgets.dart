import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/constants/app_constants.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';
import 'package:neom_commons/core/utils/enums/app_currency.dart';
import '../onboarding_controller.dart';

Widget buildPhoneField({required OnBoardingController onBoardingController}) {
  return Container(
    padding: const EdgeInsets.only(
        left: AppTheme.padding20,
        right: AppTheme.padding20,
        bottom: AppTheme.padding5,
    ),
    decoration: BoxDecoration(
      color: AppColor.bondiBlue25,
      borderRadius: BorderRadius.circular(40),
    ),
    child: IntlPhoneField(
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: '${AppTranslationConstants.phoneNumber.tr} (${AppTranslationConstants.optional.tr})',
        alignLabelWithHint: true,
      ),
      pickerDialogStyle: PickerDialogStyle(
        backgroundColor: AppColor.getMain(),
        searchFieldInputDecoration: InputDecoration(
          labelText: AppTranslationConstants.searchByCountryName.tr,
        )
      ),
      initialCountryCode: Get.locale!.countryCode,
      onChanged: (phone) {
        onBoardingController.controllerPhone.text = phone.number;
      },
      onCountryChanged: (country) {
        onBoardingController.phoneCountry = country;
      },
        //TODO Verify if invalidNumberMessage is needed
      invalidNumberMessage: ""

    )
  );
}

Widget buildEntryDateField(DateTime dateOfBirth,
    {required BuildContext context, required dateFunction}) {
  return Container(
    width: AppTheme.fullWidth(context),
    padding: const EdgeInsets.only(left: AppTheme.padding20, right: AppTheme.padding20),
    decoration: BoxDecoration(
      color: AppColor.bondiBlue25,
      borderRadius: BorderRadius.circular(40),
    ),
    child: TextButton(
      onPressed: () {
        DatePicker.showDatePicker(context,
          showTitleActions: false,
          minTime: DateTime(AppConstants.firstYearDOB, 1, 1),
          maxTime: DateTime(AppConstants.lastYearDOB, 12, 31),
          theme: DatePickerTheme(
            itemHeight: 50,
            backgroundColor: AppColor.main50,
            itemStyle: const TextStyle(color: Colors.white),
          ),
          onChanged: (date) {
            dateFunction(date);
          },
          currentTime: DateTime.now(),
          locale: EnumToString.fromString(LocaleType.values, Get.locale!.languageCode.substring(0,2)),
        );
      },
      child: Text(
        dateOfBirth == DateTime(AppConstants.lastYearDOB) ? '${AppTranslationConstants.enterDOB.tr} (${AppTranslationConstants.optional.tr})'
            : DateFormat.yMMMMd(Get.locale.toString()).format(dateOfBirth),
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  );
}


Widget buildPricePerHourContainer(String hint, {
  required TextEditingController controller}) {
  return Container(
      padding: const EdgeInsets.only(
          left: AppTheme.padding20,
          right: AppTheme.padding20
      ),
      child: Row(children: [
        Expanded(
          child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: hint),
        ),),
        AppTheme.widthSpace20,
        DropdownButton<String>(
          items: AppCurrency.values.map((AppCurrency currency) {
            return DropdownMenuItem<String>(
              value: currency.name,
              child: Text(currency.name.toUpperCase()),
            );
          }).toList(),
          onChanged: (String? chosenCurrency) {

          },
          value: AppCurrency.appCoin.name,
          alignment: Alignment.bottomCenter,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 20,
          elevation: 16,
          style: const TextStyle(color: Colors.white),

          underline: Container(
            height: 1,
            color: Colors.grey,
          ),
        ),
      ],),
  );
}
