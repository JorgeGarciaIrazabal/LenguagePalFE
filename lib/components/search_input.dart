import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:language_pal/sevices/input_utils.dart';

typedef void Callback(String s);

class SearchInput extends StatelessWidget {
  final InputDecoration decoration;
  final bool autofocus;
  final Callback onSearch;
  final TextEditingController controller;
  final Debouncer onSearchDebouncer =
      new Debouncer(delay: new Duration(milliseconds: 500));

  SearchInput({
    @required this.onSearch,
    this.decoration: const InputDecoration(
        labelText: 'Search', icon: const Icon(Icons.search)),
    this.autofocus: false,
    this.controller,
  });

  handleOnSaved(val) {}

  @override
  Widget build(BuildContext context) {
    return new TextField(
      controller: this.controller,
      autofocus: this.autofocus,
      decoration: this.decoration,
      onChanged: (val) =>
          this.onSearchDebouncer.debounce(() => this.onSearch(val)),
    );
  }
}
