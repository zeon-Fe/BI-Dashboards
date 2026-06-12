import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Screens/dashboard_screen.dart';

class NameBreakdownGraph extends StatefulWidget {
   NameBreakdownGraph({super.key, required this.divs, required this.selectedEstateiD, required this.selectedEstate, required this.width,      required this.isFullScreen});

    List<DivData> divs;
  int selectedEstateiD;
  String selectedEstate;
  double width;
    bool isFullScreen;


  @override
  State<NameBreakdownGraph> createState() => _NameBreakdownGraphState();
}

class _NameBreakdownGraphState extends State<NameBreakdownGraph> {
    double avg = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
                            margin: EdgeInsets.symmetric(
                         
                                vertical:
                                    MediaQuery.of(context).size.height * 0.02,
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
                                  child: 

                                  Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
 "Name breakdown - ${widget.selectedEstate??""}",                      style: TextStyle(
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
                                            majorGridLines: MajorGridLines(width: 0), // Removes Y-axis grid lines
                                  
                                    ),
                                    primaryYAxis:  NumericAxis(
                                      labelStyle: TextStyle(color: Colors.white),
                                          majorGridLines: MajorGridLines(width: 0), // Removes Y-axis grid lines
    minorGridLines: MinorGridLines(width: 0), // Removes minor Y-axis grid lines
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
                    : [], 
                                    ),
                                    legend: const Legend(
                                      isVisible: true,
                                      position: LegendPosition.bottom,
                                      alignment: ChartAlignment.center,
                                      textStyle: TextStyle(color: Colors.white),
                                    ),
                                    palette: const <Color>[
                                      Colors.teal,
                                      Colors.orange,
                                    ],
                                    series: <CartesianSeries>[
                                      ColumnSeries<DivData, String>(
                                              dataLabelSettings: const DataLabelSettings(isVisible: true, textStyle: TextStyle(color: Colors.white)), // Always show values

                                        dataSource: widget.divs
                                            .where((d) => d.estateId == widget.selectedEstateiD)
                                            .toList(),
                                        xValueMapper: (DivData data, _) =>
                                            data.name,
                                        yValueMapper: (DivData data, _) =>
                                            data.checkRollName,
                                        name: 'Checkroll Name',
                                      ),
                                      ColumnSeries<DivData, String>(
                                              dataLabelSettings: const DataLabelSettings(isVisible: true, textStyle: TextStyle(color: Colors.white)), // Always show values

                                        dataSource: widget.divs
                                            .where((d) => d.estateId == widget.selectedEstateiD)
                                            .toList(),
                                        xValueMapper: (DivData data, _) =>
                                            data.name,
                                        yValueMapper: (DivData data, _) =>
                                            data.cashName,
                                        name: 'Cash Name',
                                        // yAxisName:
                                        //     'Secondary', // Assign to secondary Y-axis
                                      ),
                                    ],
                                    // Define secondary Y-axis
    //                                 axes: <ChartAxis>[
    //                                   NumericAxis(
    //                                     name:
    //                                         'Secondary', // This matches the yAxisName in the series
    //                                     labelStyle:
    //                                         const TextStyle(color: Colors.white),
    //                                     axisLine: const AxisLine(width: 0),
    //                                         majorGridLines: MajorGridLines(width: 0), // Removes Y-axis grid lines
    // minorGridLines: MinorGridLines(width: 0), // Removes minor Y-axis grid lines
    //                                   ),
    //                                 ],
                                  ),
                                )
                            
                            
                              ],
                            ),
                          )
           ;
  }
}