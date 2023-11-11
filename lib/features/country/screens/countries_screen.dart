import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_track_admin/features/country/models/country.dart';
import 'package:trash_track_admin/features/country/services/countries_service.dart';
import 'package:trash_track_admin/features/country/widgets/table_cell.dart';
import 'package:trash_track_admin/features/country/widgets/paging_component.dart';

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({Key? key, this.country, required this.onAdd, required this.onEdit})
      : super(key: key);

  final Country? country;
  final Function() onAdd;
  final Function(Country) onEdit;

  @override
  _CountriesScreenState createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  late CountriesService _countryService;
  Map<String, dynamic> _initialValue = {};
  bool _isLoading = true;
  List<Country> _countries = [];

  String _searchQuery = '';
  String _activityStatus = '';

  int _currentPage = 1;
  int _itemsPerPage = 5;
  int _totalRecords = 0;

  @override
  void initState() {
    super.initState();
    _countryService = context.read<CountriesService>();
    _initialValue = {
      'id': widget.country?.id.toString(),
      'name': widget.country?.name,
      'abbreviation': widget.country?.abbreviation,
      'isActive': widget.country?.isActive.toString(),
    };

    _loadCountries();
  }

  Future<void> _loadCountries() async {
    try {
      final countries = await _countryService.getPaged(
        filter: {
          'name': _searchQuery,
          'isActive': _activityStatus,
          'pageNumber': _currentPage, // Add page number
          'pageSize': _itemsPerPage, // Add page size
        },
      );

      setState(() {
        _countries = countries.items;
        _totalRecords = countries.totalCount;
        _isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  void _deleteCountry(int index) {
    final country = _countries[index];
    final id = country.id ?? 0;

    _showDeleteConfirmationDialog(() async {
      try {
        await _countryService.remove(id);

        setState(() {
          _countries.removeAt(index);
        });

        _loadCountries();
      } catch (error) {
        print('Error deleting country: $error');
      }
    });
  }

  Future<void> _showDeleteConfirmationDialog(Function onDeleteConfirmed) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Country'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this country?'),
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

  void _onEdit(Country country) async {
    widget.onEdit(country);
  }

  void _openAddScreen() {
    widget.onAdd();
  }

  void _handlePageChange(int newPage) {
    setState(() {
      _currentPage = newPage;
    });

    _loadCountries();
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
                      'Countries',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                    Text(
                      'A summary of the Countries.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _openAddScreen,
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('New Country'),
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
                          _loadCountries();
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
                        child: DropdownButtonFormField<String>(
                          value: _activityStatus,
                          onChanged: (newValue) {
                            setState(() {
                              _activityStatus = newValue ?? '';
                            });
                            _loadCountries();
                          },
                          items: [
                            DropdownMenuItem<String>(
                              value: '', // Add the empty string value
                              child: Text('Choose Activity Status'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'true',
                              child: Text('Active'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'false',
                              child: Text('Inactive'),
                            ),
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
                      TableCellWidget(text: 'Name'),
                      TableCellWidget(text: 'Abbreviation'),
                      TableCellWidget(text: 'Active'),
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
                      ],
                    )
                  else
                    ..._countries.asMap().entries.map((entry) {
                      final index = entry.key;
                      final country = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        children: [
                          TableCellWidget(text: country.name ?? ''),
                          TableCellWidget(text: country.abbreviation ?? ''),
                          TableCellWidget(
                            text: country.isActive != null
                                ? country.isActive!
                                    ? 'Yes'
                                    : 'No'
                                : 'Unknown',
                          ),
                          TableCell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _onEdit(country);
                                  },
                                  icon: Icon(Icons.edit,
                                      color: Color(0xFF1D1C1E)),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _deleteCountry(index);
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

      // Place the PagingComponent here at the bottom of the page
      bottomNavigationBar: PagingComponent(
        currentPage: _currentPage,
        itemsPerPage: _itemsPerPage,
        totalRecords: _totalRecords,
        onPageChange: _handlePageChange,
      ),
    );
  }
}
