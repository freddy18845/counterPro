class SignOnUserInfo {
  String signOnID;
  String fullName;
  String phoneNumber;
  String emailAddress;
  String outlets;
  String accessLevel;
  String accountStatus;

  SignOnUserInfo({
    required this.signOnID,
    required this.fullName,
    required this.phoneNumber,
    required this.emailAddress,
    required this.outlets,
    required this.accessLevel,
    required this.accountStatus,
  });

  factory SignOnUserInfo.fromJson(Map<String, dynamic> json) {
    return SignOnUserInfo(
      signOnID: json['SignOnID'],
      fullName: json['FullName'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      emailAddress: json['EmailAddress'] ?? '',
      outlets: json['Outlets'] ?? '',
      accessLevel: json['AccessLevel'] ?? '',
      accountStatus: json['AccountStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'SignOnID': signOnID,
        'FullName': fullName,
        'PhoneNumber': phoneNumber,
        'EmailAddress': emailAddress,
        'Outlets': outlets,
        'AccessLevel': accessLevel,
        'AccountStatus': accountStatus,
      };
}
