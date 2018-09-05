import 'package:audio_recorder/audio_recorder.dart' as audio_recorder;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:language_pal/sevices/audio_recorder.dart';

typedef void StartCallback();

typedef void StopCallback(audio_recorder.Recording recording);

class AudioInput extends StatefulWidget {
  const AudioInput({
    Key key,
    this.onFinished,
    this.label = const Text("Audio"),
  }) : super(key: key);
  final StopCallback onFinished;
  final Widget label;

  @override
  _AudioInputState createState() => new _AudioInputState();
}

class _AudioInputState extends State<AudioInput> {
  bool recording = false;
  bool recorded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widget.label,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: buildWidgets(),
        ),
      ],
    );
  }

  List<Widget> buildWidgets() {
    var gestureDetector = Padding(
      padding: const EdgeInsets.all(10.0),
      child: new GestureDetector(
        onTapDown: (details) {
          getAudioRecorder().record();
          setState(() {
            recording = true;
            recorded = false;
          });
        },
        onTap: () async {
          widget.onFinished(await getAudioRecorder().stop());
          setState(() {
            recording = false;
            recorded = true;
          });
        },
        onTapCancel: () async {
          await getAudioRecorder().stop();
          setState(() {
            recording = false;
            recorded = false;
          });
        },
        child: new Icon(Icons.volume_up, color: Colors.black87),
      ),
    );

    return <Widget>[
      Padding(
        padding: EdgeInsets.only(right: 8.0),
        child: Row(
          children: <Widget>[
            new Icon(Icons.check, color: recorded ? Colors.green : Colors.white, size: recorded ? 20.0 : 0.0),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(right: recording ? 15.0 : 0.0),
        child: SpinKitThreeBounce(
          color: recording ? Colors.grey : Colors.white,
          size: recording ? 15.0 : 0.0,
        ),
      ),
      gestureDetector,
    ];
  }
}
