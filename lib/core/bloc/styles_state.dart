part of 'styles_bloc.dart';

/// @param ThemeData App Theme Data
/// @param darkMode [required_param]Dark Mode
abstract class StylesState extends Equatable {
  final ThemeData themeData;
  final bool darkMode;

  const StylesState(this.themeData, {this.darkMode = false});
}

/// @param colorCode Accent Color Code
/// @param darkMode [required_param]Dark Mode
class StylesDarkModeState extends StylesState {
  final int colorCode;

  @override
  // ignore: overridden_fields
  final bool darkMode;

  const StylesDarkModeState(ThemeData themeData,
      {this.darkMode, this.colorCode = 4286336511})
      : super(themeData);

  @override
  List<Object> get props => [themeData];
}
