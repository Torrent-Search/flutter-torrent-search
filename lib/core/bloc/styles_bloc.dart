import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:torrentsearch/core/styles/Styles.dart';

part 'styles_event.dart';
part 'styles_state.dart';

class StylesBloc extends Bloc<StylesEvent, StylesState> {
  StylesBloc()
      : super(
          StylesDarkModeState(
            Styles.themeData(
              darkMode: false,
              color: 4286336511,
            ),
            darkMode: false,
          ),
        );

  @override
  Stream<StylesState> mapEventToState(
    StylesEvent event,
  ) async* {
    yield StylesDarkModeState(
      Styles.themeData(darkMode: event.darkMode, color: event.colorCode),
      darkMode: event.darkMode,
      colorCode: event.colorCode,
    );
  }

  void dispose() {
    close();
  }
}
