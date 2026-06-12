class Estate {
  int id;
  String name;
  String code;
  int plantationId;
  late double totalWeighment;
  double land;

  // Constructor
  Estate(this.id, this.name,this.code , this.plantationId, this.land);

  // List of plantations
  static List<Estate> estates = [
    
    // Estates for Plantation 1 (Kelani Valley Plantation)
    Estate(1, "AnnField","AN", 1, 65),
    Estate(2, "Pedro","PD", 1, 115.78),
    Estate(3, "Nuware Eliya","NE", 1, 89.67),

    // Estates for Plantation 2 (Talawakelle Valley Plantation)
    Estate(4, "Bearwell","BW", 2, 56.78),
    Estate(5, "Calsay", "CA",2, 47.89),
    Estate(6, "Deniyaya","DN", 2, 102),

    // Estates for Plantation 3 (Horana Plantation)
    Estate(7, "Millakanda","ML", 3, 65.9),
    Estate(8, "Alton","AL", 3, 73),
    Estate(9, "Bambrakelly","BK", 3, 46.89),
  ];
}


