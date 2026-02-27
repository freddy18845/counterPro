class UserManagementResponse {
  final UserQueryResponseHeader header;
  final String messageType;
  final String dateTime;
  final String transactionID;
  final String userManagementCode;
  final String responseCode;
  final String responseText;
  final String mac;

  UserManagementResponse({
    required this.header,
    required this.messageType,
    required this.dateTime,
    required this.transactionID,
    required this.userManagementCode,
    required this.responseCode,
    required this.responseText,
    required this.mac,
  });

  factory UserManagementResponse.fromJson(Map<String, dynamic> json) {
    return UserManagementResponse(
      header: UserQueryResponseHeader.fromJson(json['Header']),
      messageType: json['MessageType'],
      dateTime: json['DateTime'],
      transactionID: json['TransactionID'],
      userManagementCode: json['UserManagementCode'],
      responseCode: json['ResponseCode'],
      responseText: json['ResponseText'],
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
      'ResponseCode': responseCode,
      'ResponseText': responseText,
      'MAC': mac,
    };
  }
}

class UserQueryResponseHeader {
  final String countryCode;
  final String acquiringNetworkID;
  final String acquiringNetworkName;
  final String businessID;
  final String deviceID;
  final String terminalType;
  final String tellerID;
  final String tellerName;

  UserQueryResponseHeader({
    required this.countryCode,
    required this.acquiringNetworkID,
    required this.acquiringNetworkName,
    required this.businessID,
    required this.deviceID,
    required this.terminalType,
    required this.tellerID,
    required this.tellerName,
  });

  factory UserQueryResponseHeader.fromJson(Map<String, dynamic> json) {
    return UserQueryResponseHeader(
      countryCode: json['CountryCode'],
      acquiringNetworkID: json['AcquiringNetworkID'],
      acquiringNetworkName: json['AcquiringNetworkName'],
      businessID: json['BusinessID'],
      deviceID: json['DeviceID'],
      terminalType: json['TerminalType'],
      tellerID: json['TellerID'],
      tellerName: json['TellerName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CountryCode': countryCode,
      'AcquiringNetworkID': acquiringNetworkID,
      'AcquiringNetworkName': acquiringNetworkName,
      'BusinessID': businessID,
      'DeviceID': deviceID,
      'TerminalType': terminalType,
      'TellerID': tellerID,
      'TellerName': tellerName,
    };
  }
}
