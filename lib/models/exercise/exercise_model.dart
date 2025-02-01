class Exercise {
  final String category;
  final String name;
  final String value;

  Exercise({
    required this.category,
    required this.name,
    required this.value,
  });

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'name': name,
      'value': value,
    };
  }

  // JSON 역직렬화
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      category: json['category'],
      name: json['name'],
      value: json['value'],
    );
  }
}
