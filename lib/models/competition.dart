class Competition {
  int id;
  String name;
  String code;
  String logoPath;
  int reputation;

  Competition({
    required this.id,
    required this.name,
    required this.code,
    required this.logoPath,
    required this.reputation,
  });

  toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'logoPath': logoPath,
      'reputation': reputation,
    };
  }

  factory Competition.fromJson(Map<String, dynamic> json) {
    return Competition(
      id: json['id'],
      name: json['name'],
      logoPath: json['logoPath'],
      code: json['code'],
      reputation: json['reputation'],
    );
  }
}
