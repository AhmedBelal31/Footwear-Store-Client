String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }

  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  }

  bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
  bool hasLowercase = value.contains(RegExp(r'[a-z]'));
  bool hasDigit = value.contains(RegExp(r'[0-9]'));
  bool hasSpecialCharacter =
  value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  if (!hasUppercase) {
    return 'Password must contain uppercase letter';
  }

  if (!hasLowercase) {
    return 'Password must contain lowercase letter';
  }

  if (!hasDigit) {
    return 'Password must contain at least one digit';
  }

  if (!hasSpecialCharacter) {
    return 'Password must contain special character';
  }

  return null;
}