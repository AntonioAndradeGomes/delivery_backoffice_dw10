class PaymentTypeModel {
  final int? id;
  final String name;
  final String acronym;
  final bool enable;

  PaymentTypeModel({
    this.id,
    required this.name,
    required this.acronym,
    required this.enable,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'acronym': acronym,
      'enable': enable,
    };
  }

  factory PaymentTypeModel.fromMap(Map<String, dynamic> map) {
    return PaymentTypeModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: (map['name'] ?? '') as String,
      acronym: (map['acronym'] ?? '') as String,
      enable: (map['enable'] ?? false) as bool,
    );
  }
}
