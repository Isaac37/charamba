import '../model/user.dart';
import '../repository/repo.dart';

class UserService {
  late Repository _repository;
  UserService() {
    _repository = Repository();
  }

  saveUser(User user) async {
    return await _repository.insertData("users", user.userMap());
  }

  readAllUsers() async {
    return await _repository.readData('users');
  }

  updateUser(User user) async {
    return await _repository.updateData('users', user.userMap());
  }

  deleteUser(userId) async {
    return await _repository.deleteDataById('users', userId);
  }
}
