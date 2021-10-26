// ignore_for_file: constant_identifier_names

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

// Dart Enums still need some work..
extension PurposeSpecificationNameExtension on PurposeSpecification {
  int get number {
    switch (this) {
      case PurposeSpecification.CoreFunction:
        return 1;
      case PurposeSpecification.ContractedService:
        return 2;
      case PurposeSpecification.Delivery:
        return 3;
      case PurposeSpecification.ContactRequested:
        return 4;
      case PurposeSpecification.PersonalizedExperience:
        return 5;
      case PurposeSpecification.Marketing:
        return 6;
      case PurposeSpecification.MarketingThirdParties:
        return 7;
      case PurposeSpecification.SharingForDelivery:
        return 8;
      case PurposeSpecification.SharingForMarketing:
        return 9;
      case PurposeSpecification.ThirdPartySharingForCoreFunction:
        return 10;
      case PurposeSpecification.ThirdPartySharingForOthers:
        return 11;
      case PurposeSpecification.LegallyRequiredDataRetention:
        return 12;
      case PurposeSpecification.RequiredByLawEnforcementOrGovernment:
        return 13;
      case PurposeSpecification.ProtectingYourHealth:
        return 14;
      case PurposeSpecification.ProtectingOurInterests:
        return 15;
      case PurposeSpecification.ImprovePerformance:
        return 16;
      default:
        // Trigger assertion on any other value
        assert(false);
    }

    return 1;
  }

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

  String get purposeName {
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

  String get purposeNameWithPrefix {
    return number.toString() + ' - ' + purposeName;
  }
}

PurposeSpecification purposeStringToPurposeSpecification(String purposeStr) {
  var value = int.parse(purposeStr.split(' - ').first);

  switch (value) {
    case 1:
      return PurposeSpecification.CoreFunction;
    case 2:
      return PurposeSpecification.ContractedService;
    case 3:
      return PurposeSpecification.Delivery;
    case 4:
      return PurposeSpecification.ContactRequested;
    case 5:
      return PurposeSpecification.PersonalizedExperience;
    case 6:
      return PurposeSpecification.Marketing;
    case 7:
      return PurposeSpecification.MarketingThirdParties;
    case 8:
      return PurposeSpecification.SharingForDelivery;
    case 9:
      return PurposeSpecification.SharingForMarketing;
    case 10:
      return PurposeSpecification.ThirdPartySharingForCoreFunction;
    case 11:
      return PurposeSpecification.ThirdPartySharingForOthers;
    case 12:
      return PurposeSpecification.LegallyRequiredDataRetention;
    case 13:
      return PurposeSpecification.RequiredByLawEnforcementOrGovernment;
    case 14:
      return PurposeSpecification.ProtectingYourHealth;
    case 15:
      return PurposeSpecification.ProtectingOurInterests;
    case 16:
      return PurposeSpecification.ImprovePerformance;
  }

  // Unable to match value
  assert(false);

  return PurposeSpecification.CoreFunction;
}
