import 'package:flutter/material.dart';
import '../../core/utils/styles.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String? labelText;
  final int maxLines;
  final TextEditingController? controller;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool obscureText;
  final AutovalidateMode? autovalidateMode;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;

  const CustomTextField(
      {super.key,
      required this.hintText,
      this.labelText,
      this.prefixIcon,
      this.maxLines = 1,
      this.controller,
      this.onFieldSubmitted,
      this.onChanged,
      this.validator,
      this.obscureText = false,
      this.autovalidateMode,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
        controller: controller,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        validator: validator,
        autovalidateMode: autovalidateMode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: Icon(prefixIcon),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide:
                  const BorderSide(color: AppStyles.kPrimaryColor, width: 2)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide:
                  const BorderSide(color: AppStyles.kPrimaryColor, width: 1)),
        ),
      ),
    );
  }
}
