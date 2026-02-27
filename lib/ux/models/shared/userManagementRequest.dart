class UserQueryRequest {
  final UserQueryRequestHeader header;
  final String messageType;
  final String dateTime;
  final String transactionID;
  final String userManagementCode;
  final NewUserInfo? userInfo; //to support user creation
  final String mac;

  UserQueryRequest({
    required this.header,
    required this.messageType,
    required this.dateTime,
    required this.transactionID,
    required this.userManagementCode,
    this.userInfo,
    required this.mac,
  });

  factory UserQueryRequest.fromJson(Map<String, dynamic> json) {
    return UserQueryRequest(
      header: UserQueryRequestHeader.fromJson(json['Header']),
      messageType: json['MessageType'],
      dateTime: json['DateTime'],
      transactionID: json['TransactionID'],
      userManagementCode: json['UserManagementCode'],
      userInfo: json['UserInfo'] != null ? NewUserInfo.fromJson(json['UserInfo']) : null,
      mac: json['MAC'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'Header': header.toJson(),
      'MessageType': messageType,
      'DateTime': dateTime,
      'TransactionID': transactionID,
      'UserManagementCode': userManagementCode,
      'MAC': mac,
    };
    if (userInfo != null) {
      data['UserInfo'] = userInfo!.toJson();
    }
    return data;
  }
}

class UserQueryRequestHeader {
  final String countryCode;
  final String acquiringNetworkID;
  final String acquiringNetworkName;
  final String businessID;
  final String deviceID;
  final String deviceSerialNo;
  final String terminalType;
  final String tellerID;
  final String tellerName;
  final String geoPositionalData;

  UserQueryRequestHeader({
    required this.countryCode,
    required this.acquiringNetworkID,
    required this.acquiringNetworkName,
    required this.businessID,
    required this.deviceID,
    required this.deviceSerialNo,
    required this.terminalType,
    required this.tellerID,
    required this.tellerName,
    required this.geoPositionalData,
  });

  factory UserQueryRequestHeader.fromJson(Map<String, dynamic> json) {
    return UserQueryRequestHeader(
      countryCode: json['CountryCode'],
      acquiringNetworkID: json['AcquiringNetworkID'],
      acquiringNetworkName: json['AcquiringNetworkName'],
      businessID: json['BusinessID'],
      deviceID: json['DeviceID'],
      deviceSerialNo: json['DeviceSerialNo'],
      terminalType: json['TerminalType'],
      tellerID: json['TellerID'],
      tellerName: json['TellerName'],
      geoPositionalData: json['GeoPositionalData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CountryCode': countryCode,
      'AcquiringNetworkID': acquiringNetworkID,
      'AcquiringNetworkName': acquiringNetworkName,
      'BusinessID': businessID,
      'DeviceID': deviceID,
      'DeviceSerialNo': deviceSerialNo,
      'TerminalType': terminalType,
      'TellerID': tellerID,
      'TellerName': tellerName,
      'GeoPositionalData': geoPositionalData,
    };
  }
}

class NewUserInfo {
   final String signOnID;
   final String fullName;
   final String phoneNumber;
   final String emailAddress;
   final String outlets;
   final String accessLevel;
   final String status;
  final String? password;

  NewUserInfo({
    required this.signOnID,
    required this.fullName,
    required this.phoneNumber,
    required this.emailAddress,
    required this.outlets,
    required this.accessLevel,
    required this.status,
    this.password,
  });

  factory NewUserInfo.fromJson(Map<String, dynamic> json) {
    return NewUserInfo(
      signOnID: json['SignOnID'],
      fullName: json['FullName'],
      phoneNumber: json['PhoneNumber'],
      emailAddress: json['EmailAddress'],
      outlets: json['Outlets'],
      accessLevel: json['AccessLevel'],
      status: json['Status'],
      password: json['Password'], //could be null for update user
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'SignOnID': signOnID,
      'FullName': fullName,
      'PhoneNumber': phoneNumber,
      'EmailAddress': emailAddress,
      'Outlets': outlets,
      'AccessLevel': accessLevel,
      'Status': status,
    };
    if (password != null) {
      data['Password'] = password;
    }
    return data;
  }
}
