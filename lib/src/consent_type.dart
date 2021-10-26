/// Different types of consent
enum ConsentType {
  explicit,
  implicit,
  notApplicable,
}

/// Bi-directional [ConsentType]<->String conversion extensions.
extension ConsentTypeNameExtension on ConsentType {
  /// Human-readable name for a given [ConsentType].
  String get name {
    switch (this) {
      case ConsentType.notApplicable:
        return "N/A";
      default:
        // Strip off the enum class name
        final enumStr = toString().split('.')[1];
        return enumStr.toUpperCase();
    }
  }

  /// Given a specific consent type, return its corresponding [ConsentType]
  /// value, if any. Type matching is case insensitive.
  static ConsentType? parseName(String consentType) {
    for (var consent in ConsentType.values) {
      if (consent.name == consentType.toUpperCase()) {
        return consent;
      }
    }

    return null;
  }
}
