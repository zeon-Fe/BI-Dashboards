import 'package:flutter/material.dart';

class Plantation {
  int id;
  String name;
  String imageName;
   double totalWeighment;
   late Color Color1;
      late Color Color2;
      
  // Constructor
  Plantation(this.id, this.name, this.imageName, this.totalWeighment, this.Color1);

  // List of plantations
  static List<Plantation> plantations = [
    Plantation(1, "Kelani Valley Plantation", "KVPL",0, Colors.white),
    Plantation(2, "Talawakelle Valley Plantation", "TTEL",0,Colors.white),
    Plantation(3, "Horana Plantation", "HRPL",0,Colors.white),
  ];
}
