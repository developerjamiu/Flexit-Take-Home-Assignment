import 'package:flutter/material.dart';

import '../features/users/views/user_details_view.dart';
import '../features/users/views/users_view.dart';

class Routes {
  static const users = '/';
  static const userDetails = '/user-details';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case users:
        return MaterialPageRoute(builder: (_) => const UsersView());
      case userDetails:
        final userId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => UserDetailsView(userId: userId),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
