import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum SnackBars { success, info, warning, error }

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _snackBar({
  BuildContext context,
  ScaffoldState state,
  Widget widget,
  SnackBars type,
}) {
  state = state ?? Scaffold.of(context);
  try {
    return state.showSnackBar(new SnackBar(
      content: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _getIconPerType(type),
          ),
          widget,
        ],
      ),
    ));
  } catch (e) {
    print(e);
  }
}

Icon _getIconPerType(SnackBars type) {
  switch (type) {
    case SnackBars.success:
      return new Icon(
        Icons.check_circle,
        color: Colors.green,
      );
    case SnackBars.warning:
      return new Icon(
        Icons.warning,
        color: Colors.orange,
      );
    case SnackBars.info:
      return new Icon(
        Icons.info,
        color: Colors.blue,
      );
    case SnackBars.error:
      return new Icon(
        Icons.error,
        color: Colors.red,
      );
  }
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBarSuccess({
  BuildContext context,
  ScaffoldState state,
  Widget widget,
}) {
  return _snackBar(context: context, state: state, widget: widget, type: SnackBars.success);
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBarInfo({
  BuildContext context,
  ScaffoldState state,
  Widget widget,
}) {
  return _snackBar(context: context, state: state, widget: widget, type: SnackBars.info);
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBarWarning({
  BuildContext context,
  ScaffoldState state,
  Widget widget,
}) {
  return _snackBar(context: context, state: state, widget: widget, type: SnackBars.warning);
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBarError({
  BuildContext context,
  ScaffoldState state,
  Widget widget,
}) {
  return _snackBar(context: context, state: state, widget: widget, type: SnackBars.error);
}
