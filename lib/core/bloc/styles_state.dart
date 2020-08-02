part of 'styles_bloc.dart';

abstract class StylesState extends Equatable {
  final ThemeData themeData;
  final bool darkMode;

  const StylesState(this.themeData, {this.darkMode = false});
}

class StylesDarkModeState extends StylesState {
  final int colorCode;

  final bool darkMode;

  const StylesDarkModeState(ThemeData themeData,
      {this.darkMode, this.colorCode = 4286336511})
      : super(themeData);

  @override
  List<Object> get props => [themeData];
}
