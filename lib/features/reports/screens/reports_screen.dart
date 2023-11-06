import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_track_admin/features/reports/models/report.dart';
import 'package:trash_track_admin/features/reports/services/reports_service.dart';
import 'package:trash_track_admin/features/vehicle-model/widgets/table_cell.dart';
import 'package:trash_track_admin/features/vehicle-model/widgets/paging_component.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({
    Key? key,
    this.report,
    required this.onEdit,
  }) : super(key: key);
  final Report? report;
  final Function(Report) onEdit;

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late ReportsService _modelProvider;
  Map<String, dynamic> _initialValue = {};
  bool _isLoading = true;
  List<Report> _reports = [];

  ReportState? _selectedReportState;
  String _note = '';

  int _currentPage = 1;
  int _itemsPerPage = 3;
  int _totalRecords = 0;

  @override
  void initState() {
    super.initState();
    _modelProvider = context.read<ReportsService>();
    _initialValue = {
      'id': widget.report?.id.toString(),
      'note': widget.report?.note,
      'reportState': widget.report?.reportState.toString(),
      'reportType': widget.report?.reportType.toString(),
      'reporterUserId': widget.report?.reporterUserId,
      'reporterUser': widget.report?.reporterUser,
      'photo': widget.report?.photo,
      'garbageId': widget.report?.garbageId,
      'garbage': widget.report?.garbage
    };

    _loadPagedReports();
  }


  String mapReportStateToString(ReportState? reportState) {
    switch (reportState) {
      case ReportState.reviewed:
        return 'Reviewed';
      case ReportState.waitingForReview:
        return 'Waiting For Review';
      default:
        return '';
    }
  }

  Future<void> _loadPagedReports() async {
    try {
      final models = await _modelProvider.getPaged(
        filter: {
          'note': _note,
          'reportState': mapReportStateToString(_selectedReportState),
          'pageNumber': _currentPage,
          'pageSize': _itemsPerPage,
        },
      );

      setState(() {
        _reports = models.items;
        _totalRecords = models.totalCount;
        _isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  String getReportStateString(ReportState? reportState) {
    if (reportState == null) {
      return 'Unknown';
    }
    switch (reportState) {
      case ReportState.reviewed:
        return 'Reviewed';
      case ReportState.waitingForReview:
        return 'Waiting For Review';
      default:
        return 'Unknown';
    }
  }

  String getReportTypeString(ReportType? reportType) {
    if (reportType == null) {
      return 'Unknown';
    }
    switch (reportType) {
      case ReportType.garbageBinDamage:
        return 'Garbage Bin Damage';
      case ReportType.graffitiVandalism:
        return 'Graffiti Vandalism';
      case ReportType.littering:
        return 'Littering';
      case ReportType.trashOverflow:
        return 'Trash Overflow';
      default:
        return 'Unknown';
    }
  }

  void _deleteReport(int index) {
    final report = _reports[index];
    final id = report.id ?? 0;

    _showDeleteConfirmationDialog(() async {
      try {
        await _modelProvider.remove(id);

        setState(() {
          _reports.removeAt(index);
        });
      } catch (error) {
        print('Error deleting report : $error');
      }
    });
  }

  Future<void> _showDeleteConfirmationDialog(Function onDeleteConfirmed) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Report'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this report?'),
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

  void _onEdit(Report report) async {
    widget.onEdit(report);
  }

  void _handlePageChange(int newPage) {
    setState(() {
      _currentPage = newPage;
    });

    _loadPagedReports();
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
                      'Reports',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                    Text(
                      'A summary of the Reports.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                  ],
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
                            _note = value;
                          });
                          _loadPagedReports();
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
                      child: Container(
                        alignment: Alignment.center,
                        child: DropdownButtonFormField<ReportState>(
                          value: _selectedReportState,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedReportState = newValue;
                            });
                            _loadPagedReports();
                          },
                          items: [
                            DropdownMenuItem<ReportState>(
                              value: null,
                              child: Text('Choose the report state'),
                            ),
                            ...ReportState.values.map((type) {
                              return DropdownMenuItem<ReportState>(
                                value: type,
                                child: Text(getReportStateString(type)),
                              );
                            }).toList(),
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: Color(0xFF49464E),
                          ),
                          icon: Container(
                            alignment: Alignment.center,
                            child: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
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
                      TableCellWidget(text: 'Note'),
                      TableCellWidget(text: 'Report State'),
                      TableCellWidget(text: 'Report Type'),
                      TableCellWidget(text: 'Reporter User'),
                      TableCellWidget(text: 'Garbage'),
                      TableCellWidget(text: 'Actions'),
                    ],
                  ),
                  if (_isLoading)
                    TableRow(
                      children: [
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                      ],
                    )
                  else
                    ..._reports.asMap().entries.map((entry) {
                      final index = entry.key;
                      final report = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        children: [
                          TableCellWidget(text: report.note ?? ''),
                          TableCellWidget(
                              text: getReportStateString(report.reportState)),
                          TableCellWidget(
                              text: getReportTypeString(report.reportType)),
                          TableCellWidget(text: report.reporterUser!.firstName ?? ''),
                          TableCellWidget(text: report.garbage!.address ?? ''),
                          TableCell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _onEdit(report);
                                  },
                                  icon: Icon(Icons.edit,
                                      color: Color(0xFF1D1C1E)),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _deleteReport(index);
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
