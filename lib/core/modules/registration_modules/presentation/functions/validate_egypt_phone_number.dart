String? validateEgyptPhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone number is required';
  }

  // Remove all spaces and dashes
  value = value.replaceAll(RegExp(r'\s+|-'), '');

  // Regex for Egyptian phone number
  final RegExp regex =
  RegExp(r'^(010|011|012|015)\d{8}$|^\+201(0|1|2|5)\d{8}$');

  if (!regex.hasMatch(value)) {
    return 'Enter a valid Egyptian phone number';
  }

  return null;
}