import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({
    super.key,
    required this.deviceId,
    required this.field,
    required this.title,
    required this.isFullWidth,
    required this.length,
  });

  final String title;
  final String deviceId;
  final String field;
  final bool isFullWidth;
  final int length;

  @override
  Widget build(BuildContext context) {
    // fix screen width
    double widgetWidth = MediaQuery.of(context).size.width - 32;

    // subscription
    final subscriptionDocument = gql('''subscription {
      logs(
        limit: $length, 
        order_by: {timestamp: desc}, 
        where: {device_id: {_eq: "$deviceId"}}
        ) {
        device_id
        message(path: "$field")
        timestamp
      }
    }''');

    return ResponsiveBuilder(builder: (
      context,
      sizingInformation,
    ) {
      return LayoutBuilder(builder: (context, constraints) {
        if (isFullWidth == false) {
          if (sizingInformation.isDesktop) {
            widgetWidth = constraints.maxWidth / 4;
          } else if (sizingInformation.isTablet) {
            widgetWidth = constraints.maxWidth / 2;
          }
        }

        return Subscription(
            options: SubscriptionOptions(document: subscriptionDocument),
            builder: (result) {
              if (result.hasException) {
                return SizedBox(
                  width: widgetWidth,
                  height: (isFullWidth)
                      ? ((widgetWidth / 4) * 0.6)
                      : (widgetWidth * 0.8),
                  child: const Card(
                    child: Center(
                      child: Text("Cannot load data"),
                    ),
                  ),
                );
              }

              if (result.isLoading) {
                return SizedBox(
                  width: widgetWidth,
                  height: (isFullWidth)
                      ? ((widgetWidth / 4) * 0.6)
                      : (widgetWidth * 0.8),
                  child: const Card(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }

              // parse data
              List<dynamic> data = result.data!['logs'];
              List<ChartData> chartData = <ChartData>[];
              for (var element in data) {
                chartData.add(
                  ChartData(
                      element['timestamp']
                          .toString()
                          .split("T")[1]
                          .split("+")[0],
                      element['message']),
                );
              }

              chartData = chartData.reversed.toList();

              return buildChart(widgetWidth, context, chartData);
            });
      });
    });
  }

  SizedBox buildChart(
      double widgetWidth, BuildContext context, List<ChartData> chartData) {
    return SizedBox(
      width: widgetWidth,
      height: (isFullWidth) ? ((widgetWidth / 4) * 0.6) : (widgetWidth * 0.8),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Expanded(
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    ColumnSeries<ChartData, String>(
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String x;
  final double y;
  ChartData(
    this.x,
    this.y,
  );
}
