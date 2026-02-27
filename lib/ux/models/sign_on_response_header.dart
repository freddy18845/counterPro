class SignOnResponseHeader {
  final String countryCode;
  final String acquiringNetworkID;
  final String acquiringNetworkName;
  final String businessID;
  final String merchantName;
  final String merchantLocation;
  final String merchantCategoryCode;
  final String deviceID;
  final String terminalType;
  final String? outletID;
  final String? outletName;

  SignOnResponseHeader({
    required this.countryCode,
    required this.acquiringNetworkID,
    required this.acquiringNetworkName,
    required this.businessID,
    required this.merchantName,
    required this.merchantLocation,
    required this.merchantCategoryCode,
    required this.deviceID,
    required this.terminalType,
    this.outletID,
    this.outletName,
  });

  factory SignOnResponseHeader.fromJson(Map<String, dynamic> json) => SignOnResponseHeader(
        countryCode: json["CountryCode"],
        acquiringNetworkID: json["AcquiringNetworkID"],
        acquiringNetworkName: json["AcquiringNetworkName"] ?? '',
        businessID: json["BusinessID"],
        merchantName: json["MerchantName"] ?? '',
        merchantLocation: json["MerchantLocation"] ?? '',
        merchantCategoryCode: json["MerchantCategoryCode"] ?? '',
        outletID: json["OutletID"] ?? '',
        outletName: json["OutletName"] ?? '',
        deviceID: json["DeviceID"],
        terminalType: json["TerminalType"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "CountryCode": countryCode,
      "AcquiringNetworkID": acquiringNetworkID,
      "AcquiringNetworkName": acquiringNetworkName,
      "BusinessID": businessID,
      "MerchantName": merchantName,
      "MerchantLocation": merchantLocation,
      "MerchantCategoryCode": merchantCategoryCode,
      "DeviceID": deviceID,
      "TerminalType": terminalType,
    };
    //Only Present in Terminal SignOn Response
    if (outletID != null) data["OutletID"] = outletID;
    if (outletName != null) data["OutletName"] = outletName;

    return data;
  }
}
