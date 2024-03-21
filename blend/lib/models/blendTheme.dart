import 'package:flutter/material.dart';

class BlendTheme {
  Brightness? brightness;
  Color? primary;
  Color? onPrimary;
  Color? primaryContainer;
  Color? onPrimaryContainer;
  Color? secondary;
  Color? onSecondary;
  Color? secondaryContainer;
  Color? onSecondaryContainer;
  Color? tertiary;
  Color? onTertiary;
  Color? tertiaryContainer;
  Color? onTertiaryContainer;
  Color? error;
  Color? onError;
  Color? errorContainer;
  Color? onErrorContainer;
  Color? outline;
  Color? background;
  Color? onBackground;
  Color? surface;
  Color? onSurface;
  Color? surfaceVariant;
  Color? onSurfaceVariant;
  Color? inverseSurface;
  Color? onInverseSurface;
  Color? inversePrimary;
  Color? shadow;

  BlendTheme({
    this.brightness,
    this.primary,
    this.onPrimary,
    this.primaryContainer,
    this.onPrimaryContainer,
    this.secondary,
    this.onSecondary,
    this.secondaryContainer,
    this.onSecondaryContainer,
    this.tertiary,
    this.onTertiary,
    this.tertiaryContainer,
    this.onTertiaryContainer,
    this.error,
    this.onError,
    this.errorContainer,
    this.onErrorContainer,
    this.outline,
    this.background,
    this.onBackground,
    this.surface,
    this.onSurface,
    this.surfaceVariant,
    this.onSurfaceVariant,
    this.inverseSurface,
    this.onInverseSurface,
    this.inversePrimary,
    this.shadow,
  });

  BlendTheme.fromJson(Map<String, dynamic> json) {
    brightness = Brightness.dark;
    primary = Color(int.parse(json['primary']));
    onPrimary = Color(int.parse(json['onPrimary']));
    primaryContainer = Color(int.parse(json['primaryContainer']));
    onPrimaryContainer = Color(int.parse(json['onPrimaryContainer']));
    secondary = Color(int.parse(json['secondary']));
    onSecondary = Color(int.parse(json['onSecondary']));
    secondaryContainer = Color(int.parse(json['secondaryContainer']));
    onSecondaryContainer = Color(int.parse(json['onSecondaryContainer']));
    tertiary = Color(int.parse(json['tertiary']));
    onTertiary = Color(int.parse(json['onTertiary']));
    tertiaryContainer = Color(int.parse(json['tertiaryContainer']));
    onTertiaryContainer = Color(int.parse(json['onTertiaryContainer']));
    error = Color(int.parse(json['error']));
    onError = Color(int.parse(json['onError']));
    errorContainer = Color(int.parse(json['errorContainer']));
    onErrorContainer = Color(int.parse(json['onErrorContainer']));
    outline = Color(int.parse(json['outline']));
    background = Color(int.parse(json['background']));
    onBackground = Color(int.parse(json['onBackground']));
    surface = Color(int.parse(json['surface']));
    onSurface = Color(int.parse(json['onSurface']));
    surfaceVariant = Color(int.parse(json['surfaceVariant']));
    onSurfaceVariant = Color(int.parse(json['onSurfaceVariant']));
    inverseSurface = Color(int.parse(json['inverseSurface']));
    onInverseSurface = Color(int.parse(json['onInverseSurface']));
    inversePrimary = Color(int.parse(json['inversePrimary']));
    shadow = Color(int.parse(json['shadow']));
  }
}
