class Devise {
  int id;
  String nom;

  Devise({this.id, this.nom});

  factory Devise.fromJson(Map<String, dynamic> json) {
    return Devise(
      id: json['id'],
      nom: json['nom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
    };
  }
}
