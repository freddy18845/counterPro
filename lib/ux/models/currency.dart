// //
// //
// // class Currency {
// //   final String code;
// //   final String name;
// //   final String alphaCode;
// //   final String symbol;
// //   final int precision;
// //
// //   final String? merchantID;
// //   final String? terminalID;
// //   final double? floorLimit;
// //   final double? ceilingLimit;
// //   final double? contactlessNoPINLimit;
// //   final double? contactlessLimit;
// //   final double? cashbackLimit;
// //
// //   Currency({
// //     required this.code,
// //     required this.alphaCode,
// //     required this.symbol,
// //     required this.name,
// //     required this.precision,
// //     this.merchantID,
// //     this.terminalID,
// //     this.floorLimit,
// //     this.ceilingLimit,
// //     this.contactlessNoPINLimit,
// //     this.contactlessLimit,
// //     this.cashbackLimit,
// //   });
// //
// //   //Do not include TellerBalanceLastUpdated Mapping
// //   factory Currency.fromJson(Map<String, dynamic> json) {
// //     return Currency(
// //       code: json['Code'] ?? '',
// //       name: json['Name'] ?? '',
// //       alphaCode: json['AlphaCode'] ?? '',
// //       symbol: json['Symbol'] ?? '',
// //       precision: int.tryParse(json['Precision'].toString()) ?? 0,
// //       merchantID: json['MerchantID'],
// //       terminalID: json['TerminalID'],
// //       floorLimit:
// //           json['FloorLimit'] != null ? double.tryParse(json['FloorLimit'].toString()) : null,
// //       ceilingLimit:
// //           json['CeilingLimit'] != null ? double.tryParse(json['CeilingLimit'].toString()) : null,
// //       contactlessNoPINLimit: json['ContactlessNoPINLimit'] != null
// //           ? double.tryParse(json['ContactlessNoPINLimit'].toString())
// //           : null,
// //       contactlessLimit: json['ContactlessLimit'] != null
// //           ? double.tryParse(json['ContactlessLimit'].toString())
// //           : null,
// //       cashbackLimit:
// //           json['CashbackLimit'] != null ? double.tryParse(json['CashbackLimit'].toString()) : null,
// //     );
// //   }
// //
// //   //Do not include tellerBalanceLastUpdated Mapping
// //   Map<String, dynamic> toJson() {
// //     return {
// //       'Code': code,
// //       'Name': name,
// //       'AlphaCode': alphaCode,
// //       'Symbol': symbol,
// //       'Precision': precision,
// //       if (merchantID != null) 'MerchantID': merchantID,
// //       if (terminalID != null) 'TerminalID': terminalID,
// //       if (floorLimit != null) 'FloorLimit': floorLimit,
// //       if (ceilingLimit != null) 'CeilingLimit': ceilingLimit,
// //       if (contactlessNoPINLimit != null) 'ContactlessNoPINLimit': contactlessNoPINLimit,
// //       if (contactlessLimit != null) 'ContactlessLimit': contactlessLimit,
// //       if (cashbackLimit != null) 'CashbackLimit': cashbackLimit,
// //     };
// //   }
// //
// //   Currency copyWith({
// //     String? code,
// //     String? name,
// //     String? alphaCode,
// //     String? symbol,
// //     int? precision,
// //     String? merchantID,
// //     String? terminalID,
// //     double? floorLimit,
// //     double? ceilingLimit,
// //     double? contactlessNoPINLimit,
// //     double? contactlessLimit,
// //     double? cashbackLimit,
// //     double? tellerBalanceAmount,
// //   }) {
// //     return Currency(
// //       code: code ?? this.code,
// //       name: name ?? this.name,
// //       alphaCode: alphaCode ?? this.alphaCode,
// //       symbol: symbol ?? this.symbol,
// //       precision: precision ?? this.precision,
// //       merchantID: merchantID ?? this.merchantID,
// //       terminalID: terminalID ?? this.terminalID,
// //       floorLimit: floorLimit ?? this.floorLimit,
// //       ceilingLimit: ceilingLimit ?? this.ceilingLimit,
// //       contactlessNoPINLimit: contactlessNoPINLimit ?? this.contactlessNoPINLimit,
// //       contactlessLimit: contactlessLimit ?? this.contactlessLimit,
// //       cashbackLimit: cashbackLimit ?? this.cashbackLimit,
// //     );
// //   }
// //
// //   @override
// //   bool operator ==(Object other) =>
// //       identical(this, other) ||
// //       other is Currency &&
// //           code == other.code &&
// //           name == other.name &&
// //           alphaCode == other.alphaCode &&
// //           symbol == other.symbol &&
// //           precision == other.precision &&
// //           merchantID == other.merchantID &&
// //           terminalID == other.terminalID;
// //
// //   // floorLimit == other.floorLimit &&
// //   // ceilingLimit == other.ceilingLimit &&
// //   // contactlessNoPINLimit == other.contactlessNoPINLimit &&
// //   // contactlessLimit == other.contactlessLimit &&
// //   // cashbackLimit == other.cashbackLimit &&
// //   // tellerAmount == other.tellerAmount;
// //
// //   @override
// //   int get hashCode => Object.hash(code, name, alphaCode, symbol, precision, merchantID, terminalID);
// //
// //   @override
// //   String toString() {
// //     return '$name ($alphaCode)';
// //   }
// // }
//
// class Currency {
//   final String code;
//   final String name;
//   final String alphaCode;
//   final String symbol;
//   final String precision;
//   final String merchantID;
//   final String terminalID;
//   final String floorLimit;
//   final String ceilingLimit;
//   final String contactlessNoPinLimit;
//   final String contactlessLimit;
//   final String cashbackLimit;
//
//   Currency({
//     required this.code,
//     required this.name,
//     required this.alphaCode,
//     required this.symbol,
//     required this.precision,
//     required this.merchantID,
//     required this.terminalID,
//     required this.floorLimit,
//     required this.ceilingLimit,
//     required this.contactlessNoPinLimit,
//     required this.contactlessLimit,
//     required this.cashbackLimit,
//   });
//
//   factory Currency.fromJson(Map<String, dynamic> json) => Currency(
//     code: json["Code"],
//     name: json["Name"],
//     alphaCode: json["AlphaCode"],
//     symbol: json["Symbol"],
//     precision: json["Precision"],
//     merchantID: json["MerchantID"],
//     terminalID: json["TerminalID"],
//     floorLimit: json["FloorLimit"],
//     ceilingLimit: json["CeilingLimit"],
//     contactlessNoPinLimit: json["ContactlessNoPINLimit"],
//     contactlessLimit: json["ContactlessLimit"],
//     cashbackLimit: json["CashbackLimit"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "Code": code,
//     "Name": name,
//     "AlphaCode": alphaCode,
//     "Symbol": symbol,
//     "Precision": precision,
//     "MerchantID": merchantID,
//     "TerminalID": terminalID,
//     "FloorLimit": floorLimit,
//     "CeilingLimit": ceilingLimit,
//     "ContactlessNoPINLimit": contactlessNoPinLimit,
//     "ContactlessLimit": contactlessLimit,
//     "CashbackLimit": cashbackLimit,
//   };
// }
//
// class AIDs {
//   final String allowAllAIDs;
//   final String aidList;
//   final String promptAIDSelection;
//
//   AIDs({required this.allowAllAIDs, required this.aidList, required this.promptAIDSelection});
//
//   factory AIDs.fromJson(Map<String, dynamic> json) => AIDs(
//     allowAllAIDs: json["AllowAllAIDs"],
//     aidList: json["AIDList"],
//     promptAIDSelection: json["PromptAIDSelection"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "AllowAllAIDs": allowAllAIDs,
//     "AIDList": aidList,
//     "PromptAIDSelection": promptAIDSelection,
//   };
// }
//
// class IINs {
//   final String allowAllIINs;
//   final String iinList;
//
//   IINs({required this.allowAllIINs, required this.iinList});
//
//   factory IINs.fromJson(Map<String, dynamic> json) =>
//       IINs(allowAllIINs: json["AllowAllIINs"], iinList: json["IINList"]);
//
//   Map<String, dynamic> toJson() => {"AllowAllIINs": allowAllIINs, "IINList": iinList};
// }
//
