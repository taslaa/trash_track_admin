import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_track_admin/features/vehicle-model/models/vehicle_model.dart';
import 'package:trash_track_admin/features/vehicle-model/services/vehicle_models_service.dart';
import 'package:trash_track_admin/features/vehicle-model/widgets/table_cell.dart';
import 'package:trash_track_admin/features/vehicle-model/widgets/paging_component.dart';
import 'package:trash_track_admin/features/quiz/models/quiz.dart';
import 'package:trash_track_admin/features/quiz/services/quiz_service.dart';

class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({
    Key? key,
    this.quiz,
    required this.onEdit,
    required this.onAdd,
  }) : super(key: key);
  final Quiz? quiz;
  final Function(Quiz) onEdit;
  final Function() onAdd;

  @override
  _QuizzesScreenState createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  late QuizService _quizService;
  Map<String, dynamic> _initialValue = {};
  bool _isLoading = true;
  List<Quiz> _quizzes = [];

  String _searchQuery = '';

  int _currentPage = 1;
  int _itemsPerPage = 5;
  int _totalRecords = 0;

  @override
  void initState() {
    super.initState();
    _quizService = context.read<QuizService>();
    _initialValue = {
      'id': widget.quiz?.id.toString(),
      'title': widget.quiz?.title,
      'description': widget.quiz?.description,
    };

    _loadPagedQuizzes();
  }

  Future<void> _loadPagedQuizzes() async {
    try {
      final models = await _quizService.getPaged(
        filter: {
          'title': _searchQuery,
          'pageNumber': _currentPage,
          'pageSize': _itemsPerPage,
        },
      );

      setState(() {
        _quizzes = models.items;
        _totalRecords = models.totalCount;
        _isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  void _deleteVehicleModel(int index) {
    final vehicleModel = _quizzes[index];
    final id = vehicleModel.id ?? 0;

    _showDeleteConfirmationDialog(() async {
      try {
        await _quizService.remove(id);

        setState(() {
          _quizzes.removeAt(index);
        });
      } catch (error) {
        print('Error deleting vehicle model: $error');
      }
    });
  }

  Future<void> _showDeleteConfirmationDialog(Function onDeleteConfirmed) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Quiz'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this quiz?'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF1D1C1E),
                onPrimary: Colors.white,
              ),
              onPressed: () {
                onDeleteConfirmed();
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _onEdit(Quiz quiz) async {
    widget.onEdit(quiz);
  }

  void _onAdd() async {
    widget.onAdd();
  }

  void _handlePageChange(int newPage) {
    setState(() {
      _currentPage = newPage;
    });

    _loadPagedQuizzes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quizzes',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                    Text(
                      'A summary of the Quizzes.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _onAdd();
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('New Quiz'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF1D1C1E),
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 1,
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
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                          _loadPagedQuizzes();
                        },
                        decoration: InputDecoration(
                          labelText: 'Search',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Color(0xFF49464E),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
              ],
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFE0D8E0),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Table(
                border: TableBorder.all(
                  color: Colors.transparent,
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F1FB),
                    ),
                    children: [
                      TableCellWidget(text: 'Title'),
                      TableCellWidget(text: 'Description'),
                      TableCellWidget(text: 'Actions'),
                    ],
                  ),
                  if (_isLoading)
                    TableRow(
                      children: [
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                      ],
                    )
                  else
                    ..._quizzes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final quiz = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        children: [
                          TableCellWidget(text: quiz.title ?? ''),
                          TableCellWidget(text: quiz.description ?? ''),
                          TableCell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _onEdit(quiz);
                                    print(quiz.toJson());
                                  },
                                  icon: Icon(Icons.edit,
                                      color: Color(0xFF1D1C1E)),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _deleteVehicleModel(index);
                                  },
                                  icon: Icon(Icons.delete,
                                      color: Color(0xFF1D1C1E)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PagingComponent(
        currentPage: _currentPage,
        itemsPerPage: _itemsPerPage,
        totalRecords: _totalRecords,
        onPageChange: _handlePageChange,
      ),
    );
  }
}
