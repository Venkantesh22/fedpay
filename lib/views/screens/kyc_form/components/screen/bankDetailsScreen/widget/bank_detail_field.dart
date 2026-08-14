import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class BankDetailField extends StatelessWidget {
  final TextEditingController controller;
  final String heading;
  final String hintText;

  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  final bool isRequired;
  final bool readOnly;

  final int? maxLength;
  final int maxLines;

  final List<TextInputFormatter>? inputFormatters;

  final String? Function(String?)? validator;

  const BankDetailField({
    super.key,
    required this.controller,
    required this.heading,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.isRequired = true,
    this.readOnly = false,
    this.maxLength,
    this.maxLines = 1,
    this.inputFormatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextFieldWithHeading(
      controller: controller,
      heading: heading,
      hindText: hintText,
      isRequired: isRequired,
      readOnly: readOnly,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      borderColor: primaryColor,
      bgColor: primaryColorLight,
      inputFormatters: inputFormatters,
      validator: validator,
    );
  }
}