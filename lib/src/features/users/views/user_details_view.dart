import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../core/utilities/base_change_notifier.dart';
import '../../../widget/spacing.dart';
import '../models/user_detail.dart';
import '../notifiers/user_details_notifier.dart';

class UserDetailsView extends HookWidget {
  const UserDetailsView({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context) {
    final userDetailsNotifier =
        useProvider(userDetailsNotifierProvider(userId));
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        iconTheme: const IconThemeData(color: AppColors.dark),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: () {
        if (userDetailsNotifier.state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (userDetailsNotifier.state.isError) {
          return _UsersErrorView(userId: userId);
        } else {
          return _UserDetailsView(
            userDetails: userDetailsNotifier.userDetails,
          );
        }
      }(),
    );
  }
}

class _UserDetailsView extends StatelessWidget {
  const _UserDetailsView({Key? key, required this.userDetails})
      : super(key: key);

  final UserDetail userDetails;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Card(
              elevation: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacing.height(64),
                  Text(
                    '${userDetails.firstName} ${userDetails.lastName}',
                    style: textTheme.headline6,
                  ),
                  const Spacing.mediumHeight(),
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text(userDetails.gender),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: Text(userDetails.email),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone_outlined),
                    title: Text(userDetails.firstName),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_city_outlined),
                    title: Text(userDetails.location.streetAddress),
                  ),
                  const ListTile(
                    leading: Icon(Icons.cake),
                    title: Text('30,20,2020'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: -44,
            child: CircleAvatar(
              radius: 48,
              child: ClipOval(
                child: Image.network(
                  userDetails.picture,
                  fit: BoxFit.cover,
                  width: 96,
                  height: 96,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UsersErrorView extends StatelessWidget {
  const _UsersErrorView({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.errorUser,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const Spacing.bigHeight(),
          ElevatedButton(
            onPressed: () => context
                .refresh(userDetailsNotifierProvider(userId))
                .getUserDetails(),
            child: const Text(AppStrings.retry),
          ),
        ],
      ),
    );
  }
}
