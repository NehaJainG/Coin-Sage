import 'package:flutter/material.dart';

import 'package:coin_sage/defaults/defaults.dart';
import 'package:coin_sage/defaults/colors.dart';

class TransactionStatistics extends StatefulWidget {
  const TransactionStatistics({super.key});

  @override
  State<TransactionStatistics> createState() => _TransactionStatisticsState();
}

class _TransactionStatisticsState extends State<TransactionStatistics> {
  ColorProvider colors = ColorProvider();
  Map<String, double> data = {
    'Income': 4000,
    'Spending': 2000,
  };

  List<Color>? colorPalette;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              colors.widgetColors['bg']!.withOpacity(0.9),
              colors.widgetColors['bg']!.withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance: ₹ 9000',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          btwVertical,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: data.entries.map((dataItem) {
              return Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(10),
                width: 160,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: colors.widgetColors['text']!,
                    width: 1,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      herodarkBlue.withOpacity(0.4),
                      herodarkBlue.withOpacity(0.2),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataItem.key,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            color: colors.widgetColors['text'],
                          ),
                    ),
                    Text(
                      '₹ ${dataItem.value}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 22,
                            color: dataItem.key == 'Income' ? green : red,
                          ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  const ChartData({required this.category, required this.amount});

  final String category;
  final double amount;

  String get x => category;
  double get y => amount;
  String get label => x;
}
