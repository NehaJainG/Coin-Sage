import 'package:coin_sage/defaults/colors.dart';
import 'package:flutter/material.dart';

import 'package:coin_sage/models/transaction.dart';
import 'package:coin_sage/defaults/defaults.dart';
import 'package:coin_sage/widgets/transaction/transaction_item.dart';

class TransactionList extends StatelessWidget {
  TransactionList({
    super.key,
    required this.userTransactions,
    required this.additionalContent,
    required this.isDrawerOpen,
  });

  final List<Transaction> userTransactions;
  final Widget? additionalContent;

  final bool isDrawerOpen;

  static ColorProvider colors = ColorProvider();

  @override
  Widget build(BuildContext context) {
    Widget transactionList = SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
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

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
        boxShadow: [
          BoxShadow(
            color: black,
            blurRadius: 25,
          ),
        ],
      ),
      child: CustomScrollView(
        slivers: [
          //above content
          SliverToBoxAdapter(
            child: Container(
              child: additionalContent ?? const SizedBox(),
            ),
          ),

          // app bar for the transaction list
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              child: userTransactions.isEmpty
                  ? const SizedBox()
                  : Container(
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
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
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

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: transactionList,
          ),
        ],
      ),
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
