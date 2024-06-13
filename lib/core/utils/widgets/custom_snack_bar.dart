import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final String title;
  final String description;
  final Color msgColor;
  final EdgeInsetsGeometry margin;
  final VoidCallback onDismiss;

  const CustomSnackBar({
    super.key,
    required this.title,
    required this.description,
    required this.msgColor,
    required this.margin,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          margin: margin,
          decoration: BoxDecoration(
          color: Colors.grey.shade100.withOpacity(.9),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
          BoxShadow(
            color: Colors.grey.shade800.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 10), // changes position of shadow
          ),
          ],
          ),
          child: ListTile(
            title: Text(
              title,
              style: TextStyle(
                color: msgColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                description,
                style: TextStyle(
                  color: msgColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: onDismiss,
            ),
          ),
        ),
      ),
    );
  }
}

//Show SnackBar

class CustomSnackBarOverlay {
  static OverlayEntry? _overlayEntry;

  static void show(
    BuildContext context, {
    required String message,
    required messageDescription,
    msgColor,
    Duration duration = const Duration(seconds: 5),
  }) {
    if (_overlayEntry != null) {
      hide();
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 10,
        left: 10,
        right: 10,
        child: CustomSnackBar(
          title: message,
          // backgroundColor:  Colors.black,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          onDismiss: hide,
          description: messageDescription,
          msgColor: msgColor,
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    // Automatically hide after the specified duration
    Future.delayed(duration, hide);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
