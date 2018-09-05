import 'package:audioplayer2/audioplayer2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:language_pal/api_clients/lp_client.dart';
import 'package:language_pal/models/flashcard.dart';

class Flashcard extends StatelessWidget {
  final FlashcardModel _flashcard;
  final audioPlayer = new AudioPlayer();

  FlashcardModel get flashcard => _flashcard;

  Flashcard(this._flashcard);

  @override
  Widget build(BuildContext context) {
    audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        print('Playing');
      } else if (s == AudioPlayerState.STOPPED) {
        print('Stopped');
      }
    }, onError: (msg) {
      print('Error $msg');
    });

    return new Swiper(
      itemBuilder: (BuildContext context, int index) {
        return index == 0 ? buildForward(context) : buildBackward(context);
      },
      itemCount: 2,
      viewportFraction: 1.0,
      scale: 0.95,
      loop: false,
    );
  }

  Card buildForward(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return new Card(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Text(
            flashcard.text,
            textAlign: TextAlign.center,
            style: textTheme.display3,
          ),
          new Text(
            flashcard.sentence ?? '',
            textAlign: TextAlign.center,
            style: textTheme.title,
          ),
          buildSoundPlayers(),
        ],
      ),
    );
  }

  Card buildBackward(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return new Card(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Text(
            flashcard.translation,
            textAlign: TextAlign.center,
            style: textTheme.display3,
          ),
          new Text(
            flashcard.definition ?? '',
            textAlign: TextAlign.center,
            style: textTheme.title,
          ),
        ],
      ),
    );
  }

  Row buildSoundPlayers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        buildSoundPlayer(flashcard.soundPath, 'Listen'),
        buildSoundPlayer(flashcard.sentenceSoundPath, 'Sentence'),
      ],
    );
  }

  Column buildSoundPlayer(String path, String label) {
    return Column(
      children: <Widget>[
        new IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: path == null
              ? null
              : () async {
                  var cacheManager = await CacheManager.getInstance();
                  var file = await cacheManager.getFile(LPClient.domain + path);
                  await audioPlayer.play(file.path);
                },
        ),
        new Text(label),
      ],
    );
  }
}
