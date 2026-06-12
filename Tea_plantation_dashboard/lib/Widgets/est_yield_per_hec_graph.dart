
import '../Screens/dashboard_screen.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class EstYeildPerHecGraph extends StatefulWidget {
   EstYeildPerHecGraph({
    super.key,
    required this.estwise,
    required this.selectedEstateiD,
    required this.selectedEstate,
    required this.width,
    required this.distinctEstate,
    required this.isFullScreen,
    required this.percentageIncrease,
  });

   List<EstateWiseData> estwise;
   int selectedEstateiD;
   String selectedEstate;
   double width;
   bool isFullScreen;
   List<int> distinctEstate;
   double percentageIncrease;
  
  @override
  State<EstYeildPerHecGraph> createState() => _EstYeildPerHecGraphState();
}

class _EstYeildPerHecGraphState extends State<EstYeildPerHecGraph> {
    double userPercentageIncrease = 0.0; 

    @override
    void initState() {
      super.initState();
      userPercentageIncrease = widget.percentageIncrease;
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
                          offset: const Offset(
                            4, 4), // Shadow direction (right & down)
                          blurRadius: 8, 
                          spreadRadius: 2, 
                        ),
                        const BoxShadow(
                          color: Color.fromARGB(
                              1, 94, 92, 92), 
                          offset: Offset(
                              -3, -3), 
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    )   ,
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
                                              "Estate Yield per hec variation ",
                                              style: TextStyle(
                                                fontFamily: 'IndieFlower',
                                                color: Color.fromARGB(255, 190, 245, 188),
                                                fontWeight: FontWeight.w900,
                                                fontSize: widget.isFullScreen?35:25,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ]
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
                                            "Average : ",
                                            style: TextStyle(
                                              fontFamily: 'IndieFlower',
                                              color: Color.fromARGB(255, 190, 245, 188),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 23,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),   
                                            child: SizedBox(
                                              width: 100, // Control width here
                                              child: TextField(
                                                keyboardType: TextInputType.number,
                                                style: const TextStyle(color: Colors.white), 
                                                decoration: const InputDecoration(
                                                  labelText: 'Enter %',
                                                  labelStyle: TextStyle(color: Colors.white),
                                                  border: OutlineInputBorder(),
                                                ),                                          
                                                onChanged: (String value) {
                                                  final newValue = double.tryParse(value) ?? 0;
                                                  setState(() {
                                                    userPercentageIncrease = newValue.clamp(0, 100);
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

                              Expanded(
                                   flex: 6,
                                  child: SfCartesianChart(
                                primaryXAxis: DateTimeAxis(
                                  labelStyle: const TextStyle(color: Colors.white),
                                  intervalType: DateTimeIntervalType.months,
                                  majorGridLines: const MajorGridLines(width: 0),
                                  dateFormat: DateFormat('MMM yyyy'),
                                ),
                                primaryYAxis:  const NumericAxis(
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
                                trackballBehavior: TrackballBehavior(
                                  enable: true,
                                  activationMode: ActivationMode.singleTap,
                                  tooltipSettings: const InteractiveTooltip(
                                    enable: true,
                                    textStyle: TextStyle(color: Colors.white),
                                  ),
                                ),
                                
                                series: <CartesianSeries>[
                                  // Original Yield Series for each estate
                                  for (int i = 0; i < widget.distinctEstate.length; i++)
                                    LineSeries<EstateWiseData, DateTime>(
                                      name: '${widget.estwise.firstWhere((d) => d.estateId == widget.distinctEstate[i]).name} (Original)',
                                      color: Colors.blueAccent, // Original line color
                                      dataLabelSettings: const DataLabelSettings(isVisible: true, textStyle: TextStyle(color: Colors.white)),
                                      dataSource: widget.estwise
                                          .where((d) => d.estateId == widget.distinctEstate[i])
                                          .toList(),
                                      xValueMapper: (EstateWiseData data, _) =>
                                          DateTime(data.dateTime.year, data.dateTime.month, 1),
                                      yValueMapper: (EstateWiseData data, _) => data.yieldPerHec,
                                    ),
                                    
                              if (userPercentageIncrease > 0)
                                for (int i = 0; i < widget.distinctEstate.length; i++)
                                  StackedLineSeries<EstateWiseData, DateTime>(
                                    name: widget.estwise
                                        .where((d) => d.estateId == widget.distinctEstate[i])
                                        .first
                                        .name ?? "",
                                        color: const Color.fromARGB(255, 68, 255, 77), 
                                    dataLabelSettings: const DataLabelSettings(isVisible: true, textStyle: TextStyle(color: Colors.white)),
                                    dataSource: widget.estwise
                                        .where((d) => d.estateId == widget.distinctEstate[i])
                                        .toList(),
                                    xValueMapper: (EstateWiseData data, _) => 
                                        DateTime(data.dateTime.year, data.dateTime.month, 1),                                
                                    yValueMapper: (EstateWiseData data, _) =>
                                        data.yieldPerHec * (1 + (userPercentageIncrease / 100)),
                                  ),

                                ],
                              ),
                            )
                          ],
                        ),
                      )
        ;
    }
}