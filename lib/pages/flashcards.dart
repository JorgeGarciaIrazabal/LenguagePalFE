import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:language_pal/api_clients/cousers_api.dart';
import 'package:language_pal/components/app_bars.dart';
import 'package:language_pal/components/audio_input.dart';
import 'package:language_pal/components/controlled_dialog.dart';
import 'package:language_pal/components/flashcard.dart';
import 'package:language_pal/components/snack_bar_shortcuts.dart';
import 'package:language_pal/components/user_drawer.dart';
import 'package:language_pal/models/flashcard.dart';
import 'package:language_pal/states/app_state.dart';
import 'package:language_pal/states/stateful_dialog_state.dart';
import 'package:logging/logging.dart';

class FlashcardsPage extends StatelessWidget {
  static const String routeName = '/flashcards';
  final Logger log = new Logger('FlashcardsPage');
  final String title;
  final AppState state;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  FlashcardsPage({this.title = 'Your Flashcards', this.state});

  factory FlashcardsPage.forDesignTime() {
    return new FlashcardsPage(title: 'test');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: AppBarFactory.authAppBar(title: new Text('Select Course'), context: context),
      body: new Container(
        padding: const EdgeInsets.all(10.0),
        child: new Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Flashcard(state.flashcardPage.flashcards[index]);
          },
          itemCount: state.flashcardPage.flashcards.length,
          viewportFraction: 0.85,
          scale: 0.95,
          curve: Curves.fastOutSlowIn,
          scrollDirection: Axis.vertical,
        ),
      ),
      drawer: new UserDrawer(
        state: state,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          FlashcardModel card = await _onFloatingActionButtonPressed(scaffoldKey.currentContext);
          if (card != null) {
            state.flashcardPage.addFlashcard(card);
          } else {

          }
        },
        tooltip: 'Add',
        child: new Icon(Icons.add),
      ),
    );
  }

  Future<FlashcardModel> _onFloatingActionButtonPressed(BuildContext context) async {
    final formKey = new GlobalKey<FormState>();
    FlashcardModel card = new FlashcardModel();

    return showDialog<FlashcardModel>(
      context: context,
      builder: (BuildContext context) {
        return new ControlledDialog(
          builder: (context, child, model) {
            return alertDialog(card, context, model, formKey);
          },
        );
      },
    );
  }

  AlertDialog alertDialog(FlashcardModel card, BuildContext context, StatefulDialogState dialogModel, formKey) {
    return new AlertDialog(
      title: new Text('Create Flashcard'),
      content: new Form(
        key: formKey,
        child: SingleChildScrollView(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Word'),
                validator: (val) => val.isEmpty ? 'Please, add a word.' : null,
                onSaved: (val) => card.text = val,
              ),
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Translation'),
                onSaved: (val) => card.translation = val.isEmpty ? null : val,
              ),
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Definition'),
                onSaved: (val) => card.definition = val.isEmpty ? null : val,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Expanded(
                      child: new AudioInput(
                        label: Text('Translation'),
                        onFinished: (recording) {
                          card.soundPath = recording.path;
                        },
                      ),
                    ),
                    new Expanded(
                      child: new AudioInput(
                        label: Text('Sentence'),
                        onFinished: (recording) {
                          card.sentenceSoundPath = recording.path;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: Text(dialogModel.loading ? 'saving' : 'save'),
          onPressed: dialogModel.loading
              ? null
              : () async {
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();
                    dialogModel.loading = true;
                    try {
                      var newCard = await getCourseApi().postFlashCard(
                        courseId: state.flashcardPage.courseModel.id,
                        card: card,
                      );
                      Navigator.of(context).pop(newCard);
                    } catch (e) {
                      Navigator.of(context).pop(null);
                    } finally {
                      dialogModel.loading = false;
                    }
                  }
                },
        ),
      ],
    );
  }
}
