import 'package:flutter/material.dart';

import 'package:coin_sage/defaults/colors.dart';
import 'package:coin_sage/defaults/defaults.dart';
import 'package:coin_sage/models/transaction.dart';
import 'package:coin_sage/presentation/transaction/transaction_item.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({
    super.key,
    required this.userTransactions,
    required this.additionalContent,
    required this.appBar,
    required this.isDrawerOpen,
  });

  final List<Transaction> userTransactions;
  final Widget? additionalContent;
  final Widget? appBar;

  final bool isDrawerOpen;
  static ColorProvider colors = ColorProvider();

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  late String month;

  late List<Transaction> monthWiseTransaction;

  void onChangeOfMonth() {
    monthWiseTransaction = widget.userTransactions
        .where((element) => months[element.date.month]! == month)
        .toList();
  }

  @override
  void initState() {
    month = months[DateTime.now().month]!;
    super.initState();
  }

  Future<String?> showMonthDialog() async {
    final selectedMonth = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Month'),
            children: <Widget>[
              for (String monthStr in months.values)
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.of(context).pop(monthStr);
                  },
                  child: Text(monthStr),
                ),
            ],
          );
        });
    return selectedMonth;
  }

  @override
  Widget build(BuildContext context) {
    onChangeOfMonth();
    Widget transactionList = SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        child: Text(
          'No transactions found!',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );

    if (monthWiseTransaction.isNotEmpty) {
      transactionList = SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, // Display 1 items in a row
          crossAxisSpacing: 10,
          mainAxisExtent: 100,
          childAspectRatio: 6 / 4,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return TransactionItem(
              transaction: monthWiseTransaction[index],
              index: index,
            );
          },
          childCount: monthWiseTransaction.length,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(widget.isDrawerOpen ? 20 : 0),
        boxShadow: [
          BoxShadow(
            color: black,
            blurRadius: 25,
          ),
        ],
      ),
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 100,
              maxHeight: 100,
              child: widget.appBar ?? const SizedBox(),
            ),
          ),
          //above content
          SliverToBoxAdapter(
            child: Container(
              child: widget.additionalContent ?? const SizedBox(),
            ),
          ),

          // app bar for the transaction list
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              child: widget.userTransactions.isEmpty
                  ? const SizedBox()
                  : Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(8),
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
                          const Spacer(),
                          TextButton(
                            onPressed: () async {
                              final m = await showMonthDialog();
                              setState(() {
                                month = m ?? month;
                              });
                            },
                            child: Row(
                              children: [
                                Text(month),
                                const Icon(Icons.arrow_drop_down_sharp)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
              minHeight: 60.0,
              maxHeight: 70.0,
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
