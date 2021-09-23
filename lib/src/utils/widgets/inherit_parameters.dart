import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InheritParameters extends InheritedWidget {
  final Future Function({required User user, required String phone})? onSignUp;
  final Function? forgotRequested;

  final Widget child;

  InheritParameters({
    Key? key,
    this.onSignUp,
    this.forgotRequested,
    required this.child,
  }) : super(key: key, child: child);

  static InheritParameters of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<InheritParameters>()!);
  }

  @override
  bool updateShouldNotify(InheritParameters oldWidget) {
    return false;
    // return count != oldWidget.count;
  }
}
