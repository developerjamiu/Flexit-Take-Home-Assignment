import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/utilities/base_change_notifier.dart';
import '../../../core/utilities/snackbar_util.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/base/failure.dart';
import '../models/user.dart';

class UsersNotitier extends BaseChangeNotifier {
  UsersNotitier(this._read) {
    getUsers();
  }

  final Reader _read;

  late List<User> _users;
  List<User> get users => _users;

  int _currentPage = 1;
  final int _pageSize = 20;

  bool _moreDataAvailable = true;
  bool get moreDataAvailable => _moreDataAvailable;

  Future<void> getUsers() async {
    try {
      setState(state: AppState.loading);

      _currentPage = 1;

      _users = await _read(usersRepository).getUsers(page: _currentPage);
      if (_users.length < _pageSize) _moreDataAvailable = false;

      setState(state: AppState.idle);
    } on Failure catch (f) {
      _read(snackbarUtil).showErrorSnackBar(f.message);
      setState(state: AppState.error);
    }
  }

  Future<void> getMoreBooks() async {
    try {
      _currentPage++;

      final users = await _read(usersRepository).getUsers(page: _currentPage);

      if (users.isEmpty) {
        _moreDataAvailable = false;

        _read(snackbarUtil).showSuccessSnackBar(
          'You have reached the end of the book list',
        );
      }

      _users.addAll(users);

      setState(state: AppState.idle);
    } on Failure {
      setState(state: AppState.error);
    }
  }
}

final usersNotifierProvider = ChangeNotifierProvider(
  (ref) => UsersNotitier(ref.read),
);
