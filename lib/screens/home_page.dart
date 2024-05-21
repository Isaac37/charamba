import 'package:charamba/screens/viewUser.dart';
import 'package:flutter/material.dart';

import '../model/user.dart';
import '../service/user_service.dart';
import 'addUser.dart';
import 'editUser.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<User> _userList = [];
  late List<User> _filteredUserList = [];
  final _userService = UserService();
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    getAllUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> getAllUsers() async {
    var users = await _userService.readAllUsers();
    setState(() {
      _userList = <User>[];
    });

    users.forEach((user) {
      var userModel = User();
      userModel.id = user['id'];
      userModel.name = user['name'];
      userModel.money = user['amount'].toDouble();
      _userList.add(userModel);
    });

    setState(() {
      _filteredUserList = List.from(_userList);
    });
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _searchByName(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUserList = List.from(_userList);
      } else {
        _filteredUserList = _userList.where((user) {
          final userName = user.name?.toLowerCase();
          final searchLower = query.toLowerCase();
          return userName!.contains(searchLower);
        }).toList();
      }
    });
  }

  Future<void> _deleteUser(BuildContext context, userId) async {
    showDialog(
      context: context,
      builder: (param) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                var result = await _userService.deleteUser(userId);
                if (result != null) {
                  Navigator.of(context).pop();
                  await getAllUsers();
                  _showSuccessSnackBar('User Deleted Successfully');
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Change dzevanhu')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddUser()),
          );
          getAllUsers();
          _showSuccessSnackBar('User Detail Added Successfully');
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bac.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: 700,
            width: 700,
            child: Card(
              margin: const EdgeInsets.all(50.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 10, right: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _searchByName,
                        decoration: const InputDecoration(
                          labelText: 'Search by name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _filteredUserList.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/bac.png"),
                                  const Text('No users found.'),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: _filteredUserList.length,
                              itemBuilder: (context, index) {
                                final user = _filteredUserList[index];
                                return Card(
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ViewUser(user: user),
                                        ),
                                      );
                                    },
                                    leading: const Icon(Icons.person),
                                    title: Text(user.name ?? ""),
                                    subtitle: Text(
                                        user.money?.toStringAsFixed(2) ?? ""),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditUser(user: user),
                                              ),
                                            );

                                            await getAllUsers();
                                          },
                                          icon: const Icon(Icons.edit_outlined),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _deleteUser(context, user.id);
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
