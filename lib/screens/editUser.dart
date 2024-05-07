import 'package:flutter/material.dart';

import '../model/user.dart';
import '../service/user_service.dart';

class EditUser extends StatefulWidget {
  final User user;
  const EditUser({super.key, required this.user});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _validateName = false;
  bool _validateAmount = false;
  final _userService = UserService();

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void initState() {
    setState(() {
      _nameController.text = widget.user.name ?? "";
      _amountController.text = widget.user.money?.toString() ?? "";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite'),
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40, left: 24.0, right: 24),
            child: Column(
              children: [
                SizedBox(
                  height: 400,
                  width: 400,
                  child: Card(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 70.0, left: 24, right: 24),
                      child: Column(
                        children: [
                          const Text('Edit user'),
                          const SizedBox(
                            height: 40,
                          ),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'Enter name',
                              labelText: 'Name',
                              errorText:
                                  _validateName ? 'Name Can\'t Be Empty' : null,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _amountController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'Enter amount',
                              labelText: 'Amount',
                              errorText: _validateAmount
                                  ? 'Amount Can\'t Be Empty'
                                  : null,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.purpleAccent,
                                  textStyle: const TextStyle(
                                    fontSize: 17,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    _nameController.text.isEmpty
                                        ? _validateName = true
                                        : _validateName = false;
                                    _amountController.text.isEmpty
                                        ? _validateAmount = true
                                        : _validateAmount = false;
                                  });
                                  if (_validateName == false &&
                                      _validateAmount == false) {
                                    // print("Data can be saved");
                                    var user = User();
                                    user.id = widget.user.id;
                                    user.name = _nameController.text;
                                    user.money =
                                        double.parse(_amountController.text);
                                    var result =
                                        await _userService.updateUser(user);
                                    _showSuccessSnackBar(
                                        'User Detail Updated Successfully');
                                    Navigator.pop(context, result);
                                  }
                                },
                                child: const Text('Update User'),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red,
                                  textStyle: const TextStyle(
                                    fontSize: 17,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _amountController.clear();
                                  _nameController.clear();
                                },
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
