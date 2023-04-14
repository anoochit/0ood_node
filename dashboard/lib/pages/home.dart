import 'package:flutter/material.dart';

import '../widgets/column_widget.dart';
import '../widgets/spline_widget.dart';
import '../widgets/text_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: const EdgeInsets.all(16.0),
          child: Wrap(
            children: const [
              TextWidget(
                title: "PM 2.5 ug/m3",
                deviceId: "249396",
                field: "pm25",
                isFullWidth: false,
              ),
              TextWidget(
                title: "PM 10 ug/m3",
                deviceId: "249396",
                field: "pm100",
                isFullWidth: false,
              ),
              SplineChartWidget(
                title: "PM 2.5 ug/m3",
                deviceId: "249396",
                field: "pm25",
                length: 10,
                isFullWidth: false,
              ),
              SplineChartWidget(
                title: "PM 10 ug/m3",
                deviceId: "249396",
                field: "pm100",
                length: 10,
                isFullWidth: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
