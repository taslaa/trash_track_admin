import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_track_admin/features/reports/models/report.dart';
import 'package:trash_track_admin/features/reports/services/reports_service.dart';
import 'package:trash_track_admin/features/user/models/user.dart';
import 'package:trash_track_admin/features/user/services/users_service.dart';
import 'package:trash_track_admin/features/vehicle-model/widgets/table_cell.dart';
import 'package:trash_track_admin/features/vehicle-model/widgets/paging_component.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({
    Key? key,
    this.user,
    required this.onEdit,
  }) : super(key: key);
  final UserEntity? user;
  final Function(UserEntity) onEdit;

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late UserService _modelProvider;
  Map<String, dynamic> _initialValue = {};
  bool _isLoading = true;
  List<UserEntity> _users = [];

  Role? _selectedRole;
  String _query = '';

  int _currentPage = 1;
  int _itemsPerPage = 5;
  int _totalRecords = 0;

  @override
  void initState() {
    super.initState();
    _modelProvider = context.read<UserService>();
    _initialValue = {
      'id': widget.user?.id.toString(),
      'firstName': widget.user?.firstName,
      'lastName': widget.user?.lastName,
      'email': widget.user?.email,
      'phoneNumber': widget.user?.phoneNumber,
      'biography': widget.user?.biography,
      'birthDate': widget.user?.birthDate,
      'gender': widget.user?.gender,
      'countryId': widget.user?.countryId,
      'country': widget.user?.country,
      'role': widget.user?.role,
      'profilePhoto': widget.user?.profilePhoto,
      'isActive': widget.user?.isActive,
      'isVerified': widget.user?.isVerified
    };

    _loadPagedUsers();
  }


  String mapRoleToString(Role? role) {
    switch (role) {
      case Role.administrator:
        return 'Administrator';
      case Role.user:
        return 'User';
      case Role.driver:
        return 'Driver';
      default:
        return '';
    }
  }

  Future<void> _loadPagedUsers() async {
    try {
      final models = await _modelProvider.getPaged(
        filter: {
          'query': _query,
          'role': mapRoleToString(_selectedRole),
          'pageNumber': _currentPage,
          'pageSize': _itemsPerPage,
        },
      );

      setState(() {
        _users = models.items;
        _totalRecords = models.totalCount;
        _isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  String getRoleString(Role? role) {
    if (role == null) {
      return 'Unknown';
    }
    switch (role) {
      case Role.administrator:
        return 'Administrator';
      case Role.user:
        return 'User';
      case Role.driver:
        return 'Driver';
      default:
        return 'Unknown';
    }
  }

  String getGenderString(Gender? gender) {
    if (gender == null) {
      return 'Unknown';
    }
    switch (gender) {
      case Gender.female:
        return 'Female';
      case Gender.male:
        return 'Male';
      default:
        return 'Unknown';
    }
  }

  void _deleteUser(int index) {
    final user = _users[index];
    final id = user.id ?? 0;

    _showDeleteConfirmationDialog(() async {
      try {
        await _modelProvider.remove(id);

        setState(() {
          _users.removeAt(index);
        });
      } catch (error) {
        print('Error deleting user : $error');
      }
    });
  }

  Future<void> _showDeleteConfirmationDialog(Function onDeleteConfirmed) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this user?'),
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

  void _onEdit(UserEntity user) async {
    widget.onEdit(user);
  }

  void _handlePageChange(int newPage) {
    setState(() {
      _currentPage = newPage;
    });

    _loadPagedUsers();
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
                      'Users',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                    Text(
                      'A summary of the Users.',
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
                            _query = value;
                          });
                          _loadPagedUsers();
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
                        child: DropdownButtonFormField<Role>(
                          value: _selectedRole,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedRole = newValue;
                            });
                            _loadPagedUsers();
                          },
                          items: [
                            DropdownMenuItem<Role>(
                              value: null,
                              child: Text('Choose the role'),
                            ),
                            ...Role.values.map((type) {
                              return DropdownMenuItem<Role>(
                                value: type,
                                child: Text(getRoleString(type)),
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
                      TableCellWidget(text: 'First Name'),
                      TableCellWidget(text: 'Last Name'),
                      TableCellWidget(text: 'Email'),
                      TableCellWidget(text: 'Phone Number'),
                      TableCellWidget(text: 'Gender'),
                      TableCellWidget(text: 'Role'),
                      TableCellWidget(text: 'Active'),
                      TableCellWidget(text: 'Verified'),
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
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                      ],
                    )
                  else
                    ..._users.asMap().entries.map((entry) {
                      final index = entry.key;
                      final user = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        children: [
                          TableCellWidget(text: user.firstName ?? ''),
                          TableCellWidget(text: user.lastName ?? ''),
                          TableCellWidget(text: user.email ?? ''),
                          TableCellWidget(text: user.phoneNumber ?? ''),
                          TableCellWidget(
                              text: getGenderString(user.gender)),
                          TableCellWidget(
                              text: getRoleString(user.role)),
                          TableCellWidget(
                            text: user.isActive != null
                                ? user.isActive!
                                    ? 'Yes'
                                    : 'No'
                                : '',
                          ),
                           TableCellWidget(
                            text: user.isVerified != null
                                ? user.isVerified!
                                    ? 'Yes'
                                    : 'No'
                                : '',
                          ),
                          TableCell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _onEdit(user);
                                  },
                                  icon: Icon(Icons.edit,
                                      color: Color(0xFF1D1C1E)),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _deleteUser(index);
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
