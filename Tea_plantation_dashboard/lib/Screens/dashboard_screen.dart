import 'dart:async'; // Import Timer package
import 'dart:convert';
import 'dart:io';
import 'dart:math';
// import 'dart:typed_data';
// import 'dart:convert';
// import 'dart:io';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:data_engine/Widgets/area_vs_kilo_graph.dart';
import 'package:data_engine/Widgets/average_summary_graph.dart';
import 'package:data_engine/Widgets/div_yield_per_hec_graph.dart';
import 'package:data_engine/Widgets/est_yield_per_hec_graph.dart';
import 'package:data_engine/Widgets/name_breakdown_graph.dart';
import 'package:data_engine/Widgets/total_kilo_breakdown_graph.dart';
import 'package:data_engine/Models/division.dart';
import 'package:data_engine/Models/estate.dart';
import 'package:data_engine/Models/weighments.dart';
// import 'package:flutter/foundation.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:tuple/tuple.dart';

import '../Models/plantation.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();
 // final ScrollController _scrollController2 = ScrollController();

  late Timer _timer;

  double totalWeighments = 0;
  int totalWorkers = 0;
  int currentPlantation = 1;
  Estate maxEstate = Estate(0, "", "", 0, 0);
  List<Plantation> plnt = [];
  List<EstateData> est = [];
  List<DivData> divs = [];

  List<EstateWiseData> estwise = [];
  List<EstateWiseDataSummery> estwiseSum = [];

  List<Weighment> w1 = [];
  List<Weighment> w2 = [];
  List<Weighment> w3 = [];
  List<int> distinctDivisions = [];
  List<int> distinctEstate = [];

  String w1Name = "";
  DateTime? _startDate;
  DateTime? _endDate;

  double userPercentageIncrease = 0.0;
  DateTime? _maxdate;
  DateTime? _mindate;
  String? selectedEstate;
  int selectedEstateiD = 0;

  final Random random = Random();

  @override
  void initState() {
    super.initState();
    //  Weighment.generateWeighments(2000);

    plnt = Plantation.plantations;
    calculateOnce();
    int count = 1;
    // Start the timer to scroll the row every 5 minutes
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      // _scrollToNext();
      // count++;
      // if (count > 3) {
      //   count = 1;
      // }
      // setState(() {
      //   currentPlantation = count;
      //   print(currentPlantation);
      // });
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }


  void calculateOnce() {
    if (Weighment.weighments.isNotEmpty) {
      setState(() {
        for (int i = 0; i < plnt.length; i++) {
          plnt[i].Color1 = getRandomColor();
          plnt[i].Color2 = getRandomColor();

          plnt[i].totalWeighment = double.parse(Weighment.weighments
              .where((d) => d.plantationId == plnt[i].id)
              .fold(0.0, (sum, e) => sum + e.totalKilo)
              .toStringAsFixed(2));
        }
      });
    }
  }

  void calculate() {
    if (Weighment.weighments.isNotEmpty) {
      setState(() {
        // totalWeighments = double.parse(Weighment.weighments
        //     .where((d) => d.plantationId == 1)
        //     .fold(0.0, (sum, e) => sum + e.totalKilo)
        //     .toStringAsFixed(2));

        // totalWorkers = Weighment.weighments
        //     .where((d) => d.plantationId == currentPlantation)
        //     .length;
// Group weighments by estateId and sum the weighments for each estate
        var estateWeighmentSums = Weighment.weighments
            .where((d) => d.plantationId == currentPlantation)
            .fold<Map<int, double>>({}, (map, e) {
          map[e.estateId] = (map[e.estateId] ?? 0.0) + e.totalKilo;
          return map;
        });

// Find the estate with the maximum total weighment
        int maxEstateId = estateWeighmentSums.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;
// Find the Estate object based on the maxEstateId
        maxEstate = Estate.estates.firstWhere((d) => d.id == maxEstateId);
        w1 = getMonthlySummary(currentPlantation, 0);
        try {
          w1Name = w1 != true
              ? est != true
                  ? w1.isNotEmpty && est.isNotEmpty
                      ? est.where((d) => d.id == w1[0].estateId).first.name ??
                          ""
                      : ""
                  : ""
              : "";
        } catch (e) {
          print(e);
        }
        w2 = getMonthlySummary(
            currentPlantation, 1); // Sort by weighmentDateTime

        w3 = getMonthlySummary(
            currentPlantation, 2); // Sort by weighmentDateTime

        est = [];
        divs = [];

        estwiseSum = [];
        estwise = [];
        totalWorkers = 0;
        totalWeighments = 0;
        List<Weighment> we = Weighment.weighments;

        _maxdate = Weighment.weighments
            .map((d) => d.weighmentDateTime)
            .reduce((a, b) => a.isAfter(b) ? a : b);

        _mindate = Weighment.weighments
            .map((d) => d.weighmentDateTime)
            .reduce((a, b) => a.isBefore(b) ? a : b);

        we.sort((a, b) => a.weighmentDateTime.compareTo(b.weighmentDateTime));
        for (int i = 0; i < we.length; i++) {
          totalWorkers += we[i].harvestedFieldCount;
          totalWeighments += we[i].totalKilo;
          var matchingDivision = Division.divs.firstWhere(
              (w) => w.id == we[i].divisionId,
              orElse: () => Division(0, "", "", 0, 0, 0) // Default value
              );

          if (matchingDivision.id != 0) {
            var existingItem = est.firstWhere(
                (d) =>
                    d.id == we[i].divisionId &&
                    d.dateTime == we[i].weighmentDateTime,
                orElse: () => EstateData(
                    "", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, DateTime.now()));

            if (existingItem.id != 0) {
              existingItem.totalKilo += we[i].totalKilo;
              existingItem.regKilo += we[i].regKilo;

              existingItem.cashkilo += we[i].cashKilo;

              existingItem.blockKilo += we[i].blockKilo;
              existingItem.checkRollName += we[i].checkrollName;

              existingItem.cashName += we[i].cashName;
              existingItem.overkilo += we[i].overKilo;

              existingItem.pluckedAvg += we[i].pluckedAvg;
              existingItem.yieldPerHec += we[i].yieldPerHec;

              existingItem.harvestedArea += we[i].harvestedArea;
            } else {
              est.add(EstateData(
                  matchingDivision.name,
                  matchingDivision.id,
                  matchingDivision.estateId,
                  we[i].totalKilo,
                  we[i].harvestedArea,
                  we[i].regKilo,
                  we[i].cashKilo,
                  we[i].blockKilo,
                  we[i].overKilo,
                  we[i].checkrollName,
                  we[i].cashName,
                  we[i].pluckedAvg,
                  we[i].yieldPerHec,
                  we[i].weighmentDateTime));
            }

            var existingItems = divs.firstWhere((d) => d.id == we[i].divisionId,
                orElse: () => DivData("", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));

            if (existingItems.id != 0) {
              existingItems.totalKilo += we[i].totalKilo;
              existingItems.regKilo += we[i].regKilo;

              existingItems.cashkilo += we[i].cashKilo;

              existingItems.blockKilo += we[i].blockKilo;
              existingItems.checkRollName += we[i].checkrollName;

              existingItems.cashName += we[i].cashName;
              existingItems.overkilo += we[i].overKilo;

              existingItems.pluckedAvg += we[i].pluckedAvg;
              existingItems.yieldPerHec += we[i].yieldPerHec;

              existingItems.harvestedArea += we[i].harvestedArea;
            } else {
              divs.add(DivData(
                  matchingDivision.name,
                  matchingDivision.id,
                  matchingDivision.estateId,
                  we[i].totalKilo,
                  we[i].harvestedArea,
                  we[i].regKilo,
                  we[i].cashKilo,
                  we[i].blockKilo,
                  we[i].overKilo,
                  we[i].checkrollName,
                  we[i].cashName,
                  we[i].pluckedAvg,
                  we[i].yieldPerHec));
            }
          }

          var matchingEstate =
              Estate.estates.firstWhere((w) => w.id == we[i].estateId,
                  orElse: () => Estate(
                        0,
                        "",
                        "",
                        0,
                        0,
                      ) // Default value
                  );

          if (matchingEstate.id != 0) {
            var existingItem = estwise.firstWhere(
                (d) =>
                    d.estateId == we[i].estateId &&
                    d.dateTime == we[i].weighmentDateTime,
                orElse: () => EstateWiseData("", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, DateTime.now(), Colors.white));

            if (existingItem.estateId != 0) {
              existingItem.totalKilo += we[i].totalKilo;
              existingItem.regKilo += we[i].regKilo;

              existingItem.cashkilo += we[i].cashKilo;

              existingItem.blockKilo += we[i].blockKilo;
              existingItem.checkRollName += we[i].checkrollName;

              existingItem.cashName += we[i].cashName;
              existingItem.overkilo += we[i].overKilo;

              existingItem.pluckedAvg += we[i].pluckedAvg;
existingItem.yieldPerHec += double.parse(
  (we[i].yieldPerHec / (Division.divs.where((d) => d.estateId == we[i].estateId).isEmpty
      ? 1 
      : Division.divs.where((d) => d.estateId == we[i].estateId).length))
  .toStringAsFixed(2)
);

              existingItem.harvestedArea += we[i].harvestedArea;
            } else {
              estwise.add(EstateWiseData(
                  matchingEstate.name,
                  matchingEstate.id,
                  we[i].totalKilo,
                  we[i].harvestedArea,
                  we[i].regKilo,
                  we[i].cashKilo,
                  we[i].blockKilo,
                  we[i].overKilo,
                  we[i].checkrollName,
                  we[i].cashName,
                  we[i].pluckedAvg,
                  double.parse(
  (we[i].yieldPerHec / (Division.divs.where((d) => d.estateId == we[i].estateId).isEmpty
      ? 1 
      : Division.divs.where((d) => d.estateId == we[i].estateId).length))
  .toStringAsFixed(2)
),
                  we[i].weighmentDateTime,
                  getRandomColor()));
            }

            var existingItemSum = estwiseSum.firstWhere(
                (d) => d.estateId == we[i].estateId,
                orElse: () => EstateWiseDataSummery(
                    "", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, Colors.white));

            if (existingItemSum.estateId != 0) {
              existingItemSum.totalKilo += we[i].totalKilo;
              existingItemSum.regKilo += we[i].regKilo;

              existingItemSum.cashkilo += we[i].cashKilo;

              existingItemSum.blockKilo += we[i].blockKilo;
              existingItemSum.checkRollName += we[i].checkrollName;

              existingItemSum.cashName += we[i].cashName;
              existingItemSum.overkilo += we[i].overKilo;

              existingItemSum.pluckedAvg += we[i].pluckedAvg;
              existingItemSum.yieldPerHec += we[i].yieldPerHec;

              existingItemSum.harvestedArea += we[i].harvestedArea;
            } else {
              estwiseSum.add(EstateWiseDataSummery(
                  matchingEstate.name,
                  matchingEstate.id,
                  we[i].totalKilo,
                  we[i].harvestedArea,
                  we[i].regKilo,
                  we[i].cashKilo,
                  we[i].blockKilo,
                  we[i].overKilo,
                  we[i].checkrollName,
                  we[i].cashName,
                  we[i].pluckedAvg,
                  we[i].yieldPerHec,
                  getRandomColor()));
            }
          }
        }

        distinctDivisions = est
            .where((d) => d.estateId == selectedEstateiD) // Filter
            .map((d) => d.id) // Extract only `id`
            .toSet() // Remove duplicates
            .toList(); // Convert back to list

        distinctEstate = estwise
            .map((d) => d.estateId) // Extract only `id`
            .toSet() // Remove duplicates
            .toList();
      });


      // for (int i = 0; i < divs.length; i++) {
        // print(divs[i].name);
        // print(divs[i].totalKilo);
      // }
    }
  }

  List<Weighment> getMonthlySummary(int currentPlantation, int index) {
    // Get the estate by plantationId and the index
    List<Estate> e = Estate.estates
        .where((d) => d.plantationId == currentPlantation)
        .toList();
    Estate ee = e[index]; // Select the estate by index

    // Filter and sighments by estateId
    var filteredWeighments = Weighment.weighments
        .where((d) => d.estateId == ee.id)
        .toList()
      ..sort((a, b) => a.weighmentDateTime.compareTo(b.weighmentDateTime));

    // Grouping by year and month, and calculating total weighment for each month
    Map<String, double> monthlySummary = {};

    for (var weighment in filteredWeighments) {
      // Extract year and month as a key (format: YYYY-MM)
      String yearMonthKey =
          '${weighment.weighmentDateTime.year}-${weighment.weighmentDateTime.month.toString().padLeft(2, '0')}';

      // Add the weighment to the total for that month
      if (monthlySummary.containsKey(yearMonthKey)) {
        monthlySummary[yearMonthKey] =
            monthlySummary[yearMonthKey]! + weighment.totalKilo;
      } else {
        monthlySummary[yearMonthKey] = weighment.totalKilo;
      }
    }

    // Creating a list of Weighment objects with the monthly summaries
    List<Weighment> monthlySummaryList = [];
    monthlySummary.forEach((yearMonth, totalWeighment) {
      // You can decide to set the 1st of the month as the date
      DateTime firstOfMonth = DateTime.parse('$yearMonth-01');
      monthlySummaryList.add(Weighment(
          id: 0,
          plantationId: 0,
          estateId: ee.id,
          divisionId: 0,
          harvestedFieldCount: 0,
          harvestedArea: 0,
          regKilo: 0,
          cashKilo: 0,
          blockKilo: 0,
          totalKilo: totalWeighment,
          overKilo: 0,
          checkrollName: 0,
          cashName: 0,
          pluckedAvg: 0,
          yieldPerHec: 0,
          weighmentDateTime: firstOfMonth));
    });

    // Print the summed total for the first month (just for checking)
    return monthlySummaryList;
  }

  Future<void> uploadCSV() async {
    List<Weighment> weighments = [];
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true, // Important for web
      );

      if (result != null) {
        String csvContent;
        if (result.files.single.bytes != null) {
          csvContent = utf8.decode(result.files.single.bytes!);
        } else {
          File file = File(result.files.single.path!);
          csvContent = await file.readAsString();
        }

        List<List<dynamic>> rows = const CsvToListConverter().convert(
          csvContent,
          fieldDelimiter: ',', // Adjust if your CSV uses a different delimiter
          eol: '\n',
          textDelimiter: '"',
        );

        if (rows.isNotEmpty) {
          rows.removeAt(0); // Skip the first row (headers)

          for (var row in rows) {
            if (row.isEmpty) continue;

            // Assuming the CSV columns are in a specific order:
            String estateName = row[0].toString();
            DateTime dt = convertToDateTime(row[1].toString());
            String divisionName = row[2].toString();
            int harvestedFieldCount = int.tryParse(row[3].toString()) ?? 0;
            double harvestedArea = parseStringToDouble(row[4].toString());
            double regKilo = parseStringToDouble(row[5].toString());
            double cashKilo = parseStringToDouble(row[6].toString());
            double blockKilo = parseStringToDouble(row[7].toString());
            double totalKilo = parseStringToDouble(row[8].toString());
            double overKilo = parseStringToDouble(row[9].toString());
            double checkrollName = parseStringToDouble(row[10].toString());
            double cashName = parseStringToDouble(row[11].toString());
            double pluckedAvg = parseStringToDouble(row[12].toString());
            double yieldPerHec = parseStringToDouble(row[13].toString());

            // Find the corresponding estate and division IDs
            var estate = Estate.estates.firstWhere(
              (d) => d.name == estateName,
              orElse: () =>
                  Estate(0, "", "", 0, 0), // Prevents "Bad state: No element"
            );

            var division = Division.divs.firstWhere(
              (d) => d.name == divisionName,
              orElse: () => Division(
                  0, "", "", 0, 0, 0), // Prevents "Bad state: No element"
            );

            if (estate == false) {
              print('Estate not found for name: $estateName');
            }
            if (division == false) {
              print('Division not found for name: $divisionName');
            }

            if (estate != true && division != true) {
              weighments.add(Weighment(
                id: weighments.length + 1, // Assign a unique ID
                plantationId: estate.plantationId,
                estateId: estate.id,
                divisionId: division.id,
                harvestedFieldCount: harvestedFieldCount,
                harvestedArea: harvestedArea,
                regKilo: regKilo,
                cashKilo: cashKilo,
                blockKilo: blockKilo,
                totalKilo: totalKilo,
                overKilo: overKilo,
                checkrollName: checkrollName,
                cashName: cashName,
                pluckedAvg: pluckedAvg,
                yieldPerHec: yieldPerHec,
                weighmentDateTime: dt, // Adjust as needed
              ));
            } else {
              print('Estate or Division not found for row: $row');
            }
          }

          Weighment.weighments.addAll(weighments);
          print("Total weighments added: ${Weighment.weighments.length}");
          calculate();
        }
      } else {
        print("File selection canceled");
      }
    } catch (e) {
      print("Error processing file: $e");
    }
  }

DateTime convertToDateTime(String dateString) {
  // Trim whitespace from the input string
  dateString = dateString.trim();

  // Use regex to extract year and month, handling extra spaces
  RegExp regex = RegExp(r'(\d{4})\s*-\s*([A-Za-z]+)');
  Match? match = regex.firstMatch(dateString);

  if (match == null) {
    throw FormatException("Invalid date format: $dateString");
  }

  // Extract year and month parts
  int year = int.parse(match.group(1)!);
  String monthString = match.group(2)!.toUpperCase().trim();

  // Convert the month string to the corresponding month number
  Map<String, int> months = {
    'JAN': 1, 'FEB': 2, 'MAR': 3, 'APR': 4, 'MAY': 5, 'JUN': 6,
    'JUL': 7, 'AUG': 8, 'SEP': 9, 'OCT': 10, 'NOV': 11, 'DEC': 12
  };

  if (!months.containsKey(monthString)) {
    throw FormatException("Invalid month: $monthString");
  }

  int month = months[monthString]!;

  // Create a DateTime object with the 1st day of the given month and year
  return DateTime(year, month, 1);
}


  void main() {
    // Sample input
    List<String> dates = [
      '2024 - OCT',
      '2024 - NOV',
      '2024 - DEC',
      '2024 - OCT',
      '2024 - NOV',
      '2024 - DEC'
    ];

    // Convert each string to DateTime and print
    for (var dateStr in dates) {
      DateTime dt = convertToDateTime(dateStr);
      print(dt); // Prints DateTime objects with the 1st day of each month
    }
  }

  double parseStringToDouble(String value) {
    // Remove commas and parse the string to double
    return double.tryParse(value.replaceAll(',', '')) ?? 0.0;
  }

  Color getRandomColor() {
    return Color.fromARGB(
      255, // Alpha (fully opaque)
      random.nextInt(256), // Red (0-255)
      random.nextInt(256), // Green (0-255)
      random.nextInt(256), // Blue (0-255)
    );
  }

  // Function to scroll to the next item in the row
  void _scrollToNext() {
    calculate();
    if (_scrollController.hasClients) {
      double maxScrollExtent = _scrollController.position.maxScrollExtent;
      double currentScrollPosition = _scrollController.position.pixels;

      // Scroll by one item's width
      _scrollController.animateTo(
        currentScrollPosition +
            MediaQuery.of(context).size.width, // Adjust for margin
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );

      // Loop back to the beginning if it reaches the end
      if (currentScrollPosition + MediaQuery.of(context).size.width >
          maxScrollExtent) {
        // Jump to the beginning for a seamless scroll back
        _scrollController.jumpTo(0);
      }
    }
  }



void showChartDialog(BuildContext context, Widget chart) {
  showDialog(
    context: context,
    barrierDismissible: true, // Dismiss by tapping outside
    builder: (context) {
      return Dialog(
        backgroundColor:Color.fromARGB(255, 14, 0, 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width ,
              height: MediaQuery.of(context).size.height,
              child: chart,
            ),
            Positioned(
              right: 10,
              top: 10,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
// Optional sorting by date in ascending order

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 14, 0, 24), // Top color (Blue)
              Color.fromARGB(255, 38, 1, 66), // Bottom color (Dark Blue)
            ],
          ),
        ),
        child: Column(
          children: [
            
            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
        
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Select an estate",
                        style: TextStyle(
                          // fontFamily: 'IndieFlower',
                          color: Color.fromARGB(255, 190, 245, 188),
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(
                              255, 173, 216, 230), // Light blue background
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.3),
                              blurRadius: 5,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: DropdownButton<String>(
                          value: selectedEstate,
                          hint: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Select an Estate',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              selectedEstate = newValue;
                              selectedEstateiD = Estate.estates
                                      .where((estate) =>
                                          estate.name == selectedEstate)
                                      .first
                                      .id ??
                                  0;
                            });
                            calculate();
                          },
                          items: Estate.estates
                              .where((estate) =>
                                  estate.plantationId == currentPlantation)
                              .toList()
                              .map<DropdownMenuItem<String>>((estate) {
                            return DropdownMenuItem<String>(
                              value: estate
                                  .name, // Assuming 'name' is a property of Estate
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  estate.name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          underline: SizedBox(), // Remove default underline
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Text(
                    "Date Range: ${_mindate != null ? DateFormat('MM/yyyy').format(_mindate ?? DateTime.now()) : "-"} - ${_maxdate != null ? DateFormat('MM/yyyy').format(_maxdate ?? DateTime.now()) : "-"}",
                    style: TextStyle(
                      // fontFamily: 'IndieFlower',
                      color: Color.fromARGB(255, 190, 245, 188),
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.43,
        
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      showChartDialog(context, AreaVsKiloGraph(
                      divs: divs,
                      selectedEstate: selectedEstate ?? "",
                      selectedEstateiD: selectedEstateiD,
                      width: MediaQuery.of(context).size.width * 0.32,
                      isFullScreen: true,
                    ));
                    },
                    child: AreaVsKiloGraph(
                      divs: divs,
                      selectedEstate: selectedEstate ?? "",
                      selectedEstateiD: selectedEstateiD,
                      width: MediaQuery.of(context).size.width * 0.32,
                                            isFullScreen: false,

                    ),
                  ),
                  InkWell(
                    onTap: (){
                      showChartDialog(context, TotalKiloBreakdownGraph(
                      divs: divs,
                      selectedEstate: selectedEstate ?? "",
                      selectedEstateiD: selectedEstateiD,
                      width: MediaQuery.of(context).size.width * 0.32,
                      isFullScreen: true,
                    ));
                    },
                    child: TotalKiloBreakdownGraph(
                      divs: divs,
                      selectedEstate: selectedEstate ?? "",
                      selectedEstateiD: selectedEstateiD,
                      width: MediaQuery.of(context).size.width * 0.32,
                      isFullScreen: false,
                    ),
                  ),
                       InkWell(
                        onTap: (){
                      showChartDialog(context, EstYeildPerHecGraph(estwise: estwise,selectedEstate: selectedEstate??"",selectedEstateiD: selectedEstateiD,width: MediaQuery.of(context).size.width * 0.32,distinctEstate: distinctEstate, isFullScreen: true, percentageIncrease: userPercentageIncrease,
                      ));
                    },
                        child: EstYeildPerHecGraph(estwise: estwise,selectedEstate: selectedEstate??"",selectedEstateiD: selectedEstateiD,width: MediaQuery.of(context).size.width * 0.32,distinctEstate: distinctEstate, isFullScreen: false, percentageIncrease: userPercentageIncrease,))
               
                ],
              ),
            ),
            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.43,
        
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      showChartDialog(context, NameBreakdownGraph(
                      divs: divs,
                      selectedEstate: selectedEstate ?? "",
                      selectedEstateiD: selectedEstateiD,
                      width: MediaQuery.of(context).size.width * 0.32,
                                            isFullScreen: true,

                    ),);
                    },
                    child: NameBreakdownGraph(
                      divs: divs,
                      selectedEstate: selectedEstate ?? "",
                      selectedEstateiD: selectedEstateiD,
                      width: MediaQuery.of(context).size.width * 0.32,
                                            isFullScreen: false,
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      showChartDialog(context, AverageSummeryGraph(
                      divs: divs,
                      selectedEstate: selectedEstate ?? "",
                      selectedEstateiD: selectedEstateiD,
                      width: MediaQuery.of(context).size.width * 0.32,
                                            isFullScreen: true,

                    ));
                    },
                    child: AverageSummeryGraph(
                      divs: divs,
                      selectedEstate: selectedEstate ?? "",
                      selectedEstateiD: selectedEstateiD,
                      width: MediaQuery.of(context).size.width * 0.32,
                                            isFullScreen: false,
                    ),
                  ),
              
                       InkWell(
                        onTap: (){
                      showChartDialog(context, DivYeildPerHecGraph(est: est,selectedEstate: selectedEstate??"",selectedEstateiD: selectedEstateiD,width: MediaQuery.of(context).size.width * 0.32,distinctDivisions: distinctDivisions, isFullScreen: true, percentageIncrease: userPercentageIncrease,
                    ));
                    },
                        child: DivYeildPerHecGraph(est: est,selectedEstate: selectedEstate??"",selectedEstateiD: selectedEstateiD,width: MediaQuery.of(context).size.width * 0.32,distinctDivisions: distinctDivisions, isFullScreen: false, percentageIncrease: userPercentageIncrease))               
                
                ], 
              ),
            ),
           
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //       horizontal: MediaQuery.of(context).size.width * 0.02,
            //       vertical: MediaQuery.of(context).size.height * 0.02),
            //   child: Align(
            //       alignment: Alignment.center,
            //       child: DivYeildPerHecGraph(est: est,selectedEstate: selectedEstate??"",selectedEstateiD: selectedEstateiD,width: MediaQuery.of(context).size.width * 0.9,distinctDivisions: distinctDivisions,)
            //   )
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //       horizontal: MediaQuery.of(context).size.width * 0.02,
            //       vertical: MediaQuery.of(context).size.height * 0.02),
            //   child: Align(
            //       alignment: Alignment.center,
            //       child: EstYeildPerHecGraph(estwise: estwise,selectedEstate: selectedEstate??"",selectedEstateiD: selectedEstateiD,width: MediaQuery.of(context).size.width * 0.9,distinctEstate: distinctEstate,)
            //   )
            // ),
          
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.upload_file),
        backgroundColor: Colors.green,
        onPressed: () {
         uploadCSV();
        })
    );
  }
}

class EstateData {
  String name;
  int id;
  int estateId;
  double totalKilo;
  double harvestedArea;

  double regKilo;
  double cashkilo;
  double blockKilo;
  double overkilo;

  double checkRollName;
  double cashName;

  double pluckedAvg;
  double yieldPerHec;
  DateTime dateTime;

  EstateData(
      this.name,
      this.id,
      this.estateId,
      this.totalKilo,
      this.harvestedArea,
      this.regKilo,
      this.cashkilo,
      this.blockKilo,
      this.overkilo,
      this.checkRollName,
      this.cashName,
      this.pluckedAvg,
      this.yieldPerHec,
      this.dateTime);
}

class DivData {
  String name;
  int id;
  int estateId;
  double totalKilo;
  double harvestedArea;

  double regKilo;
  double cashkilo;
  double blockKilo;
  double overkilo;

  double checkRollName;
  double cashName;

  double pluckedAvg;
  double yieldPerHec;
  DivData(
      this.name,
      this.id,
      this.estateId,
      this.totalKilo,
      this.harvestedArea,
      this.regKilo,
      this.cashkilo,
      this.blockKilo,
      this.overkilo,
      this.checkRollName,
      this.cashName,
      this.pluckedAvg,
      this.yieldPerHec);
}

class EstateWiseData {
  String name;
  int estateId;
  double totalKilo;
  double harvestedArea;

  double regKilo;
  double cashkilo;
  double blockKilo;
  double overkilo;

  double checkRollName;
  double cashName;

  double pluckedAvg;
  double yieldPerHec;
  DateTime dateTime;
  Color color;

 EstateWiseData(
     this.name,
     this.estateId,
     this.totalKilo,
     this.harvestedArea,
     this.regKilo,
     this.cashkilo,
     this.blockKilo,
     this.overkilo,
     this.checkRollName,
     this.cashName,
     this.pluckedAvg,
     this.yieldPerHec,
     this.dateTime,
     this.color,
  );

}



class EstateWiseDataSummery {
  String name;
  int estateId;
  double totalKilo;
  double harvestedArea;

  double regKilo;
  double cashkilo;
  double blockKilo;
  double overkilo;

  double checkRollName;
  double cashName;

  double pluckedAvg;
  double yieldPerHec;
  Color color;

  EstateWiseDataSummery(
      this.name,
      this.estateId,
      this.totalKilo,
      this.harvestedArea,
      this.regKilo,
      this.cashkilo,
      this.blockKilo,
      this.overkilo,
      this.checkRollName,
      this.cashName,
      this.pluckedAvg,
      this.yieldPerHec,
      this.color);
}
