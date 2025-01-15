import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshablePage extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  RefreshablePage({required this.child, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final RefreshController _refreshController = RefreshController(initialRefresh: false);

    return SmartRefresher(
      controller: _refreshController,
      onRefresh: () async {
        await onRefresh();
        _refreshController.refreshCompleted();
        refreshPage(context);
      },
      child: child,
    );
  }
}

void refreshPage(BuildContext context) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => context.widget,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
  );
}