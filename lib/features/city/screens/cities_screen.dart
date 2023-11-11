import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/city/models/city.dart';
import 'package:trash_track_admin/features/city/services/cities_service.dart';
import 'package:trash_track_admin/features/city/widgets/table_cell.dart';
import 'package:trash_track_admin/features/country/models/country.dart';
import 'package:trash_track_admin/features/country/services/countries_service.dart';
import 'package:trash_track_admin/shared/widgets/paging_component.dart';

class CitiesScreen extends StatefulWidget {
  const CitiesScreen({
    Key? key,
    this.city,
    required this.onEdit,
    required this.onAdd,
  }) : super(key: key);

  final City? city;
  final Function(City) onEdit;
  final Function() onAdd;

  @override
  _CitiesScreenState createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  late CitiesService _citiesService;
  late CountriesService _countriesService;
  bool _isLoading = true;
  List<City> _cities = [];
  List<Country> _countries = [];
  int _currentPage = 1;
  int _itemsPerPage = 5;
  int _totalRecords = 0;
  String _cityName = '';
  String? _selectedCountryId;

  @override
  void initState() {
    super.initState();
    _citiesService = CitiesService();
    _countriesService = CountriesService();
    _selectedCountryId = '';
    _loadCities();
    _loadCountries();
  }

  Future<void> _loadCities() async {
    try {
      final cities = await _citiesService.getPaged(
        filter: {
          'countryId': _selectedCountryId,
          'name': _cityName,
          'pageNumber': _currentPage,
          'pageSize': _itemsPerPage,
        },
      );

      setState(() {
        _cities = cities.items;
        _totalRecords = cities.totalCount;
        _isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _loadCountries() async {
    try {
      final countries = await _countriesService.getPaged();
      setState(() {
        _countries = countries.items;
      });
    } catch (error) {
      print('Error loading countries: $error');
    }
  }

  void _deleteCity(int index) {
    final city = _cities[index];
    final id = city.id ?? 0;

    _showDeleteConfirmationDialog(() async {
      try {
        await _citiesService.remove(id);

        setState(() {
          _cities.removeAt(index);
        });
      } catch (error) {
        print('Error deleting city: $error');
      }
    });
  }

  Future<void> _showDeleteConfirmationDialog(Function onDeleteConfirmed) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete City'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this city?'),
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
                  primary: Colors.white,
                  onPrimary: Color(0xFF1D1C1E),
                  shadowColor: Colors.white),
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

  void _onEdit(City city) async {
    widget.onEdit(city);
  }

  void _onAdd() async {
    widget.onAdd();
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
                      'Cities',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                    Text(
                      'A summary of the Cities.',
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
                  label: Text('New City'),
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
                            _cityName = value;
                          });
                          _loadCities();
                        },
                        decoration: InputDecoration(
                          labelText: 'Search by Name',
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
                      child: DropdownButtonFormField<String>(
                        value: _selectedCountryId,
                        onChanged: (countryId) {
                          setState(() {
                            _selectedCountryId = countryId;
                          });
                          _loadCities();
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: '',
                            child: Text('Choose a country'),
                          ),
                          ..._countries.map((country) {
                            return DropdownMenuItem<String>(
                              value: country.id.toString(),
                              child: Text(country.name ?? ''),
                            );
                          }).toList(),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Filter by Country',
                          border: InputBorder.none,
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
                      TableCellWidget(text: 'Zip Code'),
                      TableCellWidget(text: 'Active'),
                      TableCellWidget(text: 'Country'),
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
                      ],
                    )
                  else
                    ..._cities.asMap().entries.map((entry) {
                      final index = entry.key;
                      final city = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        children: [
                          TableCellWidget(text: city.name ?? ''),
                          TableCellWidget(text: city.zipCode ?? ''),
                          TableCellWidget(
                            text: city.isActive != null
                                ? city.isActive!
                                    ? 'Yes'
                                    : 'No'
                                : '',
                          ),
                          TableCellWidget(
                            text: city.country?.name ?? '',
                          ),
                          TableCell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _onEdit(city);
                                  },
                                  icon: Icon(Icons.edit,
                                      color: Color(0xFF1D1C1E)),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _deleteCity(index);
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
        onPageChange: (newPage) {
          setState(() {
            _currentPage = newPage;
          });
          _loadCities();
        },
      ),
    );
  }
}
