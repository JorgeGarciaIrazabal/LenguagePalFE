import 'dart:async';

import 'package:language_pal/api_clients/lp_client.dart';
import 'package:language_pal/models/course.dart';
import 'package:language_pal/models/flashcard.dart';
import 'package:logging/logging.dart';

class _CoursesApi extends LPClient {
  final Logger log = new Logger('_CoursesApi');

  Future<List<CourseModel>> getCourses() async {
    var response = await get('courses/');
    return response.body['data'].map<CourseModel>((value) {
      return CourseModel.fromMap(value);
    }).toList();
  }

  Future<CourseModel> getCourse(int id) async {
    var response = await get('courses/$id/');
    return CourseModel.fromMap(response.body['data']);
  }

  Future<CourseModel> postCourse(CourseModel course) async {
    var response = await post('courses/', body: course.toMapToUpload());
    return CourseModel.fromMap(response.body['data']);
  }

  Future<List<FlashcardModel>> getFlashCards(int courseId) async {
    var response = await get('courses/$courseId/cards/');
    return response.body['data'].map<FlashcardModel>((value) {
      return FlashcardModel.fromMap(value);
    }).toList();
  }

  Future<FlashcardModel> getFlashCard({int courseId, int cardId}) async {
    var response = await get('courses/$courseId/cards/$cardId');
    return FlashcardModel.fromMap(response.body['data']);
  }

  Future<FlashcardModel> postFlashCard({int courseId, FlashcardModel card}) async {
    var response = await post('courses/$courseId/cards/', body: card.toMapToUpload());

    try {
      if(card.soundPath != null) {
            response = await uploadCardSound(
              courseId: courseId,
              cardId: response.body['data']['id'],
              path: card.soundPath,
            );
          }

      if(card.sentenceSoundPath != null) {
            response = await uploadCardSentenceSound(
              courseId: courseId,
              cardId: response.body['data']['id'],
              path: card.sentenceSoundPath,
            );
          }
    } catch (e) {
      log.severe('Error creating flashcard', e);
      await deleteFlashCard(courseId: courseId, cardId: response.body['data']['id']);
      throw e;
    }

    return FlashcardModel.fromMap(response.body['data']);
  }

  Future<LPResponse> deleteFlashCard({int courseId, int cardId}) async {
    return await delete('courses/$courseId/cards/$cardId');
  }

  Future<LPResponse> uploadCardSound({int courseId, int cardId, String path}) async {
    assert(cardId != null);
    assert(courseId != null);
    assert(path != null);

    return await this.uploadFile(
      'courses/$courseId/cards/$cardId/upload-sound',
      path: path,
    );
  }

  Future<LPResponse> uploadCardSentenceSound({int courseId, int cardId, String path}) async {
    assert(cardId != null);
    assert(courseId != null);
    assert(path != null);

    return await this.uploadFile(
      'courses/$courseId/cards/$cardId/upload-sentence-sound',
      path: path,
    );
  }
}

_CoursesApi _api;

_CoursesApi getCourseApi() {
  if (_api == null) {
    _api = new _CoursesApi();
  }
  return _api;
}
