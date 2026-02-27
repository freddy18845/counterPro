class PasswordChangeRequest {
  final PasswordChangeRequestHeader header;
  final String messageType;
  final String dateTime;
  final String transactionID;
  final String userManagementCode;
  final PasswordChangeUserInfo userInfo;
  final String mac;

  PasswordChangeRequest({
    required this.header,
    required this.messageType,
    required this.dateTime,
    required this.transactionID,
    required this.userManagementCode,
    required this.userInfo,
    required this.mac,
  });

  factory PasswordChangeRequest.fromJson(Map<String, dynamic> json) {
    return PasswordChangeRequest(
      header: PasswordChangeRequestHeader.fromJson(json['Header']),
      messageType: json['MessageType'],
      dateTime: json['DateTime'],
      transactionID: json['TransactionID'],
      userManagementCode: json['UserManagementCode'],
      userInfo: PasswordChangeUserInfo.fromJson(json['UserInfo']),
      mac: json['MAC'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Header': header.toJson(),
      'MessageType': messageType,
      'DateTime': dateTime,
      'TransactionID': transactionID,
      'UserManagementCode': userManagementCode,
      'UserInfo': userInfo.toJson(),
      'MAC': mac,
    };
  }
}

class PasswordChangeRequestHeader {
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

  PasswordChangeRequestHeader({
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

  factory PasswordChangeRequestHeader.fromJson(Map<String, dynamic> json) {
    return PasswordChangeRequestHeader(
      countryCode: json['CountryCode'] ?? '',
      acquiringNetworkID: json['AcquiringNetworkID'] ?? '',
      acquiringNetworkName: json['AcquiringNetworkName'] ?? '',
      businessID: json['BusinessID'] ?? '',
      deviceID: json['DeviceID'] ?? '',
      deviceSerialNo: json['DeviceSerialNo'] ?? '',
      terminalType: json['TerminalType'] ?? '',
      tellerID: json['TellerID'] ?? '',
      tellerName: json['TellerName'] ?? '',
      geoPositionalData: json['GeoPositionalData'] ?? '',
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

class PasswordChangeUserInfo {
  final String signOnID;
  final String? fullName;
  final String password;
  final String? newPassword;

  PasswordChangeUserInfo({
    required this.signOnID,
    this.fullName,
    required this.password,
    this.newPassword,
  });

  factory PasswordChangeUserInfo.fromJson(Map<String, dynamic> json) {
    return PasswordChangeUserInfo(
      signOnID: json['SignOnID'],
      fullName: json['FullName'],
      password: json['Password'],
      newPassword: json['NewPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['SignOnID'] = signOnID;
    if (fullName != null) data['FullName'] = fullName;
    data['Password'] = password;
    if (newPassword != null) data['NewPassword'] = newPassword;
    return data;
  }
}
