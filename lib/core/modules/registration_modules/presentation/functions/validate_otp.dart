
String? validateOTP(String? value) {
  if (value == null || value.isEmpty) {
    return 'OTP is required';
  }

  // Regex to match exactly 6 digits
  final RegExp regex = RegExp(r'^\d{6}$');

  if (!regex.hasMatch(value)) {
    return 'Enter a valid 6-digit OTP';
  }

  return null;
}