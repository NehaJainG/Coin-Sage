import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:coin_sage/assets/defaults.dart';

class TransactionStatistics extends StatefulWidget {
  const TransactionStatistics({super.key});

  @override
  State<TransactionStatistics> createState() => _TransactionStatisticsState();
}

class _TransactionStatisticsState extends State<TransactionStatistics> {
  Map<String, double> data = {
    'Income': 4000,
    'Spending': 2000,
  };
  List<ChartData> chartData = [
    ChartData(category: 'Food', amount: 1000),
    ChartData(category: 'personal care', amount: 200),
    ChartData(category: 'vacation', amount: 1200),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              black.withOpacity(0.7),
              black.withOpacity(0.4),
            ],
          ),
          borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance: ₹9000',
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
                width: 165,
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      blue.withOpacity(0.5),
                      blue.withOpacity(0.25),
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
                            color: Colors.white70,
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
          Container(
            child: SfCircularChart(
              title: ChartTitle(text: 'Title'),
              series: <CircularSeries>[
                // Renders radial bar chart

                RadialBarSeries<ChartData, String>(
                    dataSource: chartData,
                    gap: '10%',
                    trackColor: Colors.white70,
                    //trackOpacity: 0.5,
                    opacity: 0.9,
                    //sortingOrder: SortingOrder.ascending,
                    cornerStyle: CornerStyle.bothCurve,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y),
              ],
              legend: Legend(
                isVisible: true,
                //padding: 2,
                itemPadding: 10,
              ),
            ),
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
}
