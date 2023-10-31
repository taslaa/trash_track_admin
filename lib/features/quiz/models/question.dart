import 'package:json_annotation/json_annotation.dart';
import 'package:trash_track_admin/features/quiz/models/answer.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  int? id;
  String? content;
  int? points;
  List<Map<String, dynamic?>>? answers;

  Question({this.id, this.content, this.points, this.answers});

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}