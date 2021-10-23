import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/constants/dimensions.dart';
import '../../../core/constants/strings.dart';
import '../../../core/routes.dart';
import '../../../core/utilities/base_change_notifier.dart';
import '../../../core/utilities/navigation_util.dart';
import '../../../widget/spacing.dart';
import '../../../widget/statusbar.dart';
import '../models/user.dart';
import '../notifiers/users_notifier.dart';

class UsersView extends HookWidget {
  const UsersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Statusbar(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 48,
                left: Dimensions.big,
                right: Dimensions.big,
              ),
              child: Text(
                AppStrings.usersHeading,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            const Spacing.mediumHeight(),
            Expanded(
              child: Consumer(
                builder: (context, watch, child) {
                  final usersNotifier = watch(usersNotifierProvider);

                  if (usersNotifier.state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (usersNotifier.state.isError) {
                    return const _UsersErrorView();
                  } else {
                    return _UsersList(
                      users: usersNotifier.users,
                      moreDataAvailable: usersNotifier.moreDataAvailable,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UsersList extends HookWidget {
  final List<User> users;
  final bool moreDataAvailable;

  const _UsersList({
    Key? key,
    required this.users,
    required this.moreDataAvailable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usersScrollController = useScrollController();

    useEffect(() {
      void scrollListener() {
        if (usersScrollController.position.pixels ==
            usersScrollController.position.maxScrollExtent) {
          context.read(usersNotifierProvider).getMoreBooks();
        }
      }

      usersScrollController.addListener(scrollListener);

      return () => usersScrollController.removeListener(scrollListener);
    }, [usersScrollController]);

    if (users.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: context.read(usersNotifierProvider).getUsers,
        child: ListView.builder(
          controller: usersScrollController,
          padding: const EdgeInsets.all(Dimensions.small),
          itemCount: users.length,
          itemBuilder: (context, index) {
            if (index == users.length - 1 && moreDataAvailable) {
              return const Center(child: CircularProgressIndicator());
            }

            return _UserListItem(user: users[index]);
          },
        ),
      );
    } else {
      return const _EmptyUsersView();
    }
  }
}

class _EmptyUsersView extends StatelessWidget {
  const _EmptyUsersView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.noUsers,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }
}

class _UserListItem extends StatelessWidget {
  final User user;

  const _UserListItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read(navigationUtil).navigateToNamed(
            Routes.userDetails,
            arguments: user.id,
          ),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(user.picture)),
        title: Text('${user.firstName} ${user.lastName}'),
      ),
    );
  }
}

class _UsersErrorView extends StatelessWidget {
  const _UsersErrorView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.errorUsers,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const Spacing.bigHeight(),
        ElevatedButton(
          onPressed: () => context.refresh(usersNotifierProvider).getUsers(),
          child: const Text(AppStrings.retry),
        ),
      ],
    );
  }
}
