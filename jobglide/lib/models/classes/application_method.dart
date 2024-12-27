class ApplicationMethod {
  final String type;
  final String value;
  final String? instructions;

  const ApplicationMethod({
    required this.type,
    required this.value,
    this.instructions,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
      'instructions': instructions,
    };
  }

  factory ApplicationMethod.fromJson(Map<String, dynamic> json) {
    return ApplicationMethod(
      type: json['type'] as String,
      value: json['value'] as String,
      instructions: json['instructions'] as String?,
    );
  }
}
