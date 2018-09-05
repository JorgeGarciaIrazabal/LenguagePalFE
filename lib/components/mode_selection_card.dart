import 'dart:ui';

import 'package:flutter/material.dart';

class ModeSelectionCard extends StatelessWidget {
  final AssetImage image;
  final VoidCallback onPressed;
  final Text text;

  const ModeSelectionCard({Key key, this.image, this.onPressed, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.all(15.0),
      child: new Card(
        child: new GestureDetector(
          onTap: this.onPressed,
          child: new Container(
            padding: new EdgeInsets.all(10.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  margin: new EdgeInsets.only(bottom: 10.0),
                  height: 130.0,
                  decoration:
                      new BoxDecoration(image: new DecorationImage(fit: BoxFit.fill, image: image)),
                ),
                text,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
