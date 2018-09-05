import 'package:language_pal/models/course.dart';
import 'package:language_pal/models/flashcard.dart';

class FlashcardPageState {
  List<FlashcardModel> _flashcards = [];

  CourseModel courseModel;

  FlashcardPageState(this.notifyListeners);

  List<FlashcardModel> get flashcards => _flashcards;

  set flashcards(List<FlashcardModel> value) {
    _flashcards = value;
    notifyListeners();
  }

  void addFlashcard(FlashcardModel flashcard) {
    _flashcards.add(flashcard);
    notifyListeners();
  }

  final notifyListeners;
}
