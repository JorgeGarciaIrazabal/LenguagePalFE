import 'dart:async';
import 'dart:io';

import 'package:audio_recorder/audio_recorder.dart' as audio_recorder;
import 'package:simple_permissions/simple_permissions.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecorder {
  int unique = 0;
  Future<bool> record() async {
    if (await SimplePermissions.checkPermission(Permission.RecordAudio) &&
        await SimplePermissions.checkPermission(Permission.WriteExternalStorage)) {
      if (!await isRecording) {
        Directory appDocDirectory = await getApplicationDocumentsDirectory();
        var path = "${appDocDirectory.path}/card_sound_$unique.m4a";
        unique++;
        File file =  new File(path);
        if(await file.exists()) {
          await file.delete();
        }
        audio_recorder.AudioRecorder.start(path: path);
        return true;
      }
    } else {
      var allow = await SimplePermissions.requestPermission(Permission.RecordAudio);
      allow = allow && await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
      if(allow){
        return record();
      }
    }
    return false;
  }

  Future<audio_recorder.Recording> stop() async {
    if (await isRecording) {
      return audio_recorder.AudioRecorder.stop();
    }
  }

  Future<bool> get isRecording {
    return audio_recorder.AudioRecorder.isRecording;
  }
}


AudioRecorder _audioRecorder = new AudioRecorder();

AudioRecorder getAudioRecorder() {
  return _audioRecorder;
}
