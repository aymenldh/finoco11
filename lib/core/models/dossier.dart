class Dossier {
  int? id;
  int? idClient;
  String? name;
  bool? statusFolder;
  String? devise;
  bool? archiver;
  DateTime? createdAt;

  Dossier({
    this.id,
    this.idClient,
    this.name,
    this.statusFolder,
    this.createdAt,
    this.archiver,
    this.devise,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idClient': idClient,
      'name': name,
      'devise': devise,
      'statusFolder': statusFolder! ? 1 : 0,
      'archiver': archiver! ? 1 : 0,
      'createdAt': createdAt!.toIso8601String(),
    };
  }

  factory Dossier.fromJson(Map<String, dynamic> json) {
    return Dossier(
      id: json['id'],
      idClient: json['idClient'],
      name: json['name'],
      devise: json['devise'],
      archiver: json['archiver'] == 1,
      statusFolder: json['statusFolder'] == 1,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Dossier copyWith({
    int? id,
    int? idClient,
    String? name,
    bool? statusFolder,
    bool? archiver,
    DateTime? createdAt,
    String? devise,
  }) {
    return Dossier(
      id: id ?? this.id,
      idClient: idClient ?? this.idClient,
      name: name ?? this.name,
      archiver: archiver ?? this.archiver,
      statusFolder: statusFolder ?? this.statusFolder,
      createdAt: createdAt ?? this.createdAt,
      devise: devise ?? this.devise,
    );
  }
}
