class PillResult {
  final String id;
  final String name;
  final String? strength;
  final String? imprint;
  final String? color;
  final String? shape;
  final double confidence;
  final String source;
  final String? image;
  final String? rxcui;

  PillResult({
    required this.id,
    required this.name,
    this.strength,
    this.imprint,
    this.color,
    this.shape,
    required this.confidence,
    required this.source,
    this.image,
    this.rxcui,
  });

  factory PillResult.fromJson(Map<String, dynamic> json) {
    return PillResult(
      id: json['id']?.toString() ?? '${json['name']}-${json['imprint']}',
      name: json['name'] ?? 'Unknown',
      strength: json['strength'],
      imprint: json['imprint'],
      color: json['color'],
      shape: json['shape'],
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      source: json['source'] ?? 'unknown',
      image: json['image'],
      rxcui: json['rxcui'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'strength': strength,
        'imprint': imprint,
        'color': color,
        'shape': shape,
        'confidence': confidence,
        'source': source,
        'image': image,
        'rxcui': rxcui,
      };

  /// CRITICAL: equality by backend ID ONLY
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PillResult && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
