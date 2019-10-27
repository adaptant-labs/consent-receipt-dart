import 'dart:convert';
import 'dart:io';
import 'package:consent_receipt_dart/consent_receipt_dart.dart';

JsonDecoder decoder = JsonDecoder();
JsonEncoder encoder = JsonEncoder.withIndent('  ');

void prettyPrintJson(String input) {
  var object = decoder.convert(input);
  var prettyString = encoder.convert(object);
  prettyString.split('\n').forEach((element) => print(element));
}

main() {
  final DataController dataController = DataController(
    piiController: 'Adaptant Solutions AG',
    onBehalf: true,
    contact: 'Max Musterman',
    address: PostalAddress(
      addressCountry: 'DE',
      addressLocality: 'Deisenhofen',
      addressRegion: 'BY',
      postalCode: '82041',
      streetAddress: 'Bahnhofstr. 36',
    ),
    email: 'compliance@adaptant.io',
    phone: '49-89-904101300',
    piiControllerURL: 'https://www.adaptant.io',
  );

  ConsentReceiptGenerator generator = ConsentReceiptGenerator(
    countryCode: 'DE',
    privacyPolicy: 'https://www.adaptant.io/privacy-policy',
    piiControllers: [dataController],
  );

  Service defaultService = Service(
    purposes: [
      Purpose(
        purpose: "To provide contracted services",
        purposeCategory: PurposeSpecification.ContractedService,
        primaryPurpose: true,
        termination: "Subscription end date + 1 year",
        thirdPartyDisclosure: false,
        piiCategory: [
          DataCategory.AssetData,
          DataCategory.Biometric,
        ],
      ),
    ],
    service: "default service name",
  );

  final consentReceipt = generator.generateConsentReceipt(
    collectionMethod: 'web form',
    subjectId: 'example@example.com',
    sensitiveData: [
      DataCategory.Biometric,
    ],
    services: [
      defaultService,
    ],
  );

  final jsonStr = consentReceiptToJson(consentReceipt);
  prettyPrintJson(jsonStr);

  // Write to file
  File('sample-cr.json').writeAsStringSync(jsonStr);

  // Now read
  final data = File('sample-cr.json').readAsStringSync();
  final cr = consentReceiptFromJson(data);

  print(cr);

  File('sample-cr.json').deleteSync();

  if (consentReceipt.consentReceiptID == cr.consentReceiptID) {
    print("Parsing succeeded");
  } else {
    print("Something went wrong");
  }
}
