import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/quiz/models/question.dart';
import 'package:trash_track_admin/features/quiz/models/quiz.dart';
import 'package:trash_track_admin/features/quiz/services/quiz_service.dart';

class QuizEditScreen extends StatefulWidget {
  final Quiz quiz;
  final Function(String) onUpdateRoute;

  QuizEditScreen({
    required this.quiz,
    required this.onUpdateRoute,
  });

  @override
  _QuizEditScreenState createState() => _QuizEditScreenState();
}

class _QuizEditScreenState extends State<QuizEditScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<Question> questions = [];
  late QuizService _quizService;

  @override
  void initState() {
    super.initState();
    _quizService = QuizService();
    titleController.text = widget.quiz.title ?? '';
    descriptionController.text = widget.quiz.description ?? '';
    questions.addAll(widget.quiz.questions!.map((questionData) {
      return Question.fromJson(questionData);
    }).toList());
  }

  void _goBack() {
    widget.onUpdateRoute('quiz');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: _goBack,
                  ),
                ],
              ),
              const SizedBox(height: 100),
              Text(
                'Edit Quiz',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF49464E),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Color(0xFF49464E),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 1),
              SizedBox(
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF49464E),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Color(0xFF49464E),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Questions:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF49464E),
                ),
              ),
              SizedBox(height: 16),
              Column(
                children: questions
                    .asMap()
                    .entries
                    .map((entry) => Column(
                          children: [
                            Text(
                              'Question ${entry.key + 1}:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF49464E),
                              ),
                            ),
                            SizedBox(height: 5),
                            QuestionInput(
                              question: entry.value,
                              onDelete: () {
                                setState(() {
                                  questions.removeAt(entry.key);
                                });
                              },
                              onQuestionChanged: (updatedQuestion) {
                                setState(() {
                                  questions[entry.key] = updatedQuestion;
                                });
                              },
                            ),
                          ],
                        ))
                    .toList(),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    questions.add(Question());
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF49464E),
                  minimumSize: Size(400, 48),
                ),
                child: Text('Add Question'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final editedQuiz = Quiz(
                    id: widget.quiz.id,
                    title: titleController.text,
                    description: descriptionController.text,
                    questions: questions.map((q) => q.toJson()).toList(),
                  );

                  try {
                    await _quizService.update(editedQuiz);

                    widget.onUpdateRoute('quiz');
                  } catch (error) {
                    print('Error editing quiz: $error');
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF49464E),
                  minimumSize: Size(400, 48),
                ),
                child: Text('Edit Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionInput extends StatelessWidget {
  final Question question;
  final VoidCallback onDelete;
  final Function(Question) onQuestionChanged;

  QuestionInput({
    required this.question,
    required this.onDelete,
    required this.onQuestionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
            margin: EdgeInsets.only(bottom: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                color: const Color(
                    0xFF49464E), // Fixed the missing '0' in the color code
              ),
            ),
            child: TextFormField(
              onChanged: (value) {
                question.content = value;
                onQuestionChanged(question);
              },
              decoration: InputDecoration(
                labelText: 'Question Content',
                border: InputBorder.none,
              ),
              style: TextStyle(
                color: Color(0xFF49464E),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
            margin: EdgeInsets.only(bottom: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                color: const Color(
                    0xFF49464E), // Fixed the missing '0' in the color code
              ),
            ),
            child: TextFormField(
              onChanged: (value) {
                question.points = int.tryParse(value) ?? 0;
                onQuestionChanged(question);
              },
              decoration: InputDecoration(
                labelText: 'Points',
                border: InputBorder.none,
              ),
              style: TextStyle(
                color: Color(0xFF49464E),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Answers:', // Redesigned text
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF49464E),
            ),
          ),
          SizedBox(height: 16),
          Column(
            children: question.answers?.asMap().entries.map((entry) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 0,
                          ),
                          margin: EdgeInsets.only(bottom: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(
                                  0xFF49464E), // Fixed the missing '0' in the color code
                            ),
                          ),
                          child: TextFormField(
                            onChanged: (value) {
                              entry.value['content'] = value;
                              onQuestionChanged(question);
                            },
                            decoration: InputDecoration(
                              labelText: 'Answer Content',
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: Color(0xFF49464E),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        flex: 1,
                        child: Switch(
                          value: entry.value['isTrue'] == true,
                          onChanged: (value) {
                            entry.value['isTrue'] = value;
                            onQuestionChanged(question);
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (question.answers != null) {
                            question.answers!.removeAt(entry.key);
                            onQuestionChanged(question);
                          }
                        },
                        color: Colors.red, // Set the icon color to red
                        icon: Icon(Icons.delete), // Use the delete icon
                        padding:
                            EdgeInsets.zero, // Remove padding around the icon
                        splashRadius: 24, // Adjust the splash radius as needed
                      )
                    ],
                  );
                }).toList() ??
                [],
          ),
          SizedBox(
            width: 400, // Set the width of the buttons to 400
            child: ElevatedButton(
              onPressed: () {
                if (question.answers == null) {
                  question.answers = [];
                }
                question.answers!.add({'content': '', 'isTrue': false});
                onQuestionChanged(question);
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(
                    0xFF49464E), // Fixed the missing '0' in the color code
              ),
              child: Text('Add Answer'),
            ),
          ),
          SizedBox(height: 5),
          SizedBox(
            width: 400, // Set the width of the button to 400
            child: ElevatedButton(
              onPressed: onDelete,
              style: ElevatedButton.styleFrom(primary: Colors.redAccent),
              child: Text('Delete Question'),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
