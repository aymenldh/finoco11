import 'dart:convert';

class LogInHelper {
  String? email;
  DateTime? lastLogin;
  int? tentative;
  DateTime? blockUntil;
  LogInHelper({
    this.email,
    this.lastLogin,
    this.tentative,
    this.blockUntil,
  });

  LogInHelper copyWith({
    String? email,
    DateTime? lastLogin,
    int? tentative,
    DateTime? blockUntil,
  }) {
    return LogInHelper(
      email: email ?? this.email,
      lastLogin: lastLogin ?? this.lastLogin,
      tentative: tentative ?? this.tentative,
      blockUntil: blockUntil ?? this.blockUntil,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'lastLogin': lastLogin!.millisecondsSinceEpoch,
      'tentative': tentative,
      'blockUntil': blockUntil?.millisecondsSinceEpoch,
    };
  }

  factory LogInHelper.fromMap(Map<String, dynamic> map) {
    return LogInHelper(
      email: map['email'] ?? '',
      lastLogin: DateTime.fromMillisecondsSinceEpoch(map['lastLogin']),
      tentative: map['tentative'] ?? 0,
      blockUntil: map['blockUntil'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['blockUntil']),
    );
  }

  String toJson() => json.encode(toMap());

  factory LogInHelper.fromJson(String tentative) =>
      LogInHelper.fromMap(json.decode(tentative));
}
