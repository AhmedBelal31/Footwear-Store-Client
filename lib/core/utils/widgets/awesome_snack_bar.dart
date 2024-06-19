import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

SnackBar customFailureSnackBar({required String errorMessage}) {
  return SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Error',
      message: "Login failed! ${errorMessage}",
      contentType: ContentType.failure,
    ),
  );
}

SnackBar customSuccessSnackBar({required String successMessage}) {
  return SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Success',
      message: successMessage,
      contentType: ContentType.success,
    ),
  );
}
