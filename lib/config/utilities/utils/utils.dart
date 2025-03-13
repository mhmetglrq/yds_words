import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:yds_words/config/extensions/context_extension.dart';

class Utils {
  Utils._();

  static void showNotification(BuildContext context, String title, String body,
      {ToastificationType type = ToastificationType.error}) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      type: type,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      title: Text(
        title,
        style: context.textTheme.labelMedium?.copyWith(color: Colors.white),
      ),
      // you can also use RichText widget for title and description parameters
      description: RichText(
        text: TextSpan(
          text: body,
          style: context.textTheme.bodySmall?.copyWith(color: Colors.white),
        ),
      ),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
    );
  }
}
