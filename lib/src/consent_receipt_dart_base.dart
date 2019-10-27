import 'dart:convert';
import 'package:alpha2_countries/alpha2_countries.dart';
import 'package:consent_receipt_dart/src/data_categories.dart';
import 'package:consent_receipt_dart/src/purpose_specification.dart';
import 'package:validators/validators.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

ConsentReceipt consentReceiptFromJson(String str) =>
    ConsentReceipt.fromJson(json.decode(str));

String consentReceiptToJson(ConsentReceipt data) => json.encode(data.toJson());

// CR timestamps are in seconds since the epoch
int generateTimestamp() {
  var ms = (DateTime.now()).millisecondsSinceEpoch;
  return (ms / 1000).round();
}

class ConsentReceiptGenerator {
  final String countryCode;
  final String privacyPolicy;
  final String shortNotice;
  final String publicKey;

  final List<DataController> piiControllers;

  static final Uuid _uuid = Uuid();
  static final Countries _countries = Countries();
  static bool countryExists(String isoCode) =>
      _countries.resolveName(isoCode) != null;

  ConsentReceiptGenerator({
    @required this.countryCode,
    @required this.piiControllers,
    @required this.privacyPolicy,
    this.shortNotice,
    this.publicKey,
  })  : assert(countryExists(countryCode)),
        assert(isURL(privacyPolicy,
            requireProtocol: true, protocols: ['http', 'https'])),
        assert(shortNotice == null ||
            isURL(shortNotice,
                requireProtocol: true, protocols: ['http', 'https']));

  ConsentReceipt generateConsentReceipt(
      {@required String collectionMethod,
      @required String subjectId,
      @required List<Service> services,
      List<DataCategory> sensitiveData}) {
    final ConsentReceipt _cr = ConsentReceipt(
      piiControllers: this.piiControllers,
      jurisdiction: this.countryCode.toUpperCase(),
      consentTimestamp: generateTimestamp(),
      collectionMethod: collectionMethod,
      consentReceiptID: _uuid.v4(),
      piiPrincipalId: subjectId,
      policyURL: this.privacyPolicy,
      publicKey: publicKey ?? '',
      services: services,
      sensitive: sensitiveData != null,
      spiCat: sensitiveData,
    );

    return _cr;
  }
}

class Purpose {
  final String purpose;
  final PurposeSpecification purposeCategory;
  final String consentType;
  final List<DataCategory> piiCategory;
  final bool primaryPurpose;
  final String termination;
  final bool thirdPartyDisclosure;
  final String thirdPartyName;

  Purpose({
    this.purpose,
    this.consentType = "EXPLICIT",
    @required this.purposeCategory,
    @required this.piiCategory,
    this.primaryPurpose = false,
    @required this.termination,
    this.thirdPartyDisclosure = false,
    this.thirdPartyName,
  })  : assert(consentType != null && consentType.isNotEmpty),
        assert(piiCategory != null && piiCategory.isNotEmpty),
        assert(termination != null && termination.isNotEmpty),
        assert((thirdPartyDisclosure == true &&
                (thirdPartyName != null || thirdPartyName.isNotEmpty)) ||
            (thirdPartyDisclosure == false &&
                (thirdPartyName == null || thirdPartyName.isEmpty)));

  factory Purpose.fromJson(Map<String, dynamic> json) => Purpose(
        purpose: json['purpose'],
        consentType: json['consentType'],
        purposeCategory:
            purposeStringToPurposeSpecification(json['purposeCategory']),
        piiCategory: (json['piiCategory'] as List)
            .cast<String>()
            .map((category) => categoryStringToDataCategory(category))
            .toList(),
        primaryPurpose: json['primaryPurpose'],
        termination: json['termination'],
        thirdPartyDisclosure: json['thirdPartyDisclosure'],
        thirdPartyName: json['thirdPartyName'],
      );

  Map<String, dynamic> toJson() => {
        "purpose": purpose,
        "consentType": consentType,
        "purposeCategory": purposeCategory.purposeNameWithPrefix,
        "piiCategory": piiCategory
            .map((category) => category.categoryNameWithPrefix)
            .toList(),
        "primaryPurpose": primaryPurpose,
        "termination": termination,
        "thirdPartyDisclosure": thirdPartyDisclosure,
        "thirdPartyName": thirdPartyName,
      };

  @override
  String toString() {
    return 'Purpose[purpose=$purpose, purposeCategory=$purposeCategory, piiCategory=$piiCategory, primaryPurpose=$primaryPurpose, termination=$termination, thirdPartyDisclosure=$thirdPartyDisclosure, thirdPartyName=$thirdPartyName]';
  }
}

class Service {
  final String service;
  final List<Purpose> purposes;

  Service({@required this.service, @required this.purposes});

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        service: json['service'],
        purposes: (json['purposes'] as List)
            .map((value) => Purpose.fromJson(value))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "service": service,
        "purposes": purposes,
      };

  @override
  String toString() {
    return 'Service[service=$service, purposes=$purposes]';
  }
}

class PostalAddress {
  final String addressCountry;
  final String addressLocality;
  final String addressRegion;
  final String postOfficeBoxNumber;
  final String postalCode;
  final String streetAddress;

  PostalAddress({
    @required this.addressCountry,
    @required this.addressLocality,
    this.addressRegion,
    this.postOfficeBoxNumber,
    @required this.postalCode,
    @required this.streetAddress,
  });

  factory PostalAddress.fromJson(Map<String, dynamic> json) => PostalAddress(
        addressCountry: json['addressCountry'],
        addressLocality: json['addressLocality'],
        addressRegion: json['addressionRegion'],
        postOfficeBoxNumber: json['postOfficeBoxNumber'],
        postalCode: json['postalCode'],
        streetAddress: json['streetAddress'],
      );

  Map<String, dynamic> toJson() => {
        "addressCountry": addressCountry,
        "addressLocality": addressLocality,
        "addressRegion": addressRegion,
        "postOfficeBoxNumber": postOfficeBoxNumber,
        "postalCode": postalCode,
        "streetAddress": streetAddress
      };

  @override
  String toString() {
    return 'PostalAddress[addressCountry=$addressCountry, addressLocality=$addressLocality, addressRegion=$addressRegion, postOfficeBoxNumber=$postOfficeBoxNumber, postalCode=$postalCode, streetAddress=$streetAddress]';
  }
}

class ConsentReceipt {
  // The version of the specification that the receipt conforms to.
  final String version = "KI-CR-v1.1.0";

  // This is the legal jurisdiction(s) under which the processing of personal
  // data occurs, in ISO 3166-1 alpha-2 2-character country code format. May
  // be a single jurisdiction, or a list of possible ones separated by a space.
  //
  // e.g. "DE AT IT"
  final String jurisdiction;

  // Timestamp of when consent was issued, e.g. 1435367226
  int consentTimestamp;

  // Method of collection - how consent was obtained, e.g. "web form"
  final String collectionMethod;

  // Consent Receipt ID, implemented as a Unique identifier (UUIDv4)
  final String consentReceiptID;

  // The Data Controller's public key (optional)
  final String publicKey;

  // OPTIONAL: Language in which the consent was obtained. MUST use
  // ISO 639-1:2002 [ISO 639] if this field is used.
  final String language;

  // PII Principal-provided identifier. E.g., email address, claim,
  // defined/namespace. Consent is not possible without an identifier.
  final String piiPrincipalId;

  // The identity and company of the data controller and any party nominated to
  // be data controller on behalf of the organisation
  final List<DataController> piiControllers;

  // Privacy policy URL of the service referred to by the receipt
  // e.g. http://example.com/privacy
  final String policyURL;

  final List<Service> services;

  // Indicates whether the consent interaction contains PII that is designated
  // as sensitive.
  final bool sensitive;

  // Sensitive Categories of data for a given jurisdiction
  final List<DataCategory> spiCat;

  ConsentReceipt({
    @required this.jurisdiction,
    this.consentTimestamp,
    @required this.collectionMethod,
    @required this.consentReceiptID,
    this.publicKey,
    this.language,
    @required this.piiPrincipalId,
    @required this.piiControllers,
    @required this.policyURL,
    @required this.services,
    this.sensitive = false,
    this.spiCat,
  })  : assert(piiPrincipalId != null && piiPrincipalId.isNotEmpty),
        assert(piiControllers != null && piiControllers.isNotEmpty),
        assert(policyURL != null && policyURL.isNotEmpty),
        assert(services != null && services.isNotEmpty),
        assert((sensitive == true && spiCat != null) ||
            (sensitive == false && spiCat == null));

  factory ConsentReceipt.fromJson(Map<String, dynamic> json) => ConsentReceipt(
        jurisdiction: json["jurisdiction"],
        consentTimestamp: json["consentTimestamp"],
        collectionMethod: json["collectionMethod"],
        consentReceiptID: json["consentReceiptID"],
        publicKey: json["publicKey"],
        language: json["language"],
        piiPrincipalId: json["piiPrincipalId"],
        piiControllers: (json["piiControllers"] as List)
            .map((value) => DataController.fromJson(value))
            .toList(),
        policyURL: json["policyURL"],
        services: (json["services"] as List)
            .map((value) => Service.fromJson(value))
            .toList(),
        sensitive: json["sensitive"],
        spiCat: (json["spiCat"] as List)
            .cast<String>()
            .map((category) => categoryStringToDataCategory(category))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "version": version,
        "jurisdiction": jurisdiction,
        "consentTimestamp": consentTimestamp,
        "collectionMethod": collectionMethod,
        "consentReceiptID": consentReceiptID,
        "publicKey": publicKey,
        "language": language,
        "piiPrincipalId": piiPrincipalId,
        "piiControllers": piiControllers,
        "policyURL": policyURL,
        "services": services,
        "sensitive": sensitive,
        "spiCat":
            spiCat.map((category) => category.categoryNameWithPrefix).toList(),
      };

  @override
  String toString() {
    return 'ConsentReceipt[version=$version, jurisdiction=$jurisdiction, consentTimestamp=$consentTimestamp, collectionMethod=$collectionMethod, consentReceiptID=$consentReceiptID, publicKey=$publicKey, language=$language, piiPrincipalId=$piiPrincipalId, piiControllers=$piiControllers, policyURL=$policyURL, services=$services, sensitive=$sensitive, spiCat=$spiCat]';
  }

  void updateTimestamp() {
    this.consentTimestamp = generateTimestamp();
  }
}

class DataController {
  // Name of the first controller who collects the data
  final String piiController;

  // Processor working on behalf of a controller or other processor
  final bool onBehalf;

  // Contact name of the controller
  final String contact;

  final PostalAddress address;
  final String email;
  final String phone;

  final String piiControllerURL;

  DataController({
    @required this.piiController,
    this.onBehalf,
    @required this.contact,
    @required this.address,
    @required this.email,
    @required this.phone,
    this.piiControllerURL,
  })  : assert(piiController != null && piiController.isNotEmpty),
        assert(contact != null && contact.isNotEmpty),
        assert(address != null),
        assert(email != null && email.isNotEmpty),
        assert(phone != null && phone.isNotEmpty);

  factory DataController.fromJson(Map<String, dynamic> json) => DataController(
        piiController: json["piiController"],
        onBehalf: json["on_behalf"],
        contact: json["contact"],
        address: PostalAddress.fromJson(json["address"]),
        email: json["email"],
        phone: json["phone"],
        piiControllerURL: json["piiControllerURL"],
      );

  Map<String, dynamic> toJson() => {
        "piiController": piiController,
        "on_behalf": onBehalf,
        "contact": contact,
        "address": address,
        "email": email,
        "phone": phone,
        "piiControllerURL": piiControllerURL,
      };

  @override
  String toString() {
    return 'DataController=[piiController=$piiController, onBehalf=$onBehalf, contact=$contact, address=$address, email=$email, phone=$phone, piiControllerURL=$piiControllerURL]';
  }
}
