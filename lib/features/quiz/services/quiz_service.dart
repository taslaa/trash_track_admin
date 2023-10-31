import 'package:trash_track_admin/features/quiz/models/quiz.dart';
import 'package:trash_track_admin/shared/services/base_service.dart';

class QuizService extends BaseService<Quiz> {
  QuizService() : super("Quizzes"); 

  @override
  Quiz fromJson(data) {
    return Quiz.fromJson(data);
  }
}
