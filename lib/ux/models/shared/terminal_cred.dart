import 'dart:convert';

import 'device_data.dart';




/// --------------------
/// BusinessInfo
/// --------------------
class BusinessInfo {
  final String id;
  final String name;
  final String location;
  final String terminalId;
  final String merchantId;
  final String acquiringNetworkId;
  final String acquiringNetworkName;
  final String merchantCategoryCode;
  final String outletID;
  final String outletName;

  BusinessInfo({
    required this.id,
    required this.name,
    required this.location,
    required this.terminalId,
    required this.merchantId,
    required this.acquiringNetworkId,
    required this.acquiringNetworkName,
    required this.merchantCategoryCode,
    this.outletID = '',
    this.outletName = '',
  });

  BusinessInfo copyWith({
    String? id,
    String? name,
    String? location,
    String? terminalId,
    String? merchantId,
    String? acquiringNetworkId,
    String? acquiringNetworkName,
    String? merchantCategoryCode,
    String? outletID,
    String? outletName,
  }) {
    return BusinessInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      terminalId: terminalId ?? this.terminalId,
      merchantId: merchantId ?? this.merchantId,
      acquiringNetworkId: acquiringNetworkId ?? this.acquiringNetworkId,
      acquiringNetworkName: acquiringNetworkName ?? this.acquiringNetworkName,
      merchantCategoryCode: merchantCategoryCode ?? this.merchantCategoryCode,
      outletID: outletID ?? this.outletID,
      outletName: outletName ?? this.outletName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'terminalId': terminalId,
      'merchantId': merchantId,
      'acquiringNetworkId': acquiringNetworkId,
      'acquiringNetworkName': acquiringNetworkName,
      'merchantCategoryCode': merchantCategoryCode,
      'outletID': outletID,
      'outletName': outletName,
    };
  }

  factory BusinessInfo.fromMap(Map<String, dynamic> map) {
    return BusinessInfo(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      terminalId: map['terminalId'] ?? '',
      merchantId: map['merchantId'] ?? '',
      acquiringNetworkId: map['acquiringNetworkId'] ?? '',
      acquiringNetworkName: map['acquiringNetworkName'] ?? '',
      merchantCategoryCode: map['merchantCategoryCode'] ?? '',
      outletID: map['outletID'] ?? '',
      outletName: map['outletName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BusinessInfo.fromJson(String source) =>
      BusinessInfo.fromMap(json.decode(source));
}

/// --------------------
/// BaseUser
/// --------------------
abstract class BaseUser {
  final String signOnID;
  final String fullName;
  final String phoneNumber;
  final String emailAddress;
  final String accessLevel;
  final String accountStatus;
  final String dateCreation;
  final String dateLastSeen;
  final String outlets;

  BaseUser({
    required this.signOnID,
    required this.fullName,
    required this.phoneNumber,
    required this.emailAddress,
    required this.accessLevel,
    required this.accountStatus,
    required this.dateCreation,
    required this.dateLastSeen,
    required this.outlets,
  });
}

/// --------------------
/// StoredUser
/// --------------------
class StoredUser extends BaseUser {
  final String pin;

  StoredUser({
    required super.signOnID,
    required super.fullName,
    required this.pin,
    required super.phoneNumber,
    required super.emailAddress,
    required super.accessLevel,
    required super.accountStatus,
    required super.dateCreation,
    required super.dateLastSeen,
    required super.outlets,
  });

  factory StoredUser.fromJson(Map<String, dynamic> json) {
    return StoredUser(
      signOnID: json['signOnID'] ?? '',
      fullName: json['fullName'] ?? '',
      pin: json['pin'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      emailAddress: json['emailAddress'] ?? '',
      accessLevel: json['accessLevel'] ?? '',
      accountStatus: json['accountStatus'] ?? '',
      dateCreation: json['dateCreation'] ?? '',
      dateLastSeen: json['dateLastSeen'] ?? '',
      outlets: json['outlets'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'signOnID': signOnID,
    'fullName': fullName,
    'pin': pin,
    'phoneNumber': phoneNumber,
    'emailAddress': emailAddress,
    'accessLevel': accessLevel,
    'accountStatus': accountStatus,
    'dateCreation': dateCreation,
    'dateLastSeen': dateLastSeen,
    'outlets': outlets,
  };

  StoredUser copyWith({
    String? signOnID,
    String? fullName,
    String? pin,
    String? phoneNumber,
    String? emailAddress,
    String? accessLevel,
    String? accountStatus,
    String? dateCreation,
    String? dateLastSeen,
    String? outlets,
  }) {
    return StoredUser(
      signOnID: signOnID ?? this.signOnID,
      fullName: fullName ?? this.fullName,
      pin: pin ?? this.pin,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailAddress: emailAddress ?? this.emailAddress,
      accessLevel: accessLevel ?? this.accessLevel,
      accountStatus: accountStatus ?? this.accountStatus,
      dateCreation: dateCreation ?? this.dateCreation,
      dateLastSeen: dateLastSeen ?? this.dateLastSeen,
      outlets: outlets ?? this.outlets,
    );
  }
}

/// --------------------
/// TerminalUser
/// --------------------
class TerminalUser extends BaseUser {
  final StoredUser? currentUser;

  TerminalUser({
    required super.signOnID,
    required super.fullName,
    required super.phoneNumber,
    required super.emailAddress,
    required super.accessLevel,
    required super.accountStatus,
    required super.dateCreation,
    required super.dateLastSeen,
    required super.outlets,
    this.currentUser,
  });

  factory TerminalUser.fromJson(Map<String, dynamic> json) {
    return TerminalUser(
      signOnID: json['signOnID'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      emailAddress: json['emailAddress'] ?? '',
      accessLevel: json['accessLevel'] ?? '',
      accountStatus: json['accountStatus'] ?? '',
      dateCreation: json['dateCreation'] ?? '',
      dateLastSeen: json['dateLastSeen'] ?? '',
      outlets: json['outlets'] ?? '',
      currentUser: json['currentUser'] != null
          ? StoredUser.fromJson(json['currentUser'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'signOnID': signOnID,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
      'accessLevel': accessLevel,
      'accountStatus': accountStatus,
      'dateCreation': dateCreation,
      'dateLastSeen': dateLastSeen,
      'outlets': outlets,
      if (currentUser != null) 'currentUser': currentUser!.toJson(),
    };
  }

  TerminalUser copyWith({
    String? signOnID,
    String? fullName,
    String? phoneNumber,
    String? emailAddress,
    String? accessLevel,
    String? accountStatus,
    String? dateCreation,
    String? dateLastSeen,
    String? outlets,
    StoredUser? currentUser,
  }) {
    return TerminalUser(
      signOnID: signOnID ?? this.signOnID,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailAddress: emailAddress ?? this.emailAddress,
      accessLevel: accessLevel ?? this.accessLevel,
      accountStatus: accountStatus ?? this.accountStatus,
      dateCreation: dateCreation ?? this.dateCreation,
      dateLastSeen: dateLastSeen ?? this.dateLastSeen,
      outlets: outlets ?? this.outlets,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}

/// --------------------
/// TerminalUserBuilder
/// --------------------
class TerminalUserBuilder {
  String? signOnID;
  String? fullName;
  String? phoneNumber;
  String? emailAddress;
  String? accessLevel;
  String? accountStatus;
  String? dateCreation;
  String? dateLastSeen;
  String? outlets;
  StoredUser? currentUser;

  TerminalUserBuilder();

  TerminalUserBuilder.fromTerminalUser(TerminalUser user) {
    signOnID = user.signOnID;
    fullName = user.fullName;
    phoneNumber = user.phoneNumber;
    emailAddress = user.emailAddress;
    accessLevel = user.accessLevel;
    accountStatus = user.accountStatus;
    dateCreation = user.dateCreation;
    dateLastSeen = user.dateLastSeen;
    outlets = user.outlets;
    currentUser = user.currentUser;
  }

  TerminalUser build() {
    return TerminalUser(
      signOnID: signOnID ?? '',
      fullName: fullName ?? '',
      phoneNumber: phoneNumber ?? '',
      emailAddress: emailAddress ?? '',
      accessLevel: accessLevel ?? '',
      accountStatus: accountStatus ?? '',
      dateCreation: dateCreation ?? '',
      dateLastSeen: dateLastSeen ?? '',
      outlets: outlets ?? '',
      currentUser: currentUser,
    );
  }
}

/// --------------------
/// TerminalCredentials
/// --------------------
class TerminalCredentials {
  final String businessId;
  final String outletID;
  final String outletName;
  final String merchantName;
  final String merchantLocation;
  final bool requireLogin;
  final String activationDate;
  final DeviceData deviceData;
  final String timestamp;

  final StoredUser? activationUser;
  final StoredUser? currentUser;

  TerminalCredentials({
    required this.businessId,
    required this.outletID,
    required this.outletName,
    required this.merchantName,
    required this.merchantLocation,
    required this.requireLogin,
    required this.activationDate,
    required this.deviceData,
    required this.timestamp,
    this.activationUser,
    this.currentUser,
  });

  factory TerminalCredentials.fromJson(Map<String, dynamic> json) {
    return TerminalCredentials(
      businessId: json['businessId'] ?? '',
      outletID: json['outletID'] ?? '',
      outletName: json['outletName'] ?? '',
      merchantName: json['merchantName'] ?? '',
      merchantLocation: json['merchantLocation'] ?? '',
      requireLogin: json['requireLogin'] ?? false,
      activationDate: json['activationDate'] ?? '',
      deviceData: DeviceData.fromJson(json['deviceData']),
      timestamp: json['timestamp'] ?? '',
      activationUser: json['activationUser'] != null
          ? StoredUser.fromJson(json['activationUser'])
          : null,
      currentUser: json['currentUser'] != null
          ? StoredUser.fromJson(json['currentUser'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessId': businessId,
      'outletID': outletID,
      'outletName': outletName,
      'merchantName': merchantName,
      'merchantLocation': merchantLocation,
      'requireLogin': requireLogin,
      'activationDate': activationDate,
      'deviceData': deviceData.toJson(),
      'timestamp': timestamp,
      if (activationUser != null) 'activationUser': activationUser!.toJson(),
      if (currentUser != null) 'currentUser': currentUser!.toJson(),
    };
  }

  TerminalCredentials copyWith({
    String? businessId,
    String? outletID,
    String? outletName,
    String? merchantName,
    String? merchantLocation,
    bool? requireLogin,
    String? activationDate,
    DeviceData? deviceData,
    String? timestamp,
    StoredUser? activationUser,
    StoredUser? currentUser,
  }) {
    return TerminalCredentials(
      businessId: businessId ?? this.businessId,
      outletID: outletID ?? this.outletID,
      outletName: outletName ?? this.outletName,
      merchantName: merchantName ?? this.merchantName,
      merchantLocation: merchantLocation ?? this.merchantLocation,
      requireLogin: requireLogin ?? this.requireLogin,
      activationDate: activationDate ?? this.activationDate,
      deviceData: deviceData ?? this.deviceData,
      timestamp: timestamp ?? this.timestamp,
      activationUser: activationUser ?? this.activationUser,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}