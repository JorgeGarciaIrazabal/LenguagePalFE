import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:language_pal/states/stateful_dialog_state.dart';
import 'package:scoped_model/scoped_model.dart';

typedef Widget _Builder(BuildContext context, Widget child, StatefulDialogState model);

class ControlledDialog extends StatelessWidget {
  final state = new StatefulDialogState();
  final _Builder builder;

  ControlledDialog({
    @required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModel<StatefulDialogState>(
      model: this.state,
      child: ScopedModelDescendant<StatefulDialogState>(
        builder: this.builder,
      ),
    );
  }
}
