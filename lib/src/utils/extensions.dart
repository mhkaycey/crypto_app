import 'dart:async';

import 'package:flutter/material.dart';

extension StringExtension on String {
  String get capitalize => '${this[0].toUpperCase()}${substring(1)}';
}

extension OnTapExtension on Widget {
  Widget onTap(
    VoidCallback onTap, {
    HitTestBehavior behavior = HitTestBehavior.opaque,
  }) {
    return GestureDetector(onTap: onTap, behavior: behavior, child: this);
  }
}

extension PaddingExtension on Widget {
  Widget paddingAll(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: this,
      );
}

extension MarginExtension on Widget {
  Widget marginAll(double value) =>
      Container(margin: EdgeInsets.all(value), child: this);
}

extension VisibilityExtension on Widget {
  Widget visible(bool isVisible) => isVisible ? this : const SizedBox.shrink();
}

extension CenterExtension on Widget {
  Widget center() => Center(child: this);
}

extension FlexExtension on Widget {
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  Widget flexible({int flex = 1}) => Flexible(flex: flex, child: this);
}

extension CardExtension on Widget {
  Widget card({
    EdgeInsets padding = const EdgeInsets.all(12),
    double elevation = 3,
    double borderRadius = 12,
  }) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(padding: padding, child: this),
    );
  }
}

extension RoundedExtension on Widget {
  Widget rounded(double radius) =>
      ClipRRect(borderRadius: BorderRadius.circular(radius), child: this);
}

extension BackgroundExtension on Widget {
  Widget backgroundColor(Color color) => DecoratedBox(
    decoration: BoxDecoration(color: color),
    child: this,
  );
}

extension AlignExtension on Widget {
  Widget align([Alignment alignment = Alignment.center]) =>
      Align(alignment: alignment, child: this);
}

extension TooltipExtension on Widget {
  Widget tooltip(String message) => Tooltip(message: message, child: this);
}

extension ScrollableExtension on Widget {
  Widget scrollable({Axis axis = Axis.vertical}) =>
      SingleChildScrollView(scrollDirection: axis, child: this);
}

extension TextStyleExtension on Text {
  Text bold() => Text(
    data ?? '',
    style: (style ?? const TextStyle()).copyWith(fontWeight: FontWeight.bold),
  );

  Text color(Color color) => Text(
    data ?? '',
    style: (style ?? const TextStyle()).copyWith(color: color),
  );

  Text size(double fontSize) => Text(
    data ?? '',
    style: (style ?? const TextStyle()).copyWith(fontSize: fontSize),
  );
}

extension AnimateOpacityExtension on Widget {
  Widget animateOpacity({
    required bool visible,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: duration,
      child: this,
    );
  }
}

extension AnimateSizeExtension on Widget {
  Widget animateSize({
    required bool visible,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return AnimatedSize(duration: duration, child: this);
  }
}

extension SafeAreaExtension on Widget {
  Widget safe({bool top = true, bool bottom = true}) =>
      SafeArea(top: top, bottom: bottom, child: this);
}

extension DebounceExtension on TextEditingController {
  void debounce(
    VoidCallback onChanged, {
    Duration duration = const Duration(milliseconds: 500),
  }) {
    Timer? debounce;
    addListener(() {
      debounce?.cancel();
      debounce = Timer(duration, onChanged);
    });
  }
}

extension ContextExtension on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
