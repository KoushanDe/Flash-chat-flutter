import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({Key key, @required bool visible, @required this.text})
      : _visible = visible,
        super(key: key);

  final bool _visible;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Container(
        height: 38.0,
        margin: EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
