// lib/app/data/models/company_model.dart

class Company {
  final int id;
  final String name;
  final String? logoUrl;
  final String? description;
  final String? address;

  Company({
    required this.id,
    required this.name,
    this.logoUrl,
    this.description,
    this.address,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"],
    name: json["name"],
    logoUrl: json["logo_url"],
    description: json["description"],
    address: json["address"],
  );
}
