import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Screens/dashboard_screen.dart';

class TotalKiloBreakdownGraph extends StatefulWidget {
  TotalKiloBreakdownGraph(
      {super.key,
      required this.divs,
      required this.selectedEstateiD,
      required this.selectedEstate,
      required this.width,
      required this.isFullScreen

      
      });
  List<DivData> divs;
  int selectedEstateiD;
  String selectedEstate;
  double width;
  bool isFullScreen;

  @override
  State<TotalKiloBreakdownGraph> createState() =>
      _TotalKiloBreakdownGraphState();
}

class _TotalKiloBreakdownGraphState extends State<TotalKiloBreakdownGraph> {
  double avg = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      width: widget.width,
      decoration: BoxDecoration(
        color: const Color.fromARGB(97, 116, 115, 115),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(4, 4),
            blurRadius: 8,
            spreadRadius: 2,
          ),
          const BoxShadow(
            color: Color.fromARGB(1, 94, 92, 92),
            offset: Offset(-3, -3),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Total kilo breakdown - ${widget.selectedEstate ?? ""}",
                      style: TextStyle(
                        fontFamily: 'IndieFlower',
                        color: Color.fromARGB(255, 190, 245, 188),
                        fontWeight: FontWeight.w900,
                        fontSize: widget.isFullScreen?35:25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                widget.isFullScreen?
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.02),
                    child: Row(
                      mainAxisSize: MainAxisSize
                          .min, // Ensures the Row takes up only as much space as its children
                      children: [
                        Text(
                          "Average : ",
                          style: TextStyle(
                            fontFamily: 'IndieFlower',
                            color: Color.fromARGB(255, 190, 245, 188),
                            fontWeight: FontWeight.w900,
                            fontSize: 23,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // Adds space between the text and the input field
                        Container(
                          width: 100, // Adjust the width as needed
                          child: TextField(
  keyboardType: TextInputType.numberWithOptions(decimal: true),
  decoration: InputDecoration(
    hintText: 'Enter value',
    hintStyle: TextStyle(color: Color.fromARGB(161, 190, 245, 188)),
    filled: true,
    fillColor: Colors.transparent,
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 190, 245, 188), width: 2), // You can customize the color and width
    ),
  ),
  style: TextStyle(color: Color.fromARGB(255, 190, 245, 188)),
  onChanged: (String value) {
    if (value.isEmpty) {
      setState(() {
        avg = 0; // Reset avg if the input is empty
      });
    } else {
      final parsedValue = double.tryParse(value);
      if (parsedValue != null) {
        setState(() {
          avg = parsedValue;
        });
      } else {
        // Handle invalid input (e.g., show an error message)
      }
    }
  },
)

                        ),
                      ],
                    ),
                  ),
                )
              :Container()
              
              ],
            ),
          ),
          Flexible(
            flex: 3,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: const CategoryAxis(
                labelStyle: TextStyle(color: Colors.white),
                labelIntersectAction: AxisLabelIntersectAction.multipleRows,
                majorGridLines:
                    MajorGridLines(width: 0), // Removes Y-axis grid lines
              ),
              primaryYAxis: NumericAxis(
                labelStyle: TextStyle(color: Colors.white),
                majorGridLines:
                    MajorGridLines(width: 0), // Removes Y-axis grid lines
                minorGridLines:
                    MinorGridLines(width: 0), // Removes minor Y-axis grid lines

                plotBands: avg != 0
                    ? [
                        PlotBand(
                          start: avg,
                          end: avg,
                          borderWidth: 2,
                          borderColor: Colors.red,
                          dashArray: <double>[5, 5], // Creates a dashed line
                          text: 'Average',
                          textStyle: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                          verticalTextAlignment: TextAnchor
                              .end, // Positions text at the end of the line
                          horizontalTextAlignment: TextAnchor
                              .start, // Positions text at the start of the line
                        ),
                      ]
                    : [], // Empty list if avg == 0
              ),
              legend: const Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                alignment: ChartAlignment.center,
                textStyle: TextStyle(color: Colors.white),
              ),
              palette: const <Color>[
                Color.fromARGB(255, 137, 15, 15),
                Color.fromARGB(255, 35, 21, 185),
                Color.fromARGB(255, 202, 90, 153),
                Color.fromARGB(255, 179, 168, 47),
                Color.fromARGB(255, 95, 214, 127),
              ],
              series: <CartesianSeries>[
                ColumnSeries<DivData, String>(
                  dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      textStyle:
                          TextStyle(color: Colors.white)), // Always show values

                  dataSource: widget.divs
                      .where((d) => d.estateId == widget.selectedEstateiD)
                      .toList(),
                  xValueMapper: (DivData data, _) => data.name,
                  yValueMapper: (DivData data, _) => data.totalKilo,
                  name: 'Total kilo',
                ),
                ColumnSeries<DivData, String>(
                  dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      textStyle:
                          TextStyle(color: Colors.white)), // Always show values

                  dataSource: widget.divs
                      .where((d) => d.estateId == widget.selectedEstateiD)
                      .toList(),
                  xValueMapper: (DivData data, _) => data.name,
                  yValueMapper: (DivData data, _) => data.regKilo,
                  name: 'Register kilo',
                ),
                ColumnSeries<DivData, String>(
                  dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      textStyle:
                          TextStyle(color: Colors.white)), // Always show values

                  dataSource: widget.divs
                      .where((d) => d.estateId == widget.selectedEstateiD)
                      .toList(),
                  xValueMapper: (DivData data, _) => data.name,
                  yValueMapper: (DivData data, _) => data.cashkilo,
                  name: 'Cash Kilo',
                  // Assign to secondary Y-axis
                ),
                ColumnSeries<DivData, String>(
                  dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      textStyle:
                          TextStyle(color: Colors.white)), // Always show values

                  dataSource: widget.divs
                      .where((d) => d.estateId == widget.selectedEstateiD)
                      .toList(),
                  xValueMapper: (DivData data, _) => data.name,
                  yValueMapper: (DivData data, _) => data.blockKilo,
                  name: 'Block Kilo',
                  // Assign to secondary Y-axis
                ),
                ColumnSeries<DivData, String>(
                  dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      textStyle:
                          TextStyle(color: Colors.white)), // Always show values

                  dataSource: widget.divs
                      .where((d) => d.estateId == widget.selectedEstateiD)
                      .toList(),
                  xValueMapper: (DivData data, _) => data.name,
                  yValueMapper: (DivData data, _) => data.overkilo,
                  name: 'Over Kilo',
                  // Assign to secondary Y-axis
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
