import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/reports/models/report.dart';
import 'package:trash_track_admin/features/reports/services/reports_screen.dart';
import 'package:trash_track_admin/features/vehicle-model/models/vehicle_model.dart';
import 'package:trash_track_admin/features/vehicle-model/services/vehicle_models_service.dart';
import 'package:trash_track_admin/shared/services/enums_service.dart';

class ReportEditScreen extends StatefulWidget {
  final Report report;
  final Function(String) onUpdateRoute;

  ReportEditScreen({required this.report, required this.onUpdateRoute});

  @override
  _ReportEditScreenState createState() => _ReportEditScreenState();
}

class _ReportEditScreenState extends State<ReportEditScreen> {
  late EnumsService _enumsService;
  late int _selectedReportStateIndex;
  late Map<int, String> _reportStates;
  bool _isLoading = true;
  final reportService = ReportsService();

  @override
  void initState() {
    super.initState();
    _enumsService = EnumsService();
    _selectedReportStateIndex = widget.report.reportState!.index;
    _fetchReportStates();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchReportStates() async {
    try {
      final typesData = await _enumsService.getReportStates();

      if (typesData is Map<int, String>) {
        setState(() {
          _reportStates = typesData;
          _isLoading = false;
        });
      } else {
        print('Received unexpected data format for report states: $typesData');
      }
    } catch (error) {
      print('Error fetching report states: $error');
    }
  }

  void _goBack() {
    widget.onUpdateRoute('reports');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
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
              'Edit Vehicle Model',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : SizedBox(
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
                          child: DropdownButtonFormField<int>(
                            value: _selectedReportStateIndex,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedReportStateIndex = newValue ?? 0;
                              });
                            },
                            items: _reportStates.entries.map((entry) {
                              return DropdownMenuItem<int>(
                                value: entry.key,
                                child: Text(entry.value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Report States',
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: const Color(0xFF49464E),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 16),
            SizedBox(
              width: 400,
              child: ElevatedButton(
                onPressed: () async {
                  final selectedReportState =
                      ReportState.values[_selectedReportStateIndex];

                  final editedReport = Report(
                    id: widget.report.id,
                    reportState: selectedReportState,
                  );

                  try {
                    await reportService.update(editedReport);

                    widget.onUpdateRoute('reports');
                  } catch (error) {
                    print('Error saving report: $error');
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    const Text('Save Report'),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF49464E),
                  minimumSize: Size(400, 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
