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

// Dart Enums still need some work..
extension DataCategoryNameExtension on DataCategory {
  int get number {
    switch (this) {
      case DataCategory.Biographical:
        return 1;
      case DataCategory.Contact:
        return 2;
      case DataCategory.Biometric:
        return 3;
      case DataCategory.SocialContact:
        return 4;
      case DataCategory.NetworkService:
        return 5;
      case DataCategory.Health:
        return 6;
      case DataCategory.Financial:
        return 7;
      case DataCategory.OfficialID:
        return 8;
      case DataCategory.SocialBenefitData:
        return 9;
      case DataCategory.JudicialData:
        return 10;
      case DataCategory.AssetData:
        return 11;
      case DataCategory.HRData:
        return 12;
      case DataCategory.MentalHealth:
        return 13;
      case DataCategory.Membership:
        return 14;
      case DataCategory.Behavioral:
        return 15;
      case DataCategory.Profiling:
        return 16;
      default:
        // Trigger assertion on any other value
        assert(false);
    }

    return 0;
  }

  String get categoryName {
    switch (this) {
      case DataCategory.NetworkService:
        return "Network/Service";
      case DataCategory.HRData:
        return "HR Data";
      case DataCategory.OfficialID:
        return "Official ID";
      default:
        // Strip off the enum class name
        final String enumStr = this.toString().split('.')[1];

        // CamelCase -> Camel Case conversion
        return enumStr
            .splitMapJoin(RegExp(r"[A-Z]"),
                onMatch: (m) => ' ${m.group(0)}', onNonMatch: (n) => n)
            .trim();
    }
  }

  String get categoryNameWithPrefix {
    return this.number.toString() + ' - ' + this.categoryName;
  }
}

DataCategory categoryStringToDataCategory(String piiCategory) {
  int value = int.parse(piiCategory.split(" - ").first);

  switch (value) {
    case 1:
      return DataCategory.Biographical;
    case 2:
      return DataCategory.Contact;
    case 3:
      return DataCategory.Biometric;
    case 4:
      return DataCategory.SocialContact;
    case 5:
      return DataCategory.NetworkService;
    case 6:
      return DataCategory.Health;
    case 7:
      return DataCategory.Financial;
    case 8:
      return DataCategory.OfficialID;
    case 9:
      return DataCategory.SocialBenefitData;
    case 10:
      return DataCategory.JudicialData;
    case 11:
      return DataCategory.AssetData;
    case 12:
      return DataCategory.HRData;
    case 13:
      return DataCategory.MentalHealth;
    case 14:
      return DataCategory.Membership;
    case 15:
      return DataCategory.Behavioral;
    case 16:
      return DataCategory.Profiling;
  }

  // Unable to match value
  assert(false);

  return DataCategory.Biographical;
}