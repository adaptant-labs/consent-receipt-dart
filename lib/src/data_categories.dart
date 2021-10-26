// ignore_for_file: constant_identifier_names

/// The category of PII to be processed.
enum DataCategory {
  Biographical,
  Contact,
  Biometric,
  SocialContact,
  NetworkService,
  Health,
  Financial,
  OfficialID,
  SocialBenefitData,
  JudicialData,
  AssetData,
  HRData,
  MentalHealth,
  Membership,
  Behavioral,
  Profiling,
}

/// Bi-directional [DataCategory]<->String conversion extensions.
extension DataCategoryNameExtension on DataCategory {
  /// The category ID number for a given [DataCategory].
  int get number => DataCategory.values[index].index;

  /// Human-readable category name for a given [DataCategory].
  String get name {
    switch (this) {
      case DataCategory.NetworkService:
        return 'Network/Service';
      case DataCategory.HRData:
        return 'HR Data';
      case DataCategory.OfficialID:
        return 'Official ID';
      default:
        // Strip off the enum class name
        final enumStr = toString().split('.')[1];

        // CamelCase -> Camel Case conversion
        return enumStr
            .splitMapJoin(RegExp(r'[A-Z]'),
                onMatch: (m) => ' ${m.group(0)}', onNonMatch: (n) => n)
            .trim();
    }
  }

  /// Format a [DataCategory] into a human-readable `id - description` string.
  String get nameWithPrefix {
    return number.toString() + ' - ' + name;
  }

  /// Given a non-prefixed data category name, return its corresponding
  /// [DataCategory] value, if any. Category matching is case insensitive.
  static DataCategory? parseName(String categoryName) {
    for (var category in DataCategory.values) {
      if (category.name.toLowerCase() == categoryName.toLowerCase()) {
        return category;
      }
    }

    return null;
  }

  /// Given a prefixed data category name, return its corresponding
  /// [DataCategory] value, if any. Category matching is case insensitive.
  static DataCategory? parseNameWithPrefix(String prefixedCategoryName) {
    var parts = prefixedCategoryName.split(' - ');
    var value = int.parse(parts.first);
    for (var category in DataCategory.values) {
      if (category.number == value &&
          category.name.toLowerCase() == parts.last.toLowerCase()) {
        return category;
      }
    }

    return null;
  }
}
