import 'package:coin_sage/defaults/colors.dart';
import 'package:flutter/material.dart';

import 'package:coin_sage/models/transaction.dart';
import 'package:coin_sage/defaults/defaults.dart';
import 'package:coin_sage/widgets/transaction_item.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionList extends ConsumerWidget {
  const TransactionList({
    super.key,
    required this.userTransactions,
    required this.additionalContent,
  });

  final List<Transaction> userTransactions;
  final Widget? additionalContent;

  static ColorProvider colors = ColorProvider();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget transactionList = SliverToBoxAdapter(
      child: Center(
        child: Text(
          'No transactions found:)',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
    if (userTransactions.isNotEmpty) {
      transactionList = SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Display 2 items in a row
          crossAxisSpacing: 10,
          mainAxisExtent: 140,
          childAspectRatio: 6 / 4,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return TransactionItem(
              transaction: userTransactions[index],
              index: index,
            );
          },
          childCount: userTransactions.length,
        ),
      );
    }
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(50),
              ),
              boxShadow: [
                BoxShadow(
                  color: lightGrey.withOpacity(0.7),
                  blurRadius: 3,
                )
              ],
              color: blackBlue,
            ),
            child: additionalContent ?? const SizedBox(),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          //floating: true,
          delegate: _SliverAppBarDelegate(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: dePadding,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 27,
                    color: Color.fromARGB(222, 255, 255, 255),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Recent Transactions',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
            minHeight: 60.0,
            maxHeight: 60.0,
          ),
        ),
        transactionList,
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  const _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
