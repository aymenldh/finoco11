import 'package:finoco/core/models/montant_devise.dart';

class Statistiques {
  double totaleServices;
  double totalePaiements;
  double totaleServices30;
  double totalePaiements30;
  double somme;
  double sommeDevise;
  String? devise;
  List<MontantDevise> montantDevises;
  List<MontantDevise> montantDevisesService = [];
  List<MontantDevise> montantDevisesPaiement = [];

  Statistiques({
    this.totalePaiements = 0,
    this.totaleServices = 0,
    this.totalePaiements30 = 0,
    this.totaleServices30 = 0,
    this.somme = 0,
    this.sommeDevise = 0,
    this.montantDevises = const [],
  });

  factory Statistiques.fromJson(Map<String, dynamic> json) {
    return Statistiques(
      totalePaiements: (json['totalePaiements'] as num?)?.toDouble() ?? 0,
      totaleServices: (json['totaleServices'] as num?)?.toDouble() ?? 0,
      somme: (json['somme'] as num?)?.toDouble() ?? 0,
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
    double? totalePaiements,
    double? somme,
    double? totaleServices,
  }) {
    return Statistiques(
      totalePaiements: totalePaiements ?? this.totalePaiements,
      somme: somme ?? this.somme,
      totaleServices: totaleServices ?? this.totaleServices,
    );
  }
}
