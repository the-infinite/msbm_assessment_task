import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:msbm_assessment_test/helper/colors.dart';
import 'package:msbm_assessment_test/helper/dimensions.dart';
import 'package:msbm_assessment_test/helper/regions.dart';
import 'package:msbm_assessment_test/helper/styles.dart';

class CountryCodePicker extends StatefulWidget {
  final ValueNotifier<Country?> controller;
  final List<Country> countries;
  final void Function() dismiss;

  const CountryCodePicker({
    super.key,
    required this.controller,
    required this.countries,
    required this.dismiss,
  });

  @override
  State createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePicker> {
  void selectCountry(Country country) {
    widget.controller.value = country;
    widget.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final size = MediaQuery.of(context).size;
    final controller = TextEditingController();
    final cancelController = ValueNotifier(false);

    void fetchSearchResults(String query) {
      List<Country> used = [];

      if (query.isEmpty) {
        used.addAll(widget.countries);
        cancelController.value = false;
      } else {
        query = query.toLowerCase();
        cancelController.value = true;
        used.addAll(
          widget.countries.where(
            (country) =>
                country.dialCode.contains(query) ||
                country.name.toLowerCase().contains(query) ||
                country.shortCode.toLowerCase().contains(query),
          ),
        );
      }
    }

    // You can close this now.
    return IntrinsicHeight(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: size.height * 0.5,
        ),
        padding: const EdgeInsets.only(
          left: Dimensions.paddingSizeDefault,
          right: Dimensions.paddingSizeDefault,
        ),
        margin: EdgeInsets.only(
          bottom: bottom,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // First, the title of the country code picker.
            Text(
              "Pick your country code",
              textAlign: TextAlign.center,
              style: fontSemiBold.copyWith(
                fontSize: Dimensions.fontSizeOverLarge,
              ),
            ),

            // For some space here.
            const SizedBox(height: Dimensions.paddingSizeLarge),

            // Next, the text field that is the search text.
            ValueListenableBuilder(
              valueListenable: cancelController,
              builder: (context, canCancel, _) {
                return TextField(
                  textInputAction: TextInputAction.search,
                  controller: controller,
                  keyboardType: TextInputType.text,
                  onChanged: fetchSearchResults,
                  autocorrect: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      borderSide: const BorderSide(
                        color: ThemeColors.textfieldLabelColor,
                      ),
                    ),
                    hintText: "Select country",
                    hintStyle: TextStyle(
                      color: Theme.of(context).disabledColor,
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                    fillColor: ThemeColors.textfieldFillNormal,
                    filled: true,
                    suffixIcon: canCancel
                        ? InkWell(
                            onTap: () {
                              controller.clear();
                              fetchSearchResults("");
                            },
                            child: const Icon(
                              Icons.close,
                              size: 20,
                              color: ThemeColors.textfieldIconColor,
                            ),
                          )
                        : null,
                  ),
                  style: const TextStyle(
                    color: ThemeColors.textfieldColor,
                  ),
                );
              },
            ),

            //? Next for the countries themselves.
            ValueListenableBuilder(
              valueListenable: widget.controller,
              builder: (context, selectedCountry, _) {
                return Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // First, the space.
                        const SizedBox(
                          height: Dimensions.paddingSizeLarge,
                        ),

                        // Then return these.
                        ...List.generate(
                          widget.countries.length,
                          (index) {
                            final currentCountry = widget.countries[index];

                            //? For the selected country....
                            return InkWell(
                              onTap: () => selectCountry(currentCountry),
                              child: Padding(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    //? For the first half...
                                    Row(
                                      children: [
                                        //? If this is our currently selected country.
                                        if (selectedCountry?.shortCode == currentCountry.shortCode)
                                          const Padding(
                                            padding: EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                                            child: Icon(
                                              Icons.done,
                                              color: ThemeColors.primaryColor,
                                              size: Dimensions.fontSizeDefault,
                                            ),
                                          ),

                                        // The country flag.
                                        SvgPicture.asset(
                                          currentCountry.flag,
                                          height: Dimensions.fontSizeDefault,
                                        ),

                                        // Some space for a bit.
                                        const SizedBox(width: Dimensions.paddingSizeSmall),

                                        // Something else to go here.
                                        Text(
                                          currentCountry.name,
                                          style: const TextStyle(
                                            fontSize: Dimensions.fontSizeDefault,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Next, for the country dialcode.
                                    Text(
                                      currentCountry.dialCode,
                                      style: const TextStyle(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: ThemeColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Finally, some space.
            const SizedBox(height: Dimensions.paddingSize1XL),
          ],
        ),
      ),
    );
  }
}
