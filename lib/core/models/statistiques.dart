import 'package:finoco/core/models/montant_devise.dart';

class Statistiques {
  double totaleServices;
  double totalePaiements;
  double totaleServices30;
  double totalePaiements30;
  double somme;
  double sommeDevise;
  String devise;
  List<MontantDevise> montantDevises;
  List<MontantDevise> montantDevisesService;
  List<MontantDevise> montantDevisesPaiement;

  Statistiques({
    this.totalePaiements,
    this.totaleServices,
    this.totalePaiements30,
    this.totaleServices30,
    this.somme,
    this.sommeDevise,
    this.montantDevises,
  });

  factory Statistiques.fromJson(Map<String, dynamic> json) {
    return Statistiques(
      totalePaiements: json['totalePaiements'],
      totaleServices: json['totaleServices'],
      somme: json['somme'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalePaiements': totalePaiements,
      'totaleServices': totaleServices,
      'somme': somme,
    };
  }

  Statistiques copyWith({
    String totalePaiements,
    String somme,
    String totaleServicesOuverts,
    int id,
    int totaleServices,
    String totalePaiementsOuverts,
  }) {
    return Statistiques(
      totalePaiements: totalePaiements ?? this.totalePaiements,
      somme: somme ?? this.somme,
      totaleServices: totaleServices ?? this.totaleServices,
    );
  }
}
