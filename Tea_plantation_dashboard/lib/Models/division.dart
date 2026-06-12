class Division {
  int id;
  String name;
  String code;
  int plantationId;
    int estateId;

  late double totalWeighment;
  double land;

  // Constructor
  Division(this.id, this.name,this.code , this.estateId, this.plantationId, this.land);

  // List of plantations
  static List<Division> divs = [
    Division(1, "Annfield", "AN", 1, 1, 120),
    Division(2, "Barkindale", "BK", 1, 1, 230),
    Division(3, "Erslmare", "EM", 1, 1, 180),
    Division(4, "Kinloch", "KL", 1, 1, 250),
    Division(5, "StamfordHill", "SH", 1, 1, 210),
    Division(6, "StLeys", "SL", 1, 1, 190),
    Division(7, "Factory", "FC", 1, 1, 140),

      Division(31, "LoversLeap", "LL", 2, 1, 120),
  Division(71, "Mahagastota Lower", "ML", 2, 1, 95),
  Division(81, "Mahagastota Upper", "MU", 2, 1, 110),
  Division(51, "MoonPlains", "MP", 2, 1, 130),
  Division(41, "Nasbey", "NB", 2, 1, 105),
  Division(21, "Pedro", "PD", 2, 1, 125),
  Division(61, "Scrubs", "SC", 2, 1, 115),

    Division(30, "Lower", "LW", 3, 1, 115),
  Division(40, "Upper", "UP", 3, 1, 130),
  // Division(999, "Factory", "FAC", 3, 1, 90), 


   Division(101, "Anderson", "AND", 7, 3, 125),
  Division(102, "Mihirigeekele", "MGK", 7, 3, 140),
  Division(103, "New Division", "ND", 7, 3, 110),
  Division(104, "St. Francis", "SF", 7, 3, 130),
  Division(105, "Office", "OFF", 7, 3, 50),  // Smaller size as it's an office
  Division(106, "Factory", "FAC", 7, 3, 70),

    Division(201, "Upper", "UD", 8, 3, 135),
  Division(202, "Lower", "LD", 8, 3, 120),
  Division(203, "Beaconsfield", "BD", 8, 3, 145),
  Division(204, "Kincora", "KD", 8, 3, 130),
  Division(205, "Factory", "FAC", 8, 3, 80),

    Division(301, "Bambrakelly", "BK", 9, 3, 140),
  Division(302, "Factory", "FD", 9, 3, 75), // Smaller land size for factory
  Division(303, "Upper Cranley", "UC", 9, 3, 130),
  Division(304, "Dell", "DL", 9, 3, 120),
  Division(305, "Rahanwatte", "RW", 9, 3, 135),
  Division(306, "Queen Wood", "QW", 9, 3, 125),
  ];
}
