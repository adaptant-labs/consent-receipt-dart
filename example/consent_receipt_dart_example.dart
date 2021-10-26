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

void main() {
  final dataController = DataController(
    piiController: 'Adaptant Solutions AG',
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

  var dataProcessor = DataProcessor(
      piiController: 'My Data Processor',
      onBehalf: true,
      contact: 'John Smith',
      address: PostalAddress(
        addressCountry: 'US',
        addressLocality: 'New York',
        addressRegion: 'NY',
        postalCode: '10163',
        streetAddress: '123 Street Address',
      ),
      email: 'privacy@mydataprocessor.tld',
      phone: '1-234-5678',
      piiControllerURL: 'https://mydataprocessor.tld');

  print(dataProcessor.toString());

  var generator = ConsentReceiptGenerator(
    countryCodes: ['DE'],
    privacyPolicy: 'https://www.adaptant.io/privacy-policy',
    piiControllers: [dataController],
  );

  var defaultService = Service(
    purposes: [
      Purpose(
        purpose: 'To provide contracted services',
        purposeCategory: PurposeSpecification.ContractedService,
        primaryPurpose: true,
        termination: 'Subscription end date + 1 year',
        thirdPartyDisclosure: false,
        piiCategory: [
          DataCategory.AssetData,
          DataCategory.Biometric,
        ],
      ),
    ],
    service: 'default service name',
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

  final jsonStr = json.encode(consentReceipt.toJson());
  prettyPrintJson(jsonStr);

  // Write to file
  File('sample-cr.json').writeAsStringSync(jsonStr);

  // Now read
  final data = File('sample-cr.json').readAsStringSync();
  final cr = ConsentReceipt.fromJson(json.decode(data));

  print(cr);

  File('sample-cr.json').deleteSync();

  if (consentReceipt.consentReceiptID == cr.consentReceiptID) {
    print('Parsing succeeded');
  } else {
    print('Something went wrong');
  }
}
