import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartWidget extends StatelessWidget {
  const PieChartWidget({
    super.key,
    required this.deviceId,
    required this.fields,
    required this.title,
    required this.isFullWidth,
    required this.fieldsTitle,
  });

  final String title;
  final String deviceId;
  final List<String> fields;
  final List<String> fieldsTitle;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    // fix screen width
    double widgetWidth = MediaQuery.of(context).size.width - 32;

    // subscription
    final subscriptionDocument = gql('''subscription {
      logs(
        limit: 1, 
        order_by: {timestamp: desc}, 
        where: {device_id: {_eq: "$deviceId"}}
        ) {
        device_id
        message
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
                  height: widgetWidth * 0.8,
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
                  height: widgetWidth * 0.8,
                  child: const Card(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }

              // parse data
              final data = result.data;
              var message = data!['logs'][0]['message'];

              List<ChartData> chartData = [];

              for (var element in fields) {
                chartData.add(
                  ChartData(
                    fieldsTitle[fields.indexOf(element)],
                    message[element],
                  ),
                );
              }

              return buildChart(widgetWidth, context, chartData);
            });
      });
    });
  }

  SizedBox buildChart(
      double widgetWidth, BuildContext context, List<ChartData> chartData) {
    return SizedBox(
      width: widgetWidth,
      height: widgetWidth * 0.8,
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Expanded(
              child: SfCircularChart(
                series: <CircularSeries>[
                  PieSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelIntersectAction: LabelIntersectAction.shift,
                    ),
                  )
                ],
              ),
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
