import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lekra/services/theme.dart';

enum ButtonType {
  primary,
  secondary,
  tertiary,
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.title,
    this.child,
    this.type = ButtonType.primary,
    required this.onTap,
    this.disabledColor,
    this.color,
    this.height = 45,
    this.isLoading = false,
    this.radius = 6,
    this.elevation = 0,
    this.fontSize = 16,
    this.textStyle,
    this.borderColor,

    // Gradient
    this.gradient,
    this.gradientBegin = Alignment.centerLeft,
    this.gradientEnd = Alignment.centerRight,
  })  : assert(
          title == null || child == null,
          'Cannot provide both a title and a child',
        ),
        super(key: key);

  const CustomButton.tertiary({
    Key? key,
    this.title,
    this.child,
    this.type = ButtonType.tertiary,
    required this.onTap,
    this.disabledColor,
    this.color,
    this.height = 45,
    this.isLoading = false,
    this.radius = 6,
    this.elevation = 0,
    this.fontSize,
    this.textStyle,
    this.borderColor,

    // Gradient
    this.gradient,
    this.gradientBegin = Alignment.centerLeft,
    this.gradientEnd = Alignment.centerRight,
  })  : assert(
          title == null || child == null,
          'Cannot provide both a title and a child',
        ),
        super(key: key);

  /// Button title
  final String? title;

  /// Custom button child
  final Widget? child;

  /// Button type
  final ButtonType type;

  /// Loading state
  final bool isLoading;

  /// Disabled color
  final Color? disabledColor;

  /// Solid button color
  final Color? color;

  /// Border color
  final Color? borderColor;

  /// Button height
  final double? height;

  /// Border radius
  final double radius;

  /// Button callback
  final Function()? onTap;

  /// Elevation
  final double elevation;

  /// Font size
  final double? fontSize;

  /// Custom text style
  final TextStyle? textStyle;

  /// Optional gradient
  final Gradient? gradient;

  /// Gradient start
  final AlignmentGeometry gradientBegin;

  /// Gradient end
  final AlignmentGeometry gradientEnd;

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ButtonType.primary:
        return _buildPrimaryButton(context);

      case ButtonType.secondary:
        return _buildSecondaryButton(context);

      case ButtonType.tertiary:
        return _buildTertiaryButton(context);
    }
  }

  // ============================================================
  // PRIMARY BUTTON
  // ============================================================

  Widget _buildPrimaryButton(BuildContext context) {
    final bool hasGradient = gradient != null;

    final Gradient? buttonGradient = isLoading
        ? null
        : gradient ??
            LinearGradient(
              begin: gradientBegin,
              end: gradientEnd,
              colors: [
                primaryColor,
                primaryColor.withValues(alpha: 0.75),
              ],
            );

    return Material(
      color: Colors.transparent,
      elevation: elevation,
      borderRadius: BorderRadius.circular(radius),
      child: Ink(
        height: height,
        decoration: BoxDecoration(
          color: isLoading
              ? disabledColor ?? Theme.of(context).disabledColor
              : hasGradient
                  ? null
                  : color ?? Theme.of(context).primaryColor,

          gradient: buttonGradient,

          borderRadius: BorderRadius.circular(radius),

          // Only use borderColor when gradient is NOT provided
          border: hasGradient
              ? null
              : Border.all(
                  color: borderColor ?? primaryColor,
                  width: 1,
                ),
        ),
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Center(
            child: _buildButtonContent(
              context,
              loadingColor: Colors.white,
              defaultTextColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECONDARY BUTTON
  // ============================================================

  Widget _buildSecondaryButton(BuildContext context) {
    final BorderSide borderSide = BorderSide(
      color: borderColor ?? primaryColor,
      width: 1,
    );

    return Material(
      color: Colors.transparent,
      elevation: elevation,
      borderRadius: BorderRadius.circular(radius),
      child: Ink(
        height: height,
        decoration: BoxDecoration(
          color: color ?? Colors.transparent,
          borderRadius: BorderRadius.circular(radius),
          border: Border.fromBorderSide(borderSide),
        ),
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Center(
            child: _buildButtonContent(
              context,
              loadingColor: primaryColor,
              defaultTextColor: primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TERTIARY BUTTON
  // ============================================================

  Widget _buildTertiaryButton(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onTap,
      child: _buildButtonContent(
        context,
        loadingColor: Theme.of(context).primaryColor,
        defaultTextColor: Theme.of(context).primaryColor,
      ),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _buildButtonContent(
    BuildContext context, {
    required Color loadingColor,
    required Color defaultTextColor,
  }) {
    if (isLoading) {
      return SizedBox(
        width: 20.w,
        height: 20.w,
        child: CircularProgressIndicator(
          color: loadingColor,
          strokeWidth: 2,
        ),
      );
    }

    if (child != null) {
      return child!;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Text(
        title ?? '',
        textAlign: TextAlign.center,
        style: textStyle ??
            GoogleFonts.montserrat(
              color: defaultTextColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
