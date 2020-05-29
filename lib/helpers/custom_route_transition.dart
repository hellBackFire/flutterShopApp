import "package:flutter/material.dart";

class CustomRouteTranstion<T> extends MaterialPageRoute<T> {
  CustomRouteTranstion({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}
