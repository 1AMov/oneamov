import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:oneamov/helpers/text_styles.dart';

import '../common_functions/read_json_file.dart';
import '../config.dart';
import '../models/currency.dart';
import 'progress_widget.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final double? width;
  final IconData? prefixIcon;
  final FocusNode? focusNode;
  final String labelText;
  final String hintText;
  final bool? obscureText;
  final bool? enabled;
  final int? maxLines;
  final int? maxLength;
  final Widget? suffix;
  final Widget? suffixIcon;
  final InputBorder? border;
  final String? fontFamily;
  // final void Function()? onSuffixTap;
  final TextInputType textInputType;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final FontWeight? fontWeight;
  final double? fontSize;

  const CustomTextField({
    super.key,
    required this.controller,
    this.width,
    this.prefixIcon,
    this.focusNode,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
  this.maxLength,
    this.suffix,
    this.suffixIcon,
    required this.textInputType,
    this.fontFamily,
    this.border,
    // this.onSuffixTap,
    this.onChanged,
    this.validator,
    this.fontWeight,
    this.fontSize,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: widget.width ?? size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: TextFormField(
          focusNode: widget.focusNode ?? focusNode,
          controller: widget.controller,
          obscureText: widget.obscureText!,
          obscuringCharacter: "*",
          // readOnly: widget.readOnly!,
          enabled: widget.enabled,
          onChanged: widget.onChanged,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(13.0),
              isDense: true,
              alignLabelWithHint: true,
              labelText: widget.labelText.isEmpty ? null : widget.labelText,
              hintStyle: context.bodyLarge?.copyWith(
                  fontFamily: widget.fontFamily, color: Config.drawerColor),
              hintText: widget.hintText,
              prefixIcon:
                  widget.prefixIcon != null ? Icon(widget.prefixIcon!) : null,
              suffixIcon: widget.suffixIcon,
              // suffix: widget.suffix,
              labelStyle: focusNode.hasFocus
                  ? const TextStyle(color: Config.themeColor)
                  : context.headlineMedium?.copyWith(
                      fontFamily: widget.fontFamily,
                      color: Config.drawerColor,
                      fontSize: widget.fontSize ?? 25,
                      fontWeight: widget.fontWeight),
              border: widget.border ??
                  const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.black, width: 0.5),
                  ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: Config.themeColor, width: 1.0),
              )),
          validator: widget.validator,
        ),
      ),
    );
  }
}

class CustomPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final bool? enabled;
  final void Function(PhoneNumber) onChanged;
  final String? Function(PhoneNumber?)? validator;

  const CustomPhoneField({
    super.key,
    required this.controller,
    this.enabled = true,
    required this.onChanged,
    this.validator,
  });

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: IntlPhoneField(
        controller: widget.controller,
        enabled: widget.enabled!,
        keyboardType: TextInputType.phone,
        onChanged: widget.onChanged,
        initialCountryCode: "KE",
        // style: const TextStyle(fontSize: 12.0),
        decoration: const InputDecoration(
            alignLabelWithHint: true,
            hintText: "0000-000-000",
            labelText: "Phone Number",
            // isDense: true,
            contentPadding: EdgeInsets.all(8.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.black, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Config.themeColor, width: 1.0),
            )),
        validator: widget.validator,
      ),
    );
  }
}

class CustomStringDropdown extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final String? hintText;
  final double? maxHeight;
  final bool? enabled;
  final void Function(String?)? onChanged;
  final double? width;
  // final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const CustomStringDropdown({
    super.key,
    required this.items,
    this.selectedItem,
    this.hintText,
    this.maxHeight = 200.0,
    this.enabled = true,
    this.onChanged,
    this.width,
    this.validator,
    // this.suffixIcon
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width: width ?? size.width,
        child: DropdownSearch<String>(
          items: items,
          enabled: enabled!,
          popupProps: PopupProps.menu(
              showSelectedItems:
                  selectedItem != null || selectedItem!.isNotEmpty,
              scrollbarProps: ScrollbarProps(
                trackVisibility: true,
                thumbVisibility: true,
                thumbColor: Colors.grey.withOpacity(0.5),
                trackColor: Colors.grey.withOpacity(0.1),
              ),
              itemBuilder: (context, item, isSelected) => Container(
                    color: isSelected
                        ? Config.themeColor.withOpacity(0.1)
                        : Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: Text(
                        item,
                        style: TextStyle(
                            // fontSize: 12.0,
                            color:
                                isSelected ? Config.themeColor : Colors.black,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
                  ),
              constraints: BoxConstraints(maxHeight: maxHeight!)),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
                labelText: hintText,
                hintText: hintText,
                // labelStyle: const TextStyle(
                //     fontSize: 12.0, fontWeight: FontWeight.w700),
                // suffixIcon: suffixIcon!,
                isDense: true,
                contentPadding: const EdgeInsets.all(8.0),
                border: const OutlineInputBorder()),
          ),
          dropdownBuilder: (context, item) {
            return Text(
              item!,
              // style:
              //     const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700),
            );
          },
          onChanged: onChanged,
          selectedItem: selectedItem,
          validator: validator,
        ),
      ),
    );
  }
}

class ObjectPickerDropDown<T> extends StatelessWidget {
  final TextEditingController controller;
  final String? title;
  final String? hintText;
  final bool? enabled;
  final Future<List<T>> Function(String) getItemsList;
  final bool Function(T, T) compareFn;
  final T? selectedItem;
  final Widget Function(BuildContext, T, bool) itemBuilder;
  final String Function(T) itemAsString;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  const ObjectPickerDropDown(
      {super.key,
      required this.controller,
      this.title,
      this.hintText = "Type here to search...",
      this.enabled = true,
      required this.getItemsList,
      required this.compareFn,
      this.selectedItem,
      required this.itemBuilder,
      required this.itemAsString,
      required this.onChanged,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      asyncItems: getItemsList,
      compareFn: compareFn,
      enabled: enabled!,
      clearButtonProps: const ClearButtonProps(isVisible: false),
      popupProps: PopupProps.menu(
        showSelectedItems: selectedItem != null,
        itemBuilder: itemBuilder,
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          // style: const TextStyle(fontSize: 12.0),
          controller: controller,
          decoration: InputDecoration(hintText: hintText
              // suffixIcon: suffixIcon,
              ),
        ),
      ),
      onChanged: onChanged,
      itemAsString: itemAsString,
      selectedItem: selectedItem,
      validator: validator,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
            labelText: title,
            hintText: hintText,
            // suffixIcon: suffixIcon!,
            isDense: true,
            contentPadding: const EdgeInsets.all(8.0),
            border: const OutlineInputBorder()),
      ),
    );
  }
}

class CurrencyPicker extends StatefulWidget {
  final Currency? selectedCurrency;
  final bool? enabled;
  final void Function(Currency?) onChanged;
  final String? Function(Currency?)? validator;
  const CurrencyPicker(
      {super.key,
      this.selectedCurrency,
      this.enabled = true,
      required this.onChanged,
      this.validator});

  @override
  State<CurrencyPicker> createState() => _CurrencyPickerState();
}

class _CurrencyPickerState extends State<CurrencyPicker> {
  bool loading = false;
  TextEditingController controller = TextEditingController();
  List<Currency> currencies = [];

  @override
  void initState() {
    super.initState();
    getCurrencies();
  }

  Future<void> getCurrencies() async {
    setState(() {
      loading = true;
    });

    List<dynamic> currenciesRaw = await readJson(Config.currenciesJson);

    currencies = List.generate(currenciesRaw.length,
        (index) => Currency.fromJson(currenciesRaw[index]));

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return loading
        ? circularProgress()
        : ObjectPickerDropDown<Currency>(
            controller: controller,
            title: "Currency",
            selectedItem: widget.selectedCurrency,
            enabled: widget.enabled,
            getItemsList: (filter) async {
              if (filter.isNotEmpty) {
                return currencies
                    .where((e) =>
                        e.name.toLowerCase().contains(filter.toLowerCase()) ||
                        e.code.toLowerCase().contains(filter.toLowerCase()))
                    .toList();
              } else {
                return currencies;
              }
            },
            compareFn: (a, b) => a.code == b.code,
            itemBuilder: (ctx, item, isSelected) {
              TextStyle textStyle = TextStyle(
                  color: isSelected ? Config.themeColor : Colors.black);
              return Container(
                width: size.width,
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    color: isSelected
                        ? Config.themeColor.withOpacity(0.2)
                        : Colors.transparent),
                child: ListTile(
                  title: Text(
                    item.code,
                    style: textStyle,
                  ),
                  subtitle: Text(
                    item.name,
                    style: textStyle,
                  ),
                ),
              );
            },
            itemAsString: (i) => i.code,
            onChanged: widget.onChanged,
            validator: widget.validator,
          );
  }
}

class CityPicker extends StatefulWidget {
  final String? selectedCity;
  final bool? enabled;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;
  const CityPicker(
      {super.key,
      this.selectedCity,
      this.enabled = true,
      required this.onChanged,
      this.validator});

  @override
  State<CityPicker> createState() => _CityPickerState();
}

class _CityPickerState extends State<CityPicker> {
  TextEditingController cityCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ObjectPickerDropDown<String>(
      controller: cityCtrl,
      title: "City",
      selectedItem: widget.selectedCity,
      enabled: widget.enabled,
      getItemsList: (filter) async {
        Map<String, dynamic> countriesMap =
            await readJson(Config.countriesAndCitiesJson);

        List<dynamic> rawList = [];

        rawList = countriesMap.values.expand((cities) => cities).toList();

        List<String> citiesList =
            List.generate(rawList.length, (index) => rawList[index].toString());

        if (filter.isNotEmpty) {
          return citiesList
              .where((e) => e.toLowerCase().contains(filter.toLowerCase()))
              .toList();
        } else {
          return citiesList;
        }
      },
      compareFn: (a, b) => a == b,
      itemBuilder: (ctx, item, isSelected) {
        return Container(
          width: size.width,
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              color: isSelected
                  ? Config.themeColor.withOpacity(0.2)
                  : Colors.transparent),
          child: Text(
            item,
            style:
                TextStyle(color: isSelected ? Config.themeColor : Colors.black),
          ),
        );
      },
      itemAsString: (i) => i,
      onChanged: widget.onChanged,
      validator: widget.validator,
    );
  }
}

class CountryPicker extends StatefulWidget {
  final String? title;
  final String? selectedCountry;
  final bool? enabled;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;
  const CountryPicker(
      {super.key,
      this.title = "Country",
      this.selectedCountry,
      this.enabled = true,
      required this.onChanged,
      this.validator});

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  TextEditingController countryCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ObjectPickerDropDown<String>(
      controller: countryCtrl,
      title: widget.title,
      selectedItem: widget.selectedCountry,
      enabled: widget.enabled,
      getItemsList: (filter) async {
        List<String> countriesList = countries.map((e) => e.name).toList();

        if (filter.isNotEmpty) {
          return countriesList
              .where((e) => e.toLowerCase().contains(filter.toLowerCase()))
              .toList();
        } else {
          return countriesList;
        }
      },
      compareFn: (a, b) => a == b,
      itemBuilder: (ctx, item, isSelected) {
        return Container(
          width: size.width,
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              color: isSelected
                  ? Config.themeColor.withOpacity(0.2)
                  : Colors.transparent),
          child: Text(
            item,
            style:
                TextStyle(color: isSelected ? Config.themeColor : Colors.black),
          ),
        );
      },
      itemAsString: (i) => i,
      onChanged: widget.onChanged,
      validator: widget.validator,
    );
  }
}
