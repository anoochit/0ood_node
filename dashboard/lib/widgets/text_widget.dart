import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.deviceId,
    required this.field,
    required this.title,
    required this.isFullWidth,
  });

  final String title;
  final String deviceId;
  final String field;
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                            child: Text('$message'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0)
                    ],
                  ),
                ),
              );
            });
      });
    });
  }
}
