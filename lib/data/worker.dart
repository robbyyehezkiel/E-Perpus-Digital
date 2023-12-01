class Worker {
  final String nip; // Use the nip Worker as a unique identifier
  final String name;
  final String handphone;
  final String address;

  Worker({
    required this.nip,
    required this.name,
    required this.handphone,
    required this.address,
  });

  // Convert Worker object to a Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'nip': nip,
      'name': name,
      'handphone': handphone,
      'address': address,
    };
  }

  // Convert a Map to a Worker object
  factory Worker.fromMap(Map<String, dynamic> map) {
    return Worker(
      nip: map['nip'],
      name: map['name'],
      handphone: map['handphone'],
      address: map['address'],
    );
  }
}
