part of 'styles_bloc.dart';

class StylesEvent extends Equatable {
  final int colorCode;
  final bool darkMode;

  const StylesEvent({this.colorCode = 4286336511, @required this.darkMode});

  StylesEvent copyWith({int colorCode, bool darkMode, bool systemAccent}) =>
      StylesEvent(
        darkMode: darkMode ?? this.darkMode,
        colorCode: colorCode ?? this.colorCode,
      );

  @override
  List<Object> get props => [colorCode, darkMode];
}
