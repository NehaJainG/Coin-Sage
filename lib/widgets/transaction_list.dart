import 'package:flutter/material.dart';

import 'package:coin_sage/models/transaction.dart';
import 'package:coin_sage/assets/defaults.dart';
import 'package:coin_sage/widgets/transaction_item.dart';

class TransactionList extends StatelessWidget {
  const TransactionList(
      {super.key,
      required this.userTransactions,
      required this.additionalContent});
  final List<Transaction> userTransactions;
  final Widget? additionalContent;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: additionalContent ?? const SizedBox(),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: _SliverAppBarDelegate(
            child: Container(
              padding: dePadding,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 28, 27, 27),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              child: Text(
                'Recent Transactions...',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            minHeight: 50.0,
            maxHeight: 50.0,
          ),
        ),
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Display 2 items in a row
            crossAxisSpacing: 10,

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
        ),
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
