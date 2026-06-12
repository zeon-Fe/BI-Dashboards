import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../Screens/dashboard_screen.dart';

class DivYeildPerHecGraph extends StatefulWidget {
  const DivYeildPerHecGraph(
    {super.key, 
      required this.est, 
      required this.selectedEstateiD, 
      required this.selectedEstate, 
      required this.width, 
      required this.distinctDivisions, 
      required this.isFullScreen, 
      required this.percentageIncrease});

      final List<EstateData> est;
      final int selectedEstateiD;
      final String selectedEstate;
      final double width;
      final List<int> distinctDivisions;
      final bool isFullScreen;
      final double percentageIncrease;

  @override
  State<DivYeildPerHecGraph> createState() => _DivYeildPerHecGraphState();
}

// class _PercentageInputFormatter extends TextInputFormatter {
//   final int max;
//   _PercentageInputFormatter({required this.max});

//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     final intValue = int.tryParse(newValue.text);
//     if (intValue != null && intValue > max) {
//       return oldValue; // Reject input if it exceeds max
//     }
//     return newValue;
//   }
// }

class _PercentageInputFormatter extends TextInputFormatter {
  final double max;
  _PercentageInputFormatter({required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;

    // Allow empty input or just decimal point
    if (newText.isEmpty || newText == ".") {
      return newValue;
    }

    final doubleValue = double.tryParse(newText);
    if (doubleValue == null || doubleValue > max) {
      return oldValue; // Reject invalid or too-large input
    }

    return newValue;
  }
}







class _DivYeildPerHecGraphState extends State<DivYeildPerHecGraph> {
    double userPercentageIncrease = 0.0; 
    double originalAverageYield  = 0.0; 
    double updatedAverageYield = 0.0;
    final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    userPercentageIncrease = widget.percentageIncrease;
    // _controller.text = userPercentageIncrease.toString(); 
   computeAverageYield();
  }

@override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

void computeAverageYield() {
    if (widget.est.isEmpty) return; // Handle empty case

    final totalYield = widget.est.fold(0.0, (sum, item) => sum + item.yieldPerHec); // Calculate total yield
    originalAverageYield = totalYield / widget.est.length;
    updatedAverageYield = originalAverageYield * (1 + userPercentageIncrease / 100);    // Calculate updated average yield based on user input percentage
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       margin: EdgeInsets.symmetric(     
           vertical:
              MediaQuery.of(context).size.height * 0.02,
                  ),
                    width: widget.width,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(97, 116, 115, 115), // Background color
                        borderRadius:BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3), // Darker shadow
                            offset: const Offset(4, 4), // Shadow direction (right & down)
                            blurRadius: 8, // Softness of the shadow
                            spreadRadius: 2, // How far the shadow spreads
                          ),
                          const BoxShadow(
                            color: Color.fromARGB( 1, 94, 92, 92), // Light shadow for 3D effect
                            offset: Offset(-3, -3), // Opposite direction for a 3D look
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Flexible(
                                flex: 2,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Division Yield per Hectare - ${widget.selectedEstate ?? ""}",
                                              style: TextStyle(
                                                fontFamily: 'IndieFlower',
                                                color: Color.fromARGB(255, 190, 245, 188),
                                                fontWeight: FontWeight.w900,
                                                fontSize: widget.isFullScreen ? 35 : 25,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),

                                            if (widget.isFullScreen && widget.est.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: Text(
                                                  () {
                                                    final dates = widget.est
                                                        .map((e) => DateTime(e.dateTime.year, e.dateTime.month))
                                                        .toSet()
                                                        .toList()
                                                      ..sort((a, b) => a.compareTo(b));
                                                    final first = dates.first;
                                                    final last = dates.last;
                                                    final firstStr = DateFormat('yyyy-MMM').format(first).toUpperCase();
                                                    final lastStr = DateFormat('yyyy-MMM').format(last).toUpperCase();

                                                    return dates.length == 1
                                                        ? "Month: $firstStr"
                                                        : "Month Range: $firstStr - $lastStr";
                                                  }(),
                                                  style: const TextStyle(
                                                    fontFamily: 'IndieFlower',
                                                    color: Color.fromARGB(200, 204, 245, 188),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                          ],
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
                                        const Text(
                                          "Increase average by : ",
                                          style: TextStyle(
                                            fontFamily: 'IndieFlower',
                                            color: Color.fromARGB(174, 197, 245, 188),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 23,
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),                               
                                          child: SizedBox(
                                            width: 100, // Control width
                                            child: TextField(
                                              controller: _controller,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}(\.\d{0,2})?$')), // Allows up to 2 decimal places
                                                _PercentageInputFormatter(max: 100),
                                              ],
                                              style: const TextStyle(color: Colors.white),
                                              decoration: const InputDecoration(
                                                labelText: 'Enter %',
                                                labelStyle: TextStyle(color: Colors.white),
                                                border: OutlineInputBorder(),
                                              ),
                                              onChanged: (String value) {
                                                setState(() {
                                                  userPercentageIncrease = double.tryParse(value) ?? 0;
                                                  computeAverageYield();
                                                });
                                              },
                                            ),
                                          )
                                        )
                                      ],                                     
                                    ),
                                  ),
                                )
                              :Container()                             
                              ],
                            ),
                          ),

                    if (widget.isFullScreen)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0, right: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Current Average of all Divisions: ${updatedAverageYield.toStringAsFixed(2)} kg/ha',
                                style: const TextStyle(
                                  fontFamily: 'IndieFlower',
                                  fontSize: 18,
                                  color: Color.fromARGB(206, 255, 156, 143),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Yield per Hectare = Total Plucked Harvest (kg) / Total Plucked Area (ha)",
                                style: TextStyle(
                                  fontFamily: 'IndieFlower',
                                  fontSize: 18,
                                  color: Color.fromARGB(214, 209, 203, 203),
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w800,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ),


                          //  ),
                            // const Padding(
                            //   padding: EdgeInsets.only(top: 8.0, right: 12.0),
                            //   child: Align(
                            //     alignment: Alignment.centerRight,
                            //     child: Text(
                            //       "Yield per Hectare = Total Plucked Harvest (kg) ÷ Total Plucked Area (ha)",
                            //       style: TextStyle(
                            //         fontFamily: 'IndieFlower',
                            //         fontSize: 16,
                            //         color: Colors.white,
                            //         fontStyle: FontStyle.normal,
                            //         fontWeight: FontWeight.w500,
                            //       ),
                            //       textAlign: TextAlign.justify,
                            //     ),
                            //   ),
                            // ),

                          Expanded(
                            flex: 6,
                            child: SfCartesianChart(
                              primaryXAxis: DateTimeAxis(
                                labelStyle: const TextStyle(color: Colors.white),
                                intervalType: DateTimeIntervalType.months,
                                majorGridLines: const MajorGridLines(width: 0),
                                dateFormat: DateFormat('MMM yyyy'),
                              ),
                              primaryYAxis: NumericAxis(
                               
                              plotBands: originalAverageYield != 0
                              ? [
                                PlotBand(
                                  start: updatedAverageYield,
                                  end: updatedAverageYield,
                                  borderWidth: 2,
                                  borderColor: const Color.fromARGB(228, 235, 86, 60), // Tomato red
                                  dashArray: <double>[6, 3],
                                  shouldRenderAboveSeries: true,
                                  text: ' Avg: ${updatedAverageYield.toStringAsFixed(2)} kg/ha',
                                  textStyle: const TextStyle(
                                    // color: Colors.orangeAccent,
                                    color: Color.fromARGB(181, 255, 145, 145),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    backgroundColor: Color.fromARGB(199, 0, 0, 0),
                                  ),
                                  horizontalTextAlignment: TextAnchor.start,
                                  verticalTextAlignment: TextAnchor.middle,
                                ),
                              ]
                            : [], 
                                // plotBands: originalAverageYield != 0
                                //   ? [
                                //       PlotBand(
                                //         start: originalAverageYield,
                                //         end: originalAverageYield,
                                //         borderWidth: 2,
                                //         borderColor: const Color.fromARGB(158, 250, 63, 39),
                                //         dashArray: <double>[3, 6], // Dashed line
                                //         shouldRenderAboveSeries: true,
                                //         text: 'Average: ${updatedAverageYield.toStringAsFixed(2)} kg/ha\n',
                                //         textStyle: const TextStyle(
                                //           color:  Color.fromARGB(192, 255, 118, 100),
                                //           fontSize: 14,
                                //           fontStyle: FontStyle.italic
                                //         ),
                                //         verticalTextAlignment: TextAnchor
                                //             .end, // Positions text at the end of the line
                                //         horizontalTextAlignment: TextAnchor
                                //             .start, // Positions text at the start of the line
                                    
                                //       ),
                                //     ]
                                //   : [], 

                                labelStyle: TextStyle(color: Colors.white),
                                majorGridLines: MajorGridLines(width: 0.2),
                                minorGridLines: MinorGridLines(width: 0),        
                              ),

                              legend: const Legend(
                                isVisible: true,
                                position: LegendPosition.bottom,
                                alignment: ChartAlignment.center,
                                textStyle: TextStyle(color: Colors.white),
                              ),
                              
                              tooltipBehavior: TooltipBehavior(
                                enable: true,
                                builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                                  final EstateData estate = data;
                                  final originalYield = estate.yieldPerHec.toStringAsFixed(2);
                                  final updatedYield = (estate.yieldPerHec * (1 + userPercentageIncrease / 100)).toStringAsFixed(2);
                                  final formattedDate = DateFormat('MM/yyyy').format(estate.dateTime);

                                  return Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Date: $formattedDate\n'
                                      'Original: $originalYield kg/ha\n'
                                      'Updated: $updatedYield kg/ha',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  );
                                },
                              ),


                            series: <CartesianSeries>[
                                for (int i = 0; i < widget.distinctDivisions.length; i++)
                                  ColumnSeries<EstateData, DateTime>(
                                    name: widget.est
                                            .firstWhere((d) => d.id == widget.distinctDivisions[i])
                                            .name,
                                    dataLabelSettings: const DataLabelSettings(
                                      isVisible: true,
                                      textStyle: TextStyle(color: Colors.white, 
                                      fontSize: 14, 
                                      fontWeight: FontWeight.normal),
                                    ),
                                    dataSource: widget.est.where((d) => d.id == widget.distinctDivisions[i]).toList(),
                                    xValueMapper: (EstateData data, _) => DateTime(data.dateTime.year, data.dateTime.month, 1),
                                    yValueMapper: (EstateData data, _) => data.yieldPerHec * (1 + userPercentageIncrease / 100),
                                    dataLabelMapper: (EstateData data, _) {
                                      final original = data.yieldPerHec.toStringAsFixed(2);
                                      final updated = (data.yieldPerHec * (1 + userPercentageIncrease / 100)).toStringAsFixed(2);
                                      return "$updated kg/ha";
                                      //return "$original kg/ha ➜ $updated kg/ha";
                                    },
                                  ),

                                // LineSeries<EstateData, DateTime>(
                                //   name: 'Average Yield',
                                //   color: const Color.fromARGB(255, 173, 28, 28),
                                //   width: 2,
                                //  // dashArray: <double>[5, 5],
                                //   dataSource: widget.est,
                                //   xValueMapper: (EstateData data, _) => data.dateTime,
                                //   yValueMapper: (_, __) => averageYield,
                                  
                                //   markerSettings: MarkerSettings(isVisible: true),
                                //   // dataLabelSettings: const DataLabelSettings(isVisible: false),
                                //   dataLabelSettings: DataLabelSettings(
                                //     isVisible: widget.isFullScreen,
                                //     labelAlignment: ChartDataLabelAlignment.top,
                                //     textStyle: TextStyle(color: const Color.fromARGB(255, 146, 37, 29), fontWeight: FontWeight.w600, fontSize: 16),
                                //   ),
                                //   dataLabelMapper: (_, __) => averageYield.toStringAsFixed(2),
                                //   enableTooltip: false,
                                // ),



                        // // Average Line Series
                        // LineSeries<EstateData, DateTime>(
                        //   name: 'Average',
                        //   color: Colors.red,
                        //   width: 2,
                        //   dashArray: <double>[5, 5],
                        //   dataSource: widget.est,
                        //     xValueMapper: (EstateData data, _) => data.dateTime,
                        //     yValueMapper: (_, __) => averageYield,
                                  
                        //   dataLabelSettings: const DataLabelSettings(isVisible: true),
                        //   enableTooltip: true,
                        //   markerSettings: const MarkerSettings(isVisible: true),
                        // ),
                    
                     ]
                  ),
                ),
              ],
          ),
        )
      ;
    }
  }