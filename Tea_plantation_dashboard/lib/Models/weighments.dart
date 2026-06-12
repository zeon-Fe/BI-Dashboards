import 'dart:math';

class Weighment {
  int id;
  int plantationId;
  int estateId;
  int divisionId;
  int harvestedFieldCount;
  double harvestedArea;
  double regKilo;
  double cashKilo;
  double blockKilo;
  double totalKilo;
  double overKilo;
  double checkrollName;
  double cashName;
  double pluckedAvg;
  double yieldPerHec;
  DateTime weighmentDateTime;

  // Constructor
  Weighment(
      {required this.id,
      required this.plantationId,
      required this.estateId,
      required this.divisionId,
      required this.harvestedFieldCount,
      required this.harvestedArea,
      required this.regKilo,
      required this.cashKilo,
      required this.blockKilo,
      required this.totalKilo,
      required this.overKilo,
      required this.checkrollName,
      required this.cashName,
      required this.pluckedAvg,
      required this.yieldPerHec,
      required this.weighmentDateTime});

  static List<Weighment> weighments = [];

  // Method to generate random weighments
  static void generateWeighments(int count) {
    Random random = Random();
    for (int i = 0; i < count; i++) {
      weighments.add(Weighment(
        id: i + 1,
        plantationId: random.nextInt(100),
        estateId: random.nextInt(50),
        divisionId: random.nextInt(30),
        harvestedFieldCount: random.nextInt(10),
        harvestedArea: random.nextDouble() * 10,
        regKilo: random.nextDouble() * 100,
        cashKilo: random.nextDouble() * 100,
        blockKilo: random.nextDouble() * 100,
        totalKilo: random.nextDouble() * 500,
        overKilo: random.nextDouble() * 50,
        checkrollName: 0,
        cashName: 0,
        pluckedAvg: random.nextDouble() * 20,
        yieldPerHec: random.nextDouble() * 30,
        weighmentDateTime: DateTime.now(),
      ));
    }
  }
}
