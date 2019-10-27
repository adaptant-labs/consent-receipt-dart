import 'dart:convert';

ConsentReceipt consentReceiptFromJson(String str) =>
    ConsentReceipt.fromJson(json.decode(str));

String consentReceiptToJson(ConsentReceipt data) => json.encode(data.toJson());

class ConsentReceipt {
  // This is the legal jurisdiction under which the processing of personal data
  // occurs, in ISO 3166-1 alpha-2 2-character country code format, e.g. "DE"
  String jurisdiction;

  // Timestamp of when consent was issued, e.g. 1435367226
  int iat;

  // Method of collection - how consent was obtained, e.g. "web form"
  String moc;

  // URL of Issuer, in HTTPS
  String iss;

  // Unique identifier (UUIDv4)
  String jti;

  // Subject provided identifier, email address - or Claim, defined/namespaced
  // e.g. example@example.com
  String sub;

  // The identity and company of the data controller and any party nominated to
  // be data controller on behalf of the organisation
  DataController dataController;

  // Privacy policy URL of the service referred to by the receipt
  // e.g. http://example.com/privacy
  String policyUri;

  // Explicit, Specific and Legitimate: interpreted here as: 'Naming the
  // Service' and 'Stating the Active Purpose '
  //
  // e.g. [Bob’s store, delivery, ] or [[" CISWG Membership", "Join"]]
  List<List<String>> purpose;

  // Category of data - In many jurisdictions their are additional notice and
  // administrative requirements for the collection, storage and processing of
  // Sensitive Personal Information Categories, e.g. [ "health" ].
  List<String> sensitive;

  // This refers to the sharing of personal information collected about the
  // individual, with another external party by the data controller
  // (service provider). Should list categories of PII shared, from above list
  // and under what purpose. Sharing is also a container for listing trust marks
  // and trust protocols.
  //
  // e.g. {party_name: "3rd Party Name or/3rd Party Category"}
  Sharing sharing;

  // Link to the short notice enables usability and layered policy. to provide
  // enhanced transparency about data collection and information sharing
  // practices, e.g. http://example.com/shortnotice
  String notice;

  // What you’re allowed to do on the service (these can be tied to legal /
  // business / technical layers). Space separated. e.g., "read update"
  String scopes;

  ConsentReceipt({
    this.jurisdiction,
    this.iat,
    this.moc,
    this.iss,
    this.jti,
    this.sub,
    this.dataController,
    this.policyUri,
    this.purpose,
    this.sensitive,
    this.sharing,
    this.notice,
    this.scopes,
  });

  factory ConsentReceipt.fromJson(Map<String, dynamic> json) => ConsentReceipt(
    jurisdiction: json["jurisdiction"],
    iat: json["iat"],
    moc: json["moc"],
    iss: json["iss"],
    jti: json["jti"],
    sub: json["sub"],
    dataController: DataController.fromJson(json["data_controller"]),
    policyUri: json["policy_uri"],
    purpose: List<List<String>>.from(
        json["purpose"].map((x) => List<String>.from(x.map((x) => x)))),
    sensitive: List<String>.from(json["sensitive"].map((x) => x)),
    sharing: Sharing.fromJson(json["sharing"]),
    notice: json["notice"],
    scopes: json["scopes"],
  );

  Map<String, dynamic> toJson() => {
    "jurisdiction": jurisdiction,
    "iat": iat,
    "moc": moc,
    "iss": iss,
    "jti": jti,
    "sub": sub,
    "data_controller": dataController.toJson(),
    "policy_uri": policyUri,
    "purpose": List<dynamic>.from(
        purpose.map((x) => List<dynamic>.from(x.map((x) => x)))),
    "sensitive": List<dynamic>.from(sensitive.map((x) => x)),
    "sharing": sharing.toJson(),
    "notice": notice,
    "scopes": scopes,
  };

  @override
  String toString() {
    return 'ConsentReceipt[jurisdiction=$jurisdiction, iat=$iat, moc=$moc, iss=$iss, jti=$jti, sub=$sub, dataController=$dataController, policyUri=$policyUri, purpose=$purpose, sensitive=$sensitive, sharing=$sharing, notice=$notice, scopes=$scopes]';
  }

  // CR timestamps are in seconds since the epoch
  int generateTimestamp() {
    var ms = (DateTime.now()).millisecondsSinceEpoch;
    return (ms / 1000).round();
  }
}

class DataController {
  bool onBehalf;
  String contact;
  String company;
  String address;
  String email;
  String phone;

  DataController({
    this.onBehalf,
    this.contact,
    this.company,
    this.address,
    this.email,
    this.phone,
  });

  factory DataController.fromJson(Map<String, dynamic> json) => DataController(
    onBehalf: json["on_behalf"],
    contact: json["contact"],
    company: json["company"],
    address: json["address"],
    email: json["email"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "on_behalf": onBehalf,
    "contact": contact,
    "company": company,
    "address": address,
    "email": email,
    "phone": phone,
  };

  @override
  String toString() {
    return 'DataController=[onBehalf=$onBehalf, contact=$contact, company=$company, address=$address, email=$email, phone=$phone]';
  }
}

class Sharing {
  List<String> sharing;
  String partyName;
  String purpose;

  Sharing({
    this.sharing,
    this.partyName,
    this.purpose,
  });

  factory Sharing.fromJson(Map<String, dynamic> json) => Sharing(
    sharing: json["sharing"].cast<String>(),
    partyName: json["party_name"],
    purpose: json["purpose"],
  );

  Map<String, dynamic> toJson() => {
    "sharing": sharing,
    "party_name": partyName,
    "purpose": purpose,
  };

  @override
  String toString() {
    return 'Sharing[sharing=$sharing, partyName=$partyName, purpose=$purpose]';
  }
}
