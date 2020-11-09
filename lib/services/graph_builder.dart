import 'package:data_visualization_app/services/sorting_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GraphBuilder {
  /// Method to build a ScatterPlotChart with given [data]
  Widget buildScatterPlotChart(
      List<charts.Series<ActivitiesPrecisionNumData, int>> data) {
    return charts.ScatterPlotChart(
      data,
      animate: true,
      animationDuration: Duration(seconds: 1),
      customSeriesRenderers: [
        new charts.LineRendererConfig(
            customRendererId: 'progressionLine',
            layoutPaintOrder: charts.LayoutViewPaintOrder.point + 1),
      ],
      domainAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(desiredMinTickCount: 5),
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 10,
            color: charts.Color.fromHex(code: "#2D274CFF"),
          ),
          lineStyle: charts.LineStyleSpec(
            thickness: 2,
            color: charts.Color.fromHex(code: "#2D274CFF"),
          ),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 10,
            color: charts.Color.fromHex(code: "#2D274CFF"),
          ),
          lineStyle: charts.LineStyleSpec(
            thickness: 2,
            color: charts.Color.fromHex(code: "#2D274CFF"),
          ),
        ),
      ),
    );
  }

  /// Method to build a TimesSeriesChart consisting of data points connected by
  /// straight lines. Additionally the area under the graph is being colored.
  /// Building the graph using [data]
  Widget buildTimeSeriesChartPointsLinesArea(
      List<charts.Series<ActivitiesDataDateTime, DateTime>> data,
      bool inverseColors,
      bool distance) {
    return charts.TimeSeriesChart(
      data,
      animate: true,
      animationDuration: Duration(seconds: 1),
      defaultRenderer: new charts.LineRendererConfig(
        includePoints: true,
        includeArea: true,
      ),
      domainAxis: new charts.DateTimeAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          axisLineStyle: charts.LineStyleSpec(
            color: inverseColors
                ? charts.Color.fromHex(code: "#2D274CFF")
                : charts.MaterialPalette
                    .white, // this also doesn't change the Y axis labels
          ),
          labelStyle: new charts.TextStyleSpec(
            fontSize: 10,
            color: inverseColors
                ? charts.Color.fromHex(code: "#2D274CFF")
                : charts.MaterialPalette.white,
          ),
          lineStyle: charts.LineStyleSpec(
            thickness: 1,
            color: inverseColors
                ? charts.Color.fromHex(code: "#2D274CFF")
                : charts.MaterialPalette.white,
          ),
        ),
        tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
          hour: new charts.TimeFormatterSpec(
            format: 'H',
            transitionFormat: 'H',
          ),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickFormatterSpec: charts.BasicNumericTickFormatterSpec((num value) {
          String valueTronc = value.toStringAsFixed(0);

          return distance ? valueTronc + " km" : valueTronc + " h";
        }),
        tickProviderSpec:
            new charts.BasicNumericTickProviderSpec(desiredTickCount: 3),
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
              fontSize: 10,
              color: inverseColors
                  ? charts.Color.fromHex(code: "#2D274CFF")
                  : charts.MaterialPalette.white),
          lineStyle: charts.LineStyleSpec(
              thickness: 1,
              color: inverseColors
                  ? charts.Color.fromHex(code: "#2D274CFF")
                  : charts.MaterialPalette.white),
        ),
      ),
    );
  }

  /// Method to build a TimeSeriesChart as a BarChart with given [data]
  Widget buildTimeSeriesChartBarChart(
    List<charts.Series<ActivitiesDataDateTime, DateTime>> data,
    double height,
    bool inverseColors,
    bool week,
  ) {
    return charts.TimeSeriesChart(
      data,
      animate: true,
      animationDuration: Duration(seconds: 1),
      defaultRenderer: new charts.BarRendererConfig<DateTime>(
        cornerStrategy: const charts.ConstCornerStrategy(30),
        groupingType: charts.BarGroupingType.stacked,
      ),
      defaultInteractions: false,
      domainAxis: new charts.DateTimeAxisSpec(
        tickProviderSpec:
            charts.DayTickProviderSpec(increments: [week ? 1 : 7]),
        renderSpec: charts.GridlineRendererSpec(
          axisLineStyle: charts.LineStyleSpec(
            color: inverseColors
                ? charts.Color.fromHex(code: "#2D274CFF")
                : charts.MaterialPalette
                    .white, // this also doesn't change the Y axis labels
          ),
          labelStyle: new charts.TextStyleSpec(
            fontSize: 10,
            color: inverseColors
                ? charts.Color.fromHex(code: "#2D274CFF")
                : charts.MaterialPalette.white,
          ),
          lineStyle: charts.LineStyleSpec(
            thickness: 2,
            color: inverseColors
                ? charts.Color.fromHex(code: "#2D274CFF")
                : charts.MaterialPalette.white,
          ),
        ),
        tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
          hour: new charts.TimeFormatterSpec(
            format: 'H',
            transitionFormat: 'H',
          ),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickFormatterSpec:
            charts.BasicNumericTickFormatterSpec((num value) => '$value h'),
        tickProviderSpec:
            new charts.BasicNumericTickProviderSpec(desiredTickCount: 3),
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
              fontSize: 10,
              color: inverseColors
                  ? charts.Color.fromHex(code: "#2D274CFF")
                  : charts.MaterialPalette.white),
          lineStyle: charts.LineStyleSpec(
              thickness: 2,
              color: inverseColors
                  ? charts.Color.fromHex(code: "#2D274CFF")
                  : charts.MaterialPalette.white),
        ),
      ),
    );
  }

  /// Method to build a horizontal BarChart with given [data]
  Widget buildTimeSeriesChartHorizontalBarChart(
      List<charts.Series<ActivitiesData, String>> data) {

    return charts.BarChart(
      data,
      animate: true,
      animationDuration: Duration(seconds: 1),
      vertical: false,
      domainAxis: charts.AxisSpec<String>(
        tickFormatterSpec: charts.BasicOrdinalTickFormatterSpec(),
        renderSpec: charts.GridlineRendererSpec(
          lineStyle: charts.LineStyleSpec(
              thickness: 1, color: charts.Color.fromHex(code: "#2D274CFF")),
          labelStyle: new charts.TextStyleSpec(
            fontSize: 10,
            color: charts.Color.fromHex(code: "#2D274CFF"),
          ),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
              fontSize: 10, color: charts.Color.fromHex(code: "#2D274CFF")),
          lineStyle: charts.LineStyleSpec(
              thickness: 1, color: charts.Color.fromHex(code: "#2D274CFF")),
        ),
      ),
    );
  }
}
