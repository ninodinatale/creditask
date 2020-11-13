import 'package:flutter/material.dart';

class LoadingButtonContent extends StatelessWidget {
  final _isLoading;
  final _text;

  LoadingButtonContent(this._isLoading, this._text);

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: SizedBox(
                height: 20.0, width: 20.0, child: CircularProgressIndicator()))
        : Center(child: Text(_text));
  }
}
