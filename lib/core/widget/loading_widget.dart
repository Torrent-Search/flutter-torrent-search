import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
      ),
    );
  }
}
