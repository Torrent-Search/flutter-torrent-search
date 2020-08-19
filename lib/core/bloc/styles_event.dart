part of 'styles_bloc.dart';

/// @param colorCode Accent Color Code
/// @param darkMode [required_param]Dark Mode
class StylesEvent extends Equatable {
  final int colorCode;
  final bool darkMode;

  const StylesEvent({this.colorCode = 4286336511, @required this.darkMode});

  @override
  List<Object> get props => [colorCode, darkMode];
}
