// ignore_for_file: constant_identifier_names

/// Classification for a given [Purpose] of processing.
enum PurposeSpecification {
  CoreFunction,
  ContractedService,
  Delivery,
  ContactRequested,
  PersonalizedExperience,
  Marketing,
  MarketingThirdParties,
  SharingForDelivery,
  SharingForMarketing,
  ThirdPartySharingForCoreFunction,
  ThirdPartySharingForOthers,
  LegallyRequiredDataRetention,
  RequiredByLawEnforcementOrGovernment,
  ProtectingYourHealth,
  ProtectingOurInterests,
  ImprovePerformance,
}

/// Bi-directional [PurposeSpecification]<->String conversion extensions.
extension PurposeSpecificationNameExtension on PurposeSpecification {
  /// The purpose ID number for a given [PurposeSpecification].
  int get number => PurposeSpecification.values[index].index;

  /// Human-readable purpose description for a given [PurposeSpecification].
  String get description {
    switch (this) {
      case PurposeSpecification.CoreFunction:
        return 'Enabling us to carry out the core functions of our site/app/services';
      case PurposeSpecification.ContractedService:
        return 'Providing contracted or requested services to you.';
      case PurposeSpecification.Delivery:
        return 'Delivering physical goods to you.';
      case PurposeSpecification.ContactRequested:
        return 'Communicating with you about information or services you specifically request.';
      case PurposeSpecification.PersonalizedExperience:
        return 'Providing you with a personalized experience of our site/app/service.';
      case PurposeSpecification.Marketing:
        return 'Communicating with you about our other services you may be interested in.';
      case PurposeSpecification.MarketingThirdParties:
        return 'Communicating with you about the services of third parties you may be interested in.';
      case PurposeSpecification.SharingForDelivery:
        return 'Providing the information to third parties to deliver our services on our behalf.';
      case PurposeSpecification.SharingForMarketing:
        return 'Providing the information to third parties to enable them to communicate with you about their own services you may be interested in.';
      case PurposeSpecification.ThirdPartySharingForCoreFunction:
        return 'Providing the information to third parties to enable them to deliver or improve their own services to you.';
      case PurposeSpecification.ThirdPartySharingForOthers:
        return 'Providing the information to third parties to enable them to deliver or improve their own services to others.';
      case PurposeSpecification.LegallyRequiredDataRetention:
        return 'Complying with our legal obligations for record keeping.';
      case PurposeSpecification.RequiredByLawEnforcementOrGovernment:
        return 'Complying with our legal obligations to provide the information to law enforcement or other regulatory/government bodies.';
      case PurposeSpecification.ProtectingYourHealth:
        return 'Protecting your vital and health interests.';
      case PurposeSpecification.ProtectingOurInterests:
        return 'Protecting our legitimate interests, yours or those of a third party.';
      case PurposeSpecification.ImprovePerformance:
        return 'Measure or improve our performance or the delivery of our services.';
      default:
        // Trigger assertion for unhandled case
        assert(false);
    }

    return '';
  }

  /// Human-readable purpose name for a given [PurposeSpecification].
  String get name {
    switch (this) {
      case PurposeSpecification.SharingForDelivery:
        return 'Sharing for Delivery';
      case PurposeSpecification.SharingForMarketing:
        return 'Sharing for Marketing';
      case PurposeSpecification.ThirdPartySharingForCoreFunction:
        return '3rd Party Sharing for Core Function';
      case PurposeSpecification.ThirdPartySharingForOthers:
        return '3rd Party Sharing for';
      case PurposeSpecification.RequiredByLawEnforcementOrGovernment:
        return 'Required by Law Enforcement or Government';
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

  /// Format a [PurposeSpecification] into a human-readable `id - description`
  /// string.
  String get nameWithPrefix {
    return number.toString() + ' - ' + name;
  }

  /// Given a non-prefixed purpose name, return its corresponding
  /// [PurposeSpecification] value, if any. Purpose matching is case
  /// insensitive.
  static PurposeSpecification? parseName(String purposeName) {
    for (var purpose in PurposeSpecification.values) {
      if (purpose.name.toLowerCase() == purposeName.toLowerCase()) {
        return purpose;
      }
    }

    return null;
  }

  /// Given a prefixed purpose name, return its corresponding
  /// [PurposeSpecification] value, if any. Purpose matching is case
  /// insensitive.
  static PurposeSpecification? parseNameWithPrefix(String prefixedPurposeName) {
    var parts = prefixedPurposeName.split(' - ');
    var value = int.parse(parts.first);
    for (var purpose in PurposeSpecification.values) {
      if (purpose.number == value &&
          purpose.name.toLowerCase() == parts.last.toLowerCase()) {
        return purpose;
      }
    }

    return null;
  }
}
