import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/utilities/base_change_notifier.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/base/failure.dart';
import '../models/user_detail.dart';

class UserDetailsNotitier extends BaseChangeNotifier {
  UserDetailsNotitier(this._read, {required this.userId}) {
    getUserDetails();
  }

  final Reader _read;

  final String userId;

  late UserDetail _userDetails;
  UserDetail get userDetails => _userDetails;

  Future<void> getUserDetails() async {
    try {
      setState(state: AppState.loading);

      _userDetails = await _read(usersRepository).getUser(userId);

      setState(state: AppState.idle);
    } on Failure {
      setState(state: AppState.error);
    }
  }
}

final userDetailsNotifierProvider =
    ChangeNotifierProvider.autoDispose.family<UserDetailsNotitier, String>(
  (ref, userId) => UserDetailsNotitier(ref.read, userId: userId),
);
