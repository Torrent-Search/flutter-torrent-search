import 'dart:io';

import 'package:flutter/material.dart';
import 'package:torrentsearch/core/errors/internal_server_error.dart';
import 'package:torrentsearch/core/errors/no_content_found.dart';

class ExceptionWidget extends StatelessWidget {
  final Exception exception;

  const ExceptionWidget(this.exception);

  @override
  Widget build(BuildContext context) {
    print(exception.toString());
    switch (exception.runtimeType) {
      case NoContentFoundException:
        return noContentFound(context);
        break;
      case InternalServerError:
        return serverError(context);
        break;
      case SocketException:
        return noInternet(context);
        break;
      default:
        return unExpectedError(context);
    }
  }

  Widget noContentFound(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 20.0);

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.not_interested,
          size: 50.0,
        ),
        const SizedBox(height: 10.0),
        Text(
          "No Content Found",
          style: textStyle,
        )
      ],
    ));
  }

  Widget serverError(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 20.0);
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.error_outline,
          size: 50.0,
        ),
        const SizedBox(height: 10.0),
        Text(
          "Sorry for incovenience\nServer is not working properly",
          style: textStyle,
          textAlign: TextAlign.center,
        )
      ],
    ));
  }

  Widget noInternet(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 20.0);
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.cloud_off,
          size: 50.0,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          "Check Your internet connection",
          style: textStyle,
          textAlign: TextAlign.center,
        )
      ],
    ));
  }

  Widget unExpectedError(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 20.0);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.error_outline,
            size: 50.0,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            "Unexpcted Error Occured",
            style: textStyle,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
