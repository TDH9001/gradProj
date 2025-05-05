import 'package:flutter/material.dart';

class AnimatedHeroDialog {
  static void showAnimatedWidgetTransition(
      {required BuildContext context,
      required String heroID,
      required Widget displayedWidget}) {
    () {
      Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false,
            barrierColor: Colors.black.withValues(alpha: 0.7),
            pageBuilder: (_, __, ___) => GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Hero(
                    tag: heroID,
                    child: displayedWidget,
                  ),
                ),
              ),
            ),
          ));
    }();
  }
}
