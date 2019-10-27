import 'package:consent_receipt_dart/consent_receipt_dart.dart';
import 'dart:io';
import 'dart:convert';

main() {
  final data = File('example/sample-cr.json').readAsStringSync();
  final ConsentReceipt cr = consentReceiptFromJson(data);

  print(cr);
}
