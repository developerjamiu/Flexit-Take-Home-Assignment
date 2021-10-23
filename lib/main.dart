import 'package:flexit/src/core/constants/strings.dart';
import 'package:flexit/src/core/utilities/navigation_util.dart';
import 'package:flexit/src/core/utilities/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'src/core/routes.dart';
import 'src/core/theme.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: Routes.users,
      onGenerateRoute: Routes.generateRoute,
      navigatorKey: context.read(navigationUtil).navigatorKey,
      scaffoldMessengerKey: context.read(snackbarUtil).scaffoldMessengerKey,
    );
  }
}
