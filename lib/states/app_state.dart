import 'package:language_pal/states/courses_page_state.dart';
import 'package:language_pal/states/flashcard_page_state.dart';
import 'package:language_pal/states/login_page_state.dart';
import 'package:scoped_model/scoped_model.dart';

class AppState extends Model {
  LoginPageState loginPage;
  CoursesPageState coursesPage;
  FlashcardPageState flashcardPage;

  AppState() {
    this.loginPage = new LoginPageState(this.notifyListeners);
    this.coursesPage = new CoursesPageState(this.notifyListeners);
    this.flashcardPage = new FlashcardPageState(this.notifyListeners);
  }
}



