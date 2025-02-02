// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/controllers/case.dart';
import 'package:coc/service/data.dart';

class CaseListItem extends StatelessWidget {
  final Case caseItem;

  const CaseListItem({
    super.key,
    required this.caseItem,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme aTextTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(8),
        ),
        onPressed: () {
          di<DataService>().currentCase = caseItem;
          Navigator.pushNamed(context, "/case");
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  caseItem.title,
                  style: aTextTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
