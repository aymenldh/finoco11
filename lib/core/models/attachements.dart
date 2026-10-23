class Attachements {
  int? id;
  int? idIteration;
  String? url;
  String? type;
  String? name;
  String? distName;
  Attachements({
    this.id,
    this.url,
    this.idIteration,
    this.type,
    this.name,
    this.distName,
  });

  factory Attachements.fromJson(Map<String, dynamic> json) {
    return Attachements(
      url: json['url'],
      id: json['id'],
      idIteration: json['idIteration'],
      type: json['type'],
      name: json['name'],
      distName: json['distName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'id': id,
      'idIteration': idIteration,
      'type': type,
      'name': name,
      'distName': distName,
    };
  }

  Attachements copyWith({
    String? url,
    String? type,
    String? name,
    int? id,
    int? idIteration,
    String? distName,
  }) {
    return Attachements(
      url: url ?? this.url,
      type: type ?? this.type,
      name: name ?? this.name,
      distName: distName ?? this.distName,
      id: id ?? this.id,
      idIteration: idIteration ?? this.idIteration,
    );
  }
}
