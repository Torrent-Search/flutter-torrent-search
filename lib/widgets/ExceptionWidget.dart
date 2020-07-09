/*
 *     Copyright (C) 2020 by Tejas Patil <tejasvp25@gmail.com>
 *
 *     torrentsearch is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     torrentsearch is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with torrentsearch.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:torrentsearch/network/exceptions/InternalServerError.dart';
import 'package:torrentsearch/network/exceptions/NoContentFoundException.dart';

class ExceptionWidget extends StatelessWidget {
  final Object _exception;

  ExceptionWidget(this._exception);

  @override
  Widget build(BuildContext context) {
    switch (_exception.runtimeType) {
      case NoContentFoundException:
        return noContentFound();
        break;
      case InternalServerError:
        return serverError();
        break;
      case SocketException:
        return noInternet();
        break;
      default:
        return unExpectedError();
    }
  }

  Widget noContentFound() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.not_interested,
          size: 50.0,
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          "No Content Found",
          style: TextStyle(
            fontSize: 20.0,
          ),
        )
      ],
    ));
  }

  Widget serverError() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.error_outline,
          size: 50.0,
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          "Sorry for incovenience\nServer is not working properly",
          style: TextStyle(
            fontSize: 20.0,
          ),
          textAlign: TextAlign.center,
        )
      ],
    ));
  }

  Widget noInternet() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.cloud_off,
          size: 50.0,
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          "Check Your internet connection",
          style: TextStyle(
            fontSize: 20.0,
          ),
          textAlign: TextAlign.center,
        )
      ],
    ));
  }

  Widget unExpectedError() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.error_outline,
          size: 50.0,
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          "Unexpcted Error Occured",
          style: TextStyle(
            fontSize: 20.0,
          ),
          textAlign: TextAlign.center,
        )
      ],
    ));
  }
}
