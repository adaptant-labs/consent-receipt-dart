import 'package:alpha2_countries/alpha2_countries.dart';
import 'package:consent_receipt_dart/src/consent_type.dart';
import 'package:consent_receipt_dart/src/data_categories.dart';
import 'package:consent_receipt_dart/src/purpose_specification.dart';
import 'package:validators/validators.dart';
import 'package:uuid/uuid.dart';

// CR timestamps are in seconds since the epoch
int _generateTimestamp() {
  var ms = (DateTime.now()).millisecondsSinceEpoch;
  return (ms / 1000).round();
}

/// Consent receipt generator for a set of Data Controllers and Processors.
class ConsentReceiptGenerator {
  /// List of country codes in ISO 3166-1 alpha-2 2-character format in which
  /// processing occurs.
  final List<String> countryCodes;

  /// Absolute URL to the privacy policy governing the consent request.
  final String privacyPolicy;

  /// Optional public key for verifying requests.
  final String? publicKey;

  /// List of controllers and processors involved in processing activities
  /// covered by the [ConsentReceipt].
  final List<DataController> piiControllers;

  static final Uuid _uuid = Uuid();
  static final Countries _countries = Countries();
  static bool _countryExists(String isoCode) =>
      _countries.resolveName(isoCode) != null;
  static bool _countriesExist(List<String> isoCodes) {
    for (var isoCode in isoCodes) {
      var _exists = _countryExists(isoCode);
      if (!_exists) {
        return false;
      }
    }

    return true;
  }

  ConsentReceiptGenerator({
    required this.countryCodes,
    required this.piiControllers,
    required this.privacyPolicy,
    this.publicKey,
  })  : assert(_countriesExist(countryCodes)),
        assert(isURL(privacyPolicy,
            requireProtocol: true, protocols: ['http', 'https']));

  /// Generate a consent receipt for a data subject given a specific method
  /// of collection, [Service], and [DataCategory].
  ConsentReceipt generateConsentReceipt(
          {required String collectionMethod,
          required String subjectId,
          required List<Service> services,
          List<DataCategory>? sensitiveData}) =>
      ConsentReceipt(
        piiControllers: piiControllers,
        jurisdiction: countryCodes.join(' ').toUpperCase(),
        consentTimestamp: _generateTimestamp(),
        collectionMethod: collectionMethod,
        consentReceiptID: _uuid.v4(),
        piiPrincipalId: subjectId,
        policyURL: privacyPolicy,
        publicKey: publicKey,
        services: services,
        sensitive: sensitiveData != null,
        spiCat: sensitiveData,
      );
}

/// A given purpose of data processing.
class Purpose {
  final String? purpose;
  final PurposeSpecification purposeCategory;
  final ConsentType consentType;
  final List<DataCategory> piiCategory;
  final bool primaryPurpose;
  final String termination;
  final bool thirdPartyDisclosure;
  final String? thirdPartyName;

  /// Extension for OAuth scopes pertaining to this specific purpose of processing
  final String? scopes;

  Purpose({
    this.purpose,
    this.consentType = ConsentType.explicit,
    required this.purposeCategory,
    required this.piiCategory,
    this.primaryPurpose = false,
    required this.termination,
    this.thirdPartyDisclosure = false,
    this.thirdPartyName,
    this.scopes,
  })  : assert(piiCategory.isNotEmpty),
        assert(termination.isNotEmpty),
        assert((thirdPartyDisclosure == true &&
                (thirdPartyName != null && thirdPartyName.isNotEmpty)) ||
            (thirdPartyDisclosure == false &&
                (thirdPartyName == null || thirdPartyName.isEmpty)));

  factory Purpose.fromJson(Map<String, dynamic> json) => Purpose(
        purpose: json['purpose'],
        consentType: ConsentTypeNameExtension.parseName(json['consentType'])!,
        purposeCategory: PurposeSpecificationNameExtension.parseNameWithPrefix(
            json['purposeCategory'])!,
        piiCategory: (json['piiCategory'] as List)
            .cast<String>()
            .map((category) =>
                DataCategoryNameExtension.parseNameWithPrefix(category)!)
            .toList(),
        primaryPurpose: json['primaryPurpose'],
        termination: json['termination'],
        thirdPartyDisclosure: json['thirdPartyDisclosure'],
        thirdPartyName: json['thirdPartyName'],
        scopes: json['scopes'],
      );

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};

    json['purpose'] = purpose;
    json['consentType'] = consentType.name;
    json['purposeCategory'] = purposeCategory.nameWithPrefix;
    json['piiCategory'] =
        piiCategory.map((category) => category.nameWithPrefix).toList();
    json['primaryPurpose'] = primaryPurpose;
    json['termination'] = termination;
    json['thirdPartyDisclosure'] = thirdPartyDisclosure;
    if (thirdPartyDisclosure == true) {
      json['thirdPartyName'] = thirdPartyName;
    }

    if (scopes != null) {
      json['scopes'] = scopes;
    }

    return json;
  }

  @override
  String toString() {
    return 'Purpose[purpose=$purpose, purposeCategory=$purposeCategory, piiCategory=$piiCategory, primaryPurpose=$primaryPurpose, termination=$termination, thirdPartyDisclosure=$thirdPartyDisclosure, thirdPartyName=$thirdPartyName, scopes=$scopes]';
  }
}

/// A named service and a list of the desired purposes of processing.
class Service {
  /// Service identifier
  final String service;

  /// The desired purposes of processing
  final List<Purpose> purposes;

  Service({required this.service, required this.purposes});

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        service: json['service'],
        purposes: (json['purposes'] as List)
            .map((value) => Purpose.fromJson(value))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'service': service,
        'purposes': purposes,
      };

  @override
  String toString() {
    return 'Service[service=$service, purposes=$purposes]';
  }
}

/// The postal address at which a given [DataController] or [DataProcessor] can
/// be reached.
class PostalAddress {
  final String addressCountry;
  final String addressLocality;
  final String? addressRegion;
  final String? postOfficeBoxNumber;
  final String postalCode;
  final String streetAddress;

  PostalAddress({
    required this.addressCountry,
    required this.addressLocality,
    this.addressRegion,
    this.postOfficeBoxNumber,
    required this.postalCode,
    required this.streetAddress,
  });

  factory PostalAddress.fromJson(Map<String, dynamic> json) => PostalAddress(
        addressCountry: json['addressCountry'],
        addressLocality: json['addressLocality'],
        addressRegion: json['addressionRegion'],
        postOfficeBoxNumber: json['postOfficeBoxNumber'],
        postalCode: json['postalCode'],
        streetAddress: json['streetAddress'],
      );

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};

    json['addressCountry'] = addressCountry;
    json['addressLocality'] = addressLocality;
    if (addressRegion != null) {
      json['addressRegion'] = addressRegion;
    }
    if (postOfficeBoxNumber != null) {
      json['postOfficeBoxNumber'] = postOfficeBoxNumber;
    }
    json['postalCode'] = postalCode;
    json['streetAddress'] = streetAddress;

    return json;
  }

  @override
  String toString() {
    return 'PostalAddress[addressCountry=$addressCountry, addressLocality=$addressLocality, addressRegion=$addressRegion, postOfficeBoxNumber=$postOfficeBoxNumber, postalCode=$postalCode, streetAddress=$streetAddress]';
  }
}

/// A Kantara Initiative-compliant Consent Receipt.
class ConsentReceipt {
  /// The version of the specification that the receipt conforms to.
  final String version = 'KI-CR-v1.1.0';

  /// The legal jurisdiction(s) under which the processing of personal data
  /// occurs, in ISO 3166-1 alpha-2 2-character country code format. May
  /// be a single jurisdiction, or a list of possible ones separated by a space.
  ///
  /// e.g. "DE AT IT"
  final String jurisdiction;

  /// Timestamp of when consent was issued, in seconds since the UNIX epoch
  int? consentTimestamp;

  /// Method of collection - how consent was obtained, e.g. "web form"
  final String collectionMethod;

  /// Consent Receipt ID, implemented as a Unique identifier (UUIDv4)
  final String consentReceiptID;

  /// The Data Controller's public key (optional)
  final String? publicKey;

  /// OPTIONAL: Language in which the consent was obtained. MUST use
  /// ISO 639-1:2002 if this field is used.
  final String? language;

  /// PII Principal-provided identifier. E.g., email address, claim,
  /// defined/namespace. Consent is not possible without an identifier.
  final String piiPrincipalId;

  /// The identity and company of the data controller and any party nominated to
  /// be data controller on behalf of the organisation
  final List<DataController> piiControllers;

  /// Privacy policy URL of the service referred to by the receipt
  /// e.g. http://example.com/privacy
  final String policyURL;

  /// A [Service] or group of services for which PII is being collected,
  /// together with the service-specific purposes of processing.
  final List<Service> services;

  /// Indicates whether the consent interaction contains PII that is designated
  /// as sensitive.
  final bool sensitive;

  /// Sensitive Categories of data for a given jurisdiction
  final List<DataCategory>? spiCat;

  ConsentReceipt({
    required this.jurisdiction,
    this.consentTimestamp,
    required this.collectionMethod,
    required this.consentReceiptID,
    this.publicKey,
    this.language,
    required this.piiPrincipalId,
    required this.piiControllers,
    required this.policyURL,
    required this.services,
    this.sensitive = false,
    this.spiCat,
  })  : assert(piiPrincipalId.isNotEmpty),
        assert(piiControllers.isNotEmpty),
        assert(policyURL.isNotEmpty),
        assert(services.isNotEmpty),
        assert((sensitive == true && spiCat != null) ||
            (sensitive == false && spiCat == null));

  factory ConsentReceipt.fromJson(Map<String, dynamic> json) => ConsentReceipt(
        jurisdiction: json['jurisdiction'],
        consentTimestamp: json['consentTimestamp'],
        collectionMethod: json['collectionMethod'],
        consentReceiptID: json['consentReceiptID'],
        publicKey: json['publicKey'],
        language: json['language'],
        piiPrincipalId: json['piiPrincipalId'],
        piiControllers: (json['piiControllers'] as List)
            .map((value) => DataController.fromJson(value))
            .toList(),
        policyURL: json['policyURL'],
        services: (json['services'] as List)
            .map((value) => Service.fromJson(value))
            .toList(),
        sensitive: json['sensitive'],
        spiCat: (json['spiCat'] as List)
            .cast<String>()
            .map((category) =>
                DataCategoryNameExtension.parseNameWithPrefix(category)!)
            .toList(),
      );

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};

    json['version'] = version;
    json['jurisdiction'] = jurisdiction;
    json['consentTimestamp'] = consentTimestamp;
    json['collectionMethod'] = collectionMethod;
    json['consentReceiptID'] = consentReceiptID;
    if (publicKey != null) {
      json['publicKey'] = publicKey;
    }
    if (language != null) {
      json['language'] = language;
    }
    json['piiPrincipalId'] = piiPrincipalId;
    json['piiControllers'] = piiControllers;
    json['policyURL'] = policyURL;
    json['services'] = services;
    json['sensitive'] = sensitive;
    json['spiCat'] = spiCat != null
        ? spiCat!.map((category) => category.nameWithPrefix).toList()
        : [];
    return json;
  }

  @override
  String toString() {
    return 'ConsentReceipt[version=$version, jurisdiction=$jurisdiction, consentTimestamp=$consentTimestamp, collectionMethod=$collectionMethod, consentReceiptID=$consentReceiptID, publicKey=$publicKey, language=$language, piiPrincipalId=$piiPrincipalId, piiControllers=$piiControllers, policyURL=$policyURL, services=$services, sensitive=$sensitive, spiCat=$spiCat]';
  }

  void updateTimestamp() {
    consentTimestamp = _generateTimestamp();
  }
}

/// A Data Controller or Processor responsible for controlling or processing PII.
class DataController {
  /// Legal name of the first controller who collects the data
  final String piiController;

  /// Processor working on behalf of a [DataController] or other [DataProcessor]
  final bool onBehalf;

  /// Contact name of the controller
  final String contact;

  /// The [PostalAddress] at which the controller can be reached
  final PostalAddress address;

  /// An email address at which the controller can be reached
  final String email;

  /// A phone number at which the controller can be reached
  final String phone;

  /// An optional URL for the controller's website
  final String? piiControllerURL;

  DataController({
    required this.piiController,
    this.onBehalf = false,
    required this.contact,
    required this.address,
    required this.email,
    required this.phone,
    this.piiControllerURL,
  })  : assert(piiController.isNotEmpty),
        assert(contact.isNotEmpty),
        assert(email.isNotEmpty),
        assert(phone.isNotEmpty);

  factory DataController.fromJson(Map<String, dynamic> json) => DataController(
        piiController: json['piiController'],
        onBehalf: json['on_behalf'],
        contact: json['contact'],
        address: PostalAddress.fromJson(json['address']),
        email: json['email'],
        phone: json['phone'],
        piiControllerURL: json['piiControllerURL'],
      );

  Map<String, dynamic> toJson() => {
        'piiController': piiController,
        'on_behalf': onBehalf,
        'contact': contact,
        'address': address,
        'email': email,
        'phone': phone,
        'piiControllerURL': piiControllerURL,
      };

  @override
  String toString() {
    return 'DataController=[piiController=$piiController, onBehalf=$onBehalf, contact=$contact, address=$address, email=$email, phone=$phone, piiControllerURL=$piiControllerURL]';
  }
}

/// Convenience type for a data processor acting on behalf of a [DataController].
typedef DataProcessor = DataController;
