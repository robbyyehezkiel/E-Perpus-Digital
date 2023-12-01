class Member {
  final String nim; // Use the nim Member as a unique identifier
  final String name;
  final String handphone;
  final String classField;

  Member({
    required this.nim,
    required this.name,
    required this.handphone,
    required this.classField,
  });

  // Convert Member object to a Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'nim': nim,
      'name': name,
      'handphone': handphone,
      'classField': classField,
    };
  }

  // Convert a Map to a Member object
  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      nim: map['nim'],
      name: map['name'],
      handphone: map['handphone'],
      classField: map['classField'],
    );
  }
}
