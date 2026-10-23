class Client {
  int id;
  String firstName;
  String lastName;
  String address;
  String phone;
  String email;
  bool archiver;
  DateTime createdAt;
  String notes;

  Client({
    this.id,
    this.firstName,
    this.lastName,
    this.address,
    this.phone,
    this.email,
    this.createdAt,
    this.notes,
    this.archiver,
  });

  bool isEqual(Client other) {
    return id == other.id &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        address == other.address &&
        phone == other.phone &&
        email == other.email &&
        archiver == other.archiver &&
        createdAt == other.createdAt &&
        notes == other.notes;
  }

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      archiver: json['archiver'] == 1,
      createdAt: DateTime.parse(json['createdAt']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'phone': phone,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      'notes': notes,
      'archiver': archiver ? 1 : 0,
    };
  }

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}';

  Client copyWith({
    String id,
    String firstName,
    String lastName,
    String address,
    String phone,
    String email,
    DateTime createdAt,
    String notes,
    bool archiver,
    String operation,
  }) {
    return Client(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
      archiver: archiver ?? this.archiver,
    );
  }
}
