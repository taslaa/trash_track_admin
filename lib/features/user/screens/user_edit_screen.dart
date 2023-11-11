import 'package:flutter/material.dart';
import 'package:trash_track_admin/features/country/models/country.dart';
import 'package:trash_track_admin/features/country/services/countries_service.dart';
import 'package:trash_track_admin/features/user/models/user.dart';
import 'package:trash_track_admin/features/user/services/users_service.dart';

class UserEditScreen extends StatefulWidget {
  final UserEntity user;
  final Function(String) onUpdateRoute;

  UserEditScreen({required this.user, required this.onUpdateRoute});

  @override
  _UserEditScreenState createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  late TextEditingController _isActiveController;
  late TextEditingController _isVerifiedController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late UserService _userService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userService = UserService();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _isActiveController =
        TextEditingController(text: widget.user.isActive.toString());
    _isVerifiedController =
        TextEditingController(text: widget.user.isVerified.toString());
  }

  @override
  void dispose() {
    _isVerifiedController.dispose();
    _isActiveController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _goBack() {
    widget.onUpdateRoute('users');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
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
                'Edit User',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
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
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Color(0xFF49464E),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Color(0xFF49464E),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                      child: DropdownButtonFormField<String>(
                        value: _isActiveController.text,
                        onChanged: (isActive) {
                          setState(() {
                            _isActiveController.text = isActive ?? 'true';
                          });
                        },
                        items: [
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
                          labelText: 'Active',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                      child: DropdownButtonFormField<String>(
                        value: _isActiveController.text,
                        onChanged: (isVerified) {
                          setState(() {
                            _isVerifiedController.text = isVerified ?? 'true';
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'true',
                            child: Text('Verified'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'false',
                            child: Text('Unverified'),
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Verified',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 400,
                child: ElevatedButton(
                  onPressed: () async {
                    final editedUser = UserEntity(
                      id: widget.user.id,
                      isActive: _isActiveController.text == 'true',
                      isVerified: _isVerifiedController.text == 'true',
                    );

                    // Update the country using your service
                    try {
                      await _userService.updateUser(editedUser);

                      widget.onUpdateRoute('users');
                    } catch (error) {
                      print('Error saving user: $error');
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 8),
                      const Text('Save'),
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
      ),
    );
  }
}
