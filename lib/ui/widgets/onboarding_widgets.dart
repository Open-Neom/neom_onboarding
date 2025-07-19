import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/ui/theme/app_theme.dart';
import 'package:neom_commons/utils/constants/intl_countries_list.dart';
import 'package:neom_commons/utils/constants/translations/app_translation_constants.dart';
import 'package:neom_commons/utils/constants/translations/common_translation_constants.dart';
import 'package:neom_core/utils/constants/core_constants.dart';
import 'package:neom_core/utils/enums/app_currency.dart';

import '../../utils/constants/onboarding_translation_constants.dart';
import '../onboarding_controller.dart';

Widget buildPhoneField({required OnBoardingController onBoardingController}) {
  return Container(
    padding: const EdgeInsets.only(
        left: AppTheme.padding20,
        right: AppTheme.padding20,
        bottom: AppTheme.padding5,
    ),
    decoration: BoxDecoration(
      color: AppColor.bondiBlue,
      borderRadius: BorderRadius.circular(20),
    ),
    child: IntlPhoneField(
      countries: IntlPhoneConstants.availableCountries,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: '${AppTranslationConstants.phoneNumber.tr} (${AppTranslationConstants.optional.tr})',
        alignLabelWithHint: true,
      ),
      pickerDialogStyle: PickerDialogStyle(
        backgroundColor: AppColor.getMain(),
        searchFieldInputDecoration: InputDecoration(
          labelText: CommonTranslationConstants.searchByCountryName.tr,
        )
      ),
      initialCountryCode: IntlPhoneConstants.initialCountryCode,
      onChanged: (phone) {
        onBoardingController.controllerPhone.text = phone.number;
      },
      onCountryChanged: (country) {
        onBoardingController.phoneCountry.value = country;
      },
        //TODO Verify if invalidNumberMessage is needed
      invalidNumberMessage: ""

    )
  );
}

Widget buildEntryDateField(DateTime? dateOfBirth,
    {required BuildContext context, required dateFunction}) {
  return Container(
    width: AppTheme.fullWidth(context),
    padding: const EdgeInsets.only(left: AppTheme.padding20, right: AppTheme.padding20),
    decoration: BoxDecoration(
      color: AppColor.bondiBlue,
      borderRadius: BorderRadius.circular(20),
    ),
    child: TextButton(
      onPressed: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime(CoreConstants.lastYearDOB, 12, 31),
          firstDate: DateTime(CoreConstants.firstYearDOB, 1, 1),
          lastDate: DateTime(CoreConstants.lastYearDOB, 12, 31),
          currentDate: dateOfBirth,
        );

        if(selectedDate != null) {
          dateFunction(selectedDate);
        }

      },
      child: Text(
        dateOfBirth != null && dateOfBirth.isBefore(DateTime(CoreConstants.lastYearDOB))
            ? DateFormat.yMMMMd(Get.locale.toString()).format(dateOfBirth)
            : OnBoardingTranslationConstants.enterDOB.tr,
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

Widget buildSmsCodeField(BuildContext context, {
  required OnBoardingController onBoardingController,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppTheme.padding20,
      vertical: AppTheme.padding10,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 40, // Ancho de cada campo
          child: TextFormField(
            controller: onBoardingController.smsCodeControllers[index],
            focusNode: onBoardingController.smsCodeFocusNodes[index],
            maxLength: 1, // Limitar a un solo carácter
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, color: AppColor.white), // Personalización del estilo del texto
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Solo permitir números
            ],
            decoration: InputDecoration(
              counterText: '', // Ocultar contador de caracteres
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColor.white),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                // Mover al siguiente campo si se ingresa un valor
                FocusScope.of(context)
                    .requestFocus(onBoardingController.smsCodeFocusNodes[index + 1]);
              } else if (value.isEmpty && index > 0) {
                // Mover al campo anterior si se borra el valor
                FocusScope.of(context)
                    .requestFocus(onBoardingController.smsCodeFocusNodes[index - 1]);
              } else if(index == 5 && value.isNotEmpty) {
                onBoardingController.verifySmsCode();
              }
            },
          ),
        );
      }),
    ),
  );
}
