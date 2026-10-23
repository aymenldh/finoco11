import 'package:finoco/core/models/type_transaction.dart';

class Iteration {
  int id;
  int idFolder;
  int idClient;
  String name;
  double amountTND;
  double amountDevise;
  double taux;
  String devise;
  String description;
  DateTime createdAt;
  TypeTransaction type; // 'payment' or 'service'
  String operation;

  Iteration({
    this.id,
    this.idFolder,
    this.idClient,
    this.name,
    this.amountTND,
    this.amountDevise,
    this.taux,
    this.devise,
    this.description,
    this.createdAt,
    this.type,
    this.operation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idFolder': idFolder,
      'idClient': idClient,
      'name': name,
      'amountTND': amountTND,
      'amountDevise': amountDevise,
      'taux': taux,
      'devise': devise,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'type': type.name,
      'operation': operation,
    };
  }

  static Iteration fromMap(Map<String, dynamic> map) {
    return Iteration(
      id: map['id'],
      idFolder: map['idFolder'],
      idClient: map['idClient'],
      operation: map['operation'],
      name: map['name'],
      amountTND: double.tryParse(map['amountTND'].toString()),
      amountDevise: double.tryParse(map['amountDevise'].toString()),
      taux: double.tryParse(map['taux'].toString()),
      devise: map['devise'],
      description: map['description'],
      createdAt:
          map['createdAt'] == null ? null : DateTime.parse(map['createdAt']),
      type: TypeTransactionExtension.fromString(map['type']),
    );
  }

  Iteration copyWith({
    int id,
    int idFolder,
    int idClient,
    String name,
    double amountTND,
    double amountDevise,
    double taux,
    String devise,
    String description,
    DateTime createdAt,
    TypeTransaction type,
    String operation,
  }) {
    return Iteration(
      id: id ?? this.id,
      idFolder: idFolder ?? this.idFolder,
      name: name ?? this.name,
      amountTND: amountTND ?? this.amountTND,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      amountDevise: amountDevise ?? this.amountDevise,
      taux: taux ?? this.taux,
      devise: devise ?? this.devise,
      idClient: idClient ?? this.idClient,
      operation: operation ?? this.operation,
    );
  }
}
