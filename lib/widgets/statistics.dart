import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:coin_sage/defaults/defaults.dart';

class TransactionStatistics extends StatefulWidget {
  const TransactionStatistics({super.key});

  @override
  State<TransactionStatistics> createState() => _TransactionStatisticsState();
}

class _TransactionStatisticsState extends State<TransactionStatistics> {
  TooltipBehavior? _tooltipBehavior;
  Map<String, double> data = {
    'Income': 4000,
    'Spending': 2000,
  };

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, format: 'point.x');
    super.initState();
  }

  List<ChartData> chartData = [
    ChartData(category: 'Food', amount: 1000),
    ChartData(category: 'personal care', amount: 2100),
    ChartData(category: 'vacation', amount: 1200),
    ChartData(category: 'Foods', amount: 1800),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 010, 10, 10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              black.withOpacity(0.9),
              black.withOpacity(0.4),
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
          SizedBox(
            height: 250,
            child: SfCircularChart(
              tooltipBehavior: _tooltipBehavior,
              series: <CircularSeries>[
                // Renders radial bar chart
                RadialBarSeries<ChartData, String>(
                  dataSource: chartData,
                  gap: '5%',
                  trackOpacity: 0.5,
                  radius: '100%',
                  //innerRadius: '60%',
                  maximumValue: 2200,

                  //sortingOrder: SortingOrder.ascending,
                  cornerStyle: CornerStyle.bothCurve,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  pointColorMapper: (ChartData data, index) =>
                      colorPalette[index % colorPalette.length],
                ),
              ],
              legend: const Legend(
                isVisible: true,
                itemPadding: 10,
                position: LegendPosition.bottom,
                alignment: ChartAlignment.near,
                iconHeight: 20,
                iconWidth: 20,
                overflowMode: LegendItemOverflowMode.scroll,
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
  String get label => x;
}
